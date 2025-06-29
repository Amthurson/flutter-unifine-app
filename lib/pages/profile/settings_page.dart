import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('个人信息'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            title: const Text('我的二维码'),
            trailing: const Icon(Icons.qr_code, size: 20),
            onTap: () => Navigator.of(context).pushNamed('/my-qrcode'),
          ),
          ListTile(
            title: const Text('账号与安全'),
            trailing: const Icon(Icons.security, size: 20),
            onTap: () => Navigator.of(context).pushNamed('/account-security'),
          ),
        ],
      ),
    );
  }
}
