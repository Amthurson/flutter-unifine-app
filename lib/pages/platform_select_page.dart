import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unified_front_end/api/common_config_api.dart';
import '../providers/user_provider.dart';
import '../widgets/compatible_webview.dart';

class PlatformSelectPage extends StatefulWidget {
  const PlatformSelectPage({super.key, this.selectType = 'all-platform'});
  final String selectType;

  @override
  State<PlatformSelectPage> createState() => _PlatformSelectPageState();
}

class _PlatformSelectPageState extends State<PlatformSelectPage> {
  final String _currentTitle = '选择平台';

  String get allPlatformUrl => CommonConfig.workbenchSelectUrl;
  String get mineServerUrl => CommonConfig.homeMenuWorkbenchSelectUrl;

  @override
  void initState() {
    super.initState();
  }

  void _goBack() {
    context.pop();
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
                context.go('/platform-select');
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
    final cloudAppUrl =
        widget.selectType == 'all-platform' ? allPlatformUrl : mineServerUrl;

    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: _showMoreMenu,
          ),
        ],
      ),
      body: CompatibleWebView(
        url: cloudAppUrl,
        title: _currentTitle,
        onPageStarted: (url) {
          // 页面开始加载时的处理
        },
        onPageFinished: (url) {
          // 页面加载完成时的处理
        },
        onNavigationRequest: (url) {},
      ),
    );
  }
}
