import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import '../providers/user_provider.dart';
import '../widgets/compatible_webview.dart';
import '../widgets/navigation_bar_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title ?? '统一前端';
  }

  // void _goBack() {
  //   _exitApp();
  // }

  // void _exitApp() {
  //   if (widget.isHome) {
  //     // 如果是主页，显示退出确认对话框
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('退出应用'),
  //         content: const Text('确定要退出应用吗？'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('取消'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // 退出应用
  //               SystemNavigator.pop();
  //             },
  //             child: const Text('确定'),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     // 如果不是主页，返回上一页
  //     context.pop();
  //   }
  // }

  // void _goHome() {
  //   final userProvider = context.read<UserProvider>();
  //   final homeUrlInfo = userProvider.getHomeUrlInfo();

  //   if (homeUrlInfo != null &&
  //       homeUrlInfo.indexUrl != null &&
  //       homeUrlInfo.indexUrl!.isNotEmpty) {
  //     // 重新加载主页URL - 通过导航到新的页面来实现
  //     context.go(
  //         '/web-home?url=${Uri.encodeComponent(homeUrlInfo.indexUrl!)}&isHome=true');
  //   }
  // }

  // void _showMoreMenu() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.refresh),
  //             title: const Text('刷新'),
  //             onTap: () {
  //               Navigator.of(context).pop();
  //               // 重新加载页面
  //               context.go(
  //                   '/web-home?url=${Uri.encodeComponent(widget.url ?? 'https://example.com')}&isHome=${widget.isHome}');
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.home),
  //             title: const Text('返回主页'),
  //             onTap: () {
  //               Navigator.of(context).pop();
  //               _goHome();
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.settings),
  //             title: const Text('设置'),
  //             onTap: () {
  //               Navigator.of(context).pop();
  //               context.push('/settings');
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.logout),
  //             title: const Text('退出登录'),
  //             onTap: () async {
  //               Navigator.of(context).pop();
  //               final userProvider = context.read<UserProvider>();
  //               await userProvider.logout();
  //               if (mounted) {
  //                 // ignore: use_build_context_synchronously
  //                 context.go('/verification-login');
  //               }
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: NavigationBarWidget(
          key: _navKey,
          title: _currentTitle,
          showBack: !widget.isHome, // 主页不显示返回按钮
          backgroundColor: Colors.white,
          titleColor: Colors.black87,
          itemColor: Colors.black87,
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
      ),
    );
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

  const _WebViewWithNavigation({
    required this.url,
    this.title,
    required this.navKey,
    this.onPageStarted,
    this.onPageFinished,
    this.onNavigationRequest,
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
    );
  }
}
