import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  void _navigateToNextPage() async {
    // 模拟加载时间
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // 检查是否已登录，如果已登录则跳转到主页，否则跳转到登录页
      // 这里可以根据实际需求修改逻辑
      context.go('/verification-login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 应用Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_gas_station,
                size: 60,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 30),

            // 应用名称
            const Text(
              '华新燃气',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // 应用副标题
            const Text(
              '智慧燃气服务平台',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 50),

            // 加载动画
            const SpinKitFadingCircle(color: Colors.white, size: 40.0),
          ],
        ),
      ),
    );
  }
}
