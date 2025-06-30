import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../theme/app_theme.dart';

class VerificationLoginPage extends StatefulWidget {
  const VerificationLoginPage({super.key});

  @override
  State<VerificationLoginPage> createState() => _VerificationLoginPageState();
}

class _VerificationLoginPageState extends State<VerificationLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _agree = false;
  bool _isLoading = false;
  int _countdown = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });
        if (_countdown <= 0) {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _getVerificationCode() {
    if (_phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请输入手机号');
      return;
    }

    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(_phoneController.text)) {
      Fluttertoast.showToast(msg: '请输入正确的手机号');
      return;
    }

    // 模拟发送验证码
    Fluttertoast.showToast(msg: '验证码已发送');
    _startCountdown();
  }

  void _login() async {
    if (_phoneController.text.isEmpty || _codeController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请填写完整信息');
      return;
    }

    if (!_agree) {
      Fluttertoast.showToast(msg: '请先同意个人信息保护指引');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 模拟登录请求
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // 登录成功，跳转到主页
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  '验证码登录',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '请输入手机号获取验证码',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // 手机号输入
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey.shade100,
                      ),
                      child: const Text(
                        '+86',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '请输入手机号',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 验证码输入
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '请输入验证码',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _countdown > 0
                              ? Colors.grey
                              : AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: _countdown > 0 ? null : _getVerificationCode,
                        child: Text(
                          _countdown > 0 ? '${_countdown}s' : '获取验证码',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 同意协议
                Row(
                  children: [
                    Checkbox(
                      value: _agree,
                      onChanged: (v) {
                        setState(() {
                          _agree = v ?? false;
                        });
                      },
                      shape: const CircleBorder(),
                      activeColor: AppTheme.primaryColor,
                    ),
                    const Text('我已阅读并同意'),
                    GestureDetector(
                      onTap: () => context.push('/privacy-policy'),
                      child: const Text(
                        '《个人信息保护指引》',
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 登录按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('登录', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 16),

                // 其他登录方式
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => context.go('/password-login'),
                      child: const Text('密码登录'),
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text('快速注册'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
