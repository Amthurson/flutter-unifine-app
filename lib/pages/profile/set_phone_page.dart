import 'package:flutter/material.dart';

class SetPhonePage extends StatelessWidget {
  const SetPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置手机号')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: '请输入您的手机号')),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: '请输入6位验证码')),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('更换手机号'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
