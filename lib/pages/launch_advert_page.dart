import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/home_url_info.dart';

class LaunchAdvertPage extends StatefulWidget {
  final HomeUrlInfo? windowInfo;

  const LaunchAdvertPage({
    super.key,
    this.windowInfo,
  });

  @override
  State<LaunchAdvertPage> createState() => _LaunchAdvertPageState();
}

class _LaunchAdvertPageState extends State<LaunchAdvertPage> {
  int _countdown = 3;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _fetchWindowInfo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });

        if (_countdown <= 0) {
          timer.cancel();
          _navigateToMainPage();
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _fetchWindowInfo() async {
    if (widget.windowInfo == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = context.read<UserProvider>();

      // 模拟获取窗口信息的API调用
      await Future.delayed(const Duration(milliseconds: 500));

      // 这里可以调用实际的API获取窗口信息
      // final windowInfo = await ApiService.getWindowInfo(widget.windowInfo!.windowsId);

      // 更新用户信息中的窗口设置
      // userProvider.updateWindowSettings(windowInfo);
    } catch (e) {
      print('获取窗口信息失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToMainPage() {
    final userProvider = context.read<UserProvider>();

    // 检查是否有主页URL信息
    final homeUrlInfo = userProvider.getHomeUrlInfo();

    if (homeUrlInfo != null && 
        homeUrlInfo.indexUrl != null && 
        homeUrlInfo.indexUrl!.isNotEmpty) {
      // 有主页URL，跳转到H5主页面
      context.go('/web-home', extra: {
        'title': homeUrlInfo.windowsName,
        'url': homeUrlInfo.indexUrl!,
        'isHome': true,
      });
    } else {
      // 没有主页URL，跳转到平台选择页
      context.go('/platform-select');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 全屏背景图片
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.windowInfo?.bannerUrl ??
                      'assets/images/default_banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 半透明遮罩
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // 内容区域
          Positioned.fill(
            child: Column(
              children: [
                const Spacer(),

                // 服务信息
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 服务名称
                      if (widget.windowInfo?.serviceName != null)
                        Text(
                          widget.windowInfo!.serviceName!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 8),

                      // 窗口名称
                      if (widget.windowInfo?.windowsName != null)
                        Text(
                          widget.windowInfo!.windowsName!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 倒计时
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_countdown',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          // 加载指示器
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
