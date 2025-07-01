import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/navigation_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    print('SplashPage._initializeApp: 开始初始化应用');
    // 延迟2秒显示启动页
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final userProvider = context.read<UserProvider>();
      print('SplashPage._initializeApp: 获取UserProvider');

      // 初始化用户状态
      print('SplashPage._initializeApp: 开始初始化用户状态');
      await userProvider.initializeUser();
      print(
          'SplashPage._initializeApp: 用户状态初始化完成，登录状态: ${userProvider.isLoggedIn}');

      // 根据登录状态跳转
      if (userProvider.isLoggedIn) {
        print('SplashPage._initializeApp: 用户已登录，使用NavigationUtils进行跳转');
        // 使用NavigationUtils进行登录成功后的跳转
        NavigationUtils.jumpMainBridgeActivity(context);
      } else {
        print('SplashPage._initializeApp: 用户未登录，跳转到登录页');
        context.go('/verification-login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 应用Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.flutter_dash,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '统一前端',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '欢迎使用',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
