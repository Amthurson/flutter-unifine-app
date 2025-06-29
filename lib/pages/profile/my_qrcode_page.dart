import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MyQrcodePage extends StatelessWidget {
  const MyQrcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的二维码')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: 替换为实际二维码组件
            Container(
              width: 200,
              height: 200,
              color: AppTheme.dividerColor,
              child: const Center(child: Text('二维码')),
            ),
            const SizedBox(height: 16),
            const Text('扫一扫二维码，加我为好友'),
          ],
        ),
      ),
    );
  }
}
