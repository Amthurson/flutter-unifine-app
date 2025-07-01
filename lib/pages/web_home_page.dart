import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/compatible_webview.dart';

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
  final bool _canGoBack = false;
  String _currentTitle = '';

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title ?? '统一前端';
  }

  void _goBack() {
    _exitApp();
  }

  void _exitApp() {
    if (widget.isHome) {
      // 如果是主页，显示退出确认对话框
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('退出应用'),
          content: const Text('确定要退出应用吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 退出应用
                SystemNavigator.pop();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    } else {
      // 如果不是主页，返回上一页
      context.pop();
    }
  }

  void _goHome() {
    final userProvider = context.read<UserProvider>();
    final homeUrlInfo = userProvider.getHomeUrlInfo();

    if (homeUrlInfo != null &&
        homeUrlInfo.indexUrl != null &&
        homeUrlInfo.indexUrl!.isNotEmpty) {
      // 重新加载主页URL - 通过导航到新的页面来实现
      context.go(
          '/web-home?url=${Uri.encodeComponent(homeUrlInfo.indexUrl!)}&isHome=true');
    }
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('刷新'),
              onTap: () {
                Navigator.of(context).pop();
                // 重新加载页面
                context.go(
                    '/web-home?url=${Uri.encodeComponent(widget.url ?? 'https://example.com')}&isHome=${widget.isHome}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('返回主页'),
              onTap: () {
                Navigator.of(context).pop();
                _goHome();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('设置'),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('退出登录'),
              onTap: () async {
                Navigator.of(context).pop();
                final userProvider = context.read<UserProvider>();
                await userProvider.logout();
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  context.go('/verification-login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isHome
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                _currentTitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: _canGoBack
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: _goBack,
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.black),
                  onPressed: _goHome,
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () => context.push('/im-messages'),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
                  onPressed: () {
                    // 扫码功能
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: _showMoreMenu,
                ),
              ],
            )
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                _currentTitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: _goBack,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => context.go('/platform-select'),
                ),
              ],
            ),
      body: CompatibleWebView(
        url: widget.url ?? 'https://example.com',
        title: _currentTitle,
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
