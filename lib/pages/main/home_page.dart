import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebViewController _webViewController;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // 更新加载进度
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.baidu.com'));

    // web/pc端自动用url_launcher打开
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      _launchWebUrl();
    }
  }

  Future<void> _launchWebUrl() async {
    final url = Uri.parse('https://www.baidu.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return Scaffold(
        appBar: AppBar(title: const Text('华新燃气')),
        body: const Center(child: Text('已在浏览器中打开服务平台，请在新窗口操作。')),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('华新燃气'),
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () => context.push('/im-messages'),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => _showProfileMenu(context),
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _navigateToPage(index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1976D2),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.contacts), label: '通讯录'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
          ],
        ),
      );
    }
    // 其它平台
    return Scaffold(
      appBar: AppBar(title: const Text('华新燃气')),
      body: const Center(
        child: Text('当前平台暂不支持WebView，请在Android、iOS、Windows或Mac上体验。'),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1976D2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xFF1976D2)),
                ),
                const SizedBox(height: 10),
                const Text(
                  '华新燃气用户',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '138****8888',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('首页'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('通讯录'),
            onTap: () {
              Navigator.pop(context);
              context.push('/contacts');
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('消息'),
            onTap: () {
              Navigator.pop(context);
              context.push('/im-messages');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('设置'),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('账号与安全'),
            onTap: () {
              Navigator.pop(context);
              context.push('/account-security');
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('我的二维码'),
            onTap: () {
              Navigator.pop(context);
              context.push('/my-qrcode');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('实名认证'),
            onTap: () {
              Navigator.pop(context);
              context.push('/real-name-auth');
            },
          ),
          ListTile(
            leading: const Icon(Icons.face),
            title: const Text('人脸采集'),
            onTap: () {
              Navigator.pop(context);
              context.push('/face-collection');
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('APP分享'),
            onTap: () {
              Navigator.pop(context);
              context.push('/app-share');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于APP'),
            onTap: () {
              Navigator.pop(context);
              context.push('/about-app');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('退出登录'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        // 首页 - 刷新WebView
        _webViewController.reload();
        break;
      case 1:
        // 通讯录
        context.push('/contacts');
        break;
      case 2:
        // 消息
        context.push('/im-messages');
        break;
      case 3:
        // 我的 - 打开抽屉
        Scaffold.of(context).openDrawer();
        break;
    }
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('实名认证'),
              onTap: () {
                Navigator.pop(context);
                context.push('/real-name-auth');
              },
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text('人脸采集'),
              onTap: () {
                Navigator.pop(context);
                context.push('/face-collection');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('关于APP'),
              onTap: () {
                Navigator.pop(context);
                context.push('/about-app');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('退出登录'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/verification-login');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class CompatibleWebView extends StatefulWidget {
  final String url;

  const CompatibleWebView({super.key, required this.url});

  @override
  State<CompatibleWebView> createState() => _CompatibleWebViewState();
}

class _CompatibleWebViewState extends State<CompatibleWebView> {
  @override
  void initState() {
    super.initState();
    _autoLaunch();
  }

  Future<void> _autoLaunch() async {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      final uri = Uri.parse(widget.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      return Scaffold(
        appBar: AppBar(title: Text('WebView Page')),
        body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(widget.url)),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Open in Browser')),
        body: Center(child: Text('已在浏览器中打开：${widget.url}')),
      );
    }
  }
}
