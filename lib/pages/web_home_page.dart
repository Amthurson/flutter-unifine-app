import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unified_front_end/providers/user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import '../providers/user_provider.dart';
import '../widgets/compatible_webview.dart';
import '../widgets/navigation_bar_widget.dart';
import '../widgets/app_drawer_menu.dart';

class WebHomePage extends StatefulWidget {
  final String? title;
  final String? url;
  final bool isHome;

  const WebHomePage({
    super.key,
    this.title,
    this.url,
    this.isHome = false,
  });

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  // final bool _canGoBack = false;
  String _currentTitle = '';
  final GlobalKey<NavigationBarWidgetState> _navKey =
      GlobalKey<NavigationBarWidgetState>();
  late WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title ?? '统一前端';
    _webViewController = WebViewController();

    // 确保UserProvider中的homeUrlInfo是最新的
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      userProvider.reloadHomeUrlInfo();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.homeUrlInfo == null ||
          userProvider.homeUrlInfo?.indexUrl == null) {
        context.go('/platform-select');
      }
    });
  }

  Future<void> _goBack(BuildContext context) async {
    // _exitApp();
    // 判断webview内部的网站有没有history，有history则返回上一页，没有history则返回主页
    // 获取webview内部的网站的history
    final canGoBack = await _webViewController.canGoBack();
    if (canGoBack) {
      // 有history则返回上一页
      await _webViewController.goBack();
    } else {
      // 没有history则返回主页
      Navigator.of(context).pop();
    }
  }

  void _goHome(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final homeUrlInfo = userProvider.homeUrlInfo;
    print('_goHome: homeUrlInfo: $homeUrlInfo');
    print(
        '_goHome: userProvider.hasHomeUrlInfo: ${userProvider.hasHomeUrlInfo}');

    if (homeUrlInfo != null &&
        homeUrlInfo.indexUrl != null &&
        homeUrlInfo.indexUrl!.isNotEmpty) {
      print('_goHome: 跳转到主页URL: ${homeUrlInfo.indexUrl}');
      // 重新加载主页URL - 通过导航到新的页面来实现
      context.go(
          '/web-home?url=${Uri.encodeComponent(homeUrlInfo.indexUrl!)}&isHome=true');
    } else {
      print('_goHome: 跳转到平台选择页');
      context.go('/platform-select');
    }
  }

  void _showMoreMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Menu",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 1.0,
            child: Material(
              color: Colors.white,
              elevation: 16,
              child: AppDrawerMenu(
                onSwitchSystem: () {},
                onContacts: () {
                  context.push('/contacts');
                },
                onAuth: () {
                  context.push('/real-name-auth');
                },
                onFaceCollect: () {
                  context.push('/face-collection');
                },
                onShare: () {
                  context.push('/app-share');
                },
                onAbout: () {
                  context.push('/about-app');
                },
                onLogout: () async {
                  Navigator.of(context).pop();
                  final userProvider = context.read<UserProvider>();
                  await userProvider.logout();
                  if (mounted) {
                    context.go('/verification-login');
                  }
                },
                onClearCache: () {},
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final userProvider = context.read<UserProvider>();
        await userProvider.restorePreviousHomeUrlInfo();
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: NavigationBarWidget(
            key: _navKey,
            title: _currentTitle,
            showBack: !widget.isHome, // 主页不显示返回按钮
            backgroundColor: Colors.white,
            titleColor: Colors.black87,
            itemColor: Colors.black87,
            onBack: _goBack,
            onHome: _goHome,
            onMore: _showMoreMenu,
            onScan: (context) {
              context.push('/scan');
            },
            onMessage: (context) {
              context.push('/im-messages');
            },
          ),
        ),
        body: _WebViewWithNavigation(
          url: widget.url ?? 'https://example.com',
          title: _currentTitle,
          navKey: _navKey,
          onPageStarted: (url) {
            // 页面开始加载时的处理
          },
          onPageFinished: (url) {
            // 页面加载完成时的处理
          },
          onNavigationRequest: (url) {
            // 导航请求处理
          },
          webViewController: _webViewController,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant WebHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      // 页面url变化，重置头部
      _navKey.currentState?.resetNavigation();
    }
  }
}

/// 包装WebView，传递导航条key给JSSDK处理器
class _WebViewWithNavigation extends StatefulWidget {
  final String url;
  final String? title;
  final GlobalKey<NavigationBarWidgetState> navKey;
  final Function(String)? onPageStarted;
  final Function(String)? onPageFinished;
  final Function(String)? onNavigationRequest;
  final WebViewController? webViewController;

  const _WebViewWithNavigation({
    required this.url,
    this.title,
    required this.navKey,
    this.onPageStarted,
    this.onPageFinished,
    this.onNavigationRequest,
    this.webViewController,
  });

  @override
  State<_WebViewWithNavigation> createState() => _WebViewWithNavigationState();
}

class _WebViewWithNavigationState extends State<_WebViewWithNavigation> {
  @override
  Widget build(BuildContext context) {
    return CompatibleWebView(
      url: widget.url,
      title: widget.title,
      onPageStarted: widget.onPageStarted,
      onPageFinished: widget.onPageFinished,
      onNavigationRequest: widget.onNavigationRequest,
      navKey: widget.navKey, // 传递导航条key
      webViewController: widget.webViewController,
    );
  }
}
