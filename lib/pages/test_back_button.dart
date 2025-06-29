import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestBackButtonPage extends StatelessWidget {
  const TestBackButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试返回按钮'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            print('返回按钮被点击');
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('这是一个测试页面', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('测试按钮被点击');
                context.pop();
              },
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}
