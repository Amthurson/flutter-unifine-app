import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('账号与安全')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('手机号'),
            subtitle: const Text('13660055196'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.of(context).pushNamed('/set-phone'),
          ),
          ListTile(
            title: const Text('密码设置'),
            trailing: const Icon(Icons.lock, size: 20),
            onTap: () => Navigator.of(context).pushNamed('/set-password'),
          ),
          ListTile(
            title: const Text('注销账户'),
            trailing: const Icon(Icons.delete_forever, size: 20),
            onTap: () => Navigator.of(context).pushNamed('/delete-account'),
          ),
        ],
      ),
    );
  }
}
