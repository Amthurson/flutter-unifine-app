import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/navigation_bar_widget.dart';
import '../widgets/compatible_webview.dart';

class TestBackButtonPage extends StatefulWidget {
  const TestBackButtonPage({super.key});

  @override
  State<TestBackButtonPage> createState() => _TestBackButtonPageState();
}

class _TestBackButtonPageState extends State<TestBackButtonPage> {
  final GlobalKey<NavigationBarWidgetState> _navKey =
      GlobalKey<NavigationBarWidgetState>();
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController();
  }

  void _onBackPressed(BuildContext context) async {
    // 检查是否可以返回
    final canGoBack = await _webViewController.canGoBack();
    if (canGoBack) {
      await _webViewController.goBack();
    } else {
      // 如果不能返回，则退出页面
      if (context.mounted) {
        context.pop();
      }
    }
  }

  void _onHomePressed(BuildContext context) {
    // 跳转到主页
    context.go('/home');
  }

  void _onMorePressed(BuildContext context) {
    // 显示更多菜单
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
                _webViewController.reload();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('返回主页'),
              onTap: () {
                Navigator.pop(context);
                _onHomePressed(context);
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
      body: Column(
        children: [
          // 使用我们的 NavigationBarWidget
          NavigationBarWidget(
            key: _navKey,
            title: 'WebView 返回按钮测试',
            showBack: true,
            backgroundColor: Colors.white,
            itemColor: Colors.black,
            titleColor: Colors.black,
            onBack: _onBackPressed,
            onHome: _onHomePressed,
            onMore: _onMorePressed,
          ),
          // WebView 内容
          Expanded(
            child: Provider.value(
              value: _webViewController,
              child: CompatibleWebView(
                url: 'https://www.baidu.com',
                title: 'WebView 返回按钮测试',
                webViewController: _webViewController,
                navKey: _navKey,
                onPageStarted: (url) {
                  print('页面开始加载: $url');
                },
                onPageFinished: (url) {
                  print('页面加载完成: $url');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
