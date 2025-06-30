// lib/pages/main/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_front_end/theme/app_theme.dart';
import '../../widgets/compatible_webview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('华新燃气'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            color: Colors.white,
            onPressed: () => context.push('/im-messages'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.white,
            onPressed: () => _showProfileMenu(context),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: CompatibleWebView(url: 'https://www.baidu.com', title: '华新燃气'),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '华新燃气用户',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
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
