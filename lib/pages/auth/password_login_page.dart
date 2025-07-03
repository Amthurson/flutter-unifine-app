import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../api/auth_api.dart';
import '../../providers/user_provider.dart';
import '../../models/user.dart';
import '../../utils/navigation_utils.dart';

class PasswordLoginPage extends StatefulWidget {
  const PasswordLoginPage({super.key});

  @override
  State<PasswordLoginPage> createState() => _PasswordLoginPageState();
}

class _PasswordLoginPageState extends State<PasswordLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _agree = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _publicKey;

  @override
  void initState() {
    super.initState();
    _fetchPublicKey();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请填写完整信息');
      return;
    }
    if (!_agree) {
      Fluttertoast.showToast(msg: '请先同意个人信息保护指引');
      return;
    }
    if (_publicKey == null) {
      Fluttertoast.showToast(msg: '获取公钥失败，请重试');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userProvider = context.read<UserProvider>();

    try {
      // 使用PasswordLoginApi进行密码登录
      final result = await PasswordLoginApi.loginWithPassword(
        _phoneController.text,
        _passwordController.text,
        _publicKey!,
      );

      // 将Map转换为User对象，然后使用全局状态管理处理登录
      final user = User.fromJson(result);
      await userProvider.login(user);

      if (mounted) {
        Fluttertoast.showToast(msg: '登录成功');

        // 根据用户状态决定跳转
        if (user.needBindPhone == true) {
          context.go('/set-password'); // 跳转设置密码页面
        } else {
          // 使用NavigationUtils进行登录成功后的跳转
          NavigationUtils.jumpMainBridgeActivity(context);
        }
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(msg: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _fetchPublicKey() async {
    try {
      _publicKey = await AuthApi.getPublicKey();
    } catch (e) {
      Fluttertoast.showToast(msg: '获取公钥失败');
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
                  '密码登录',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '请输入手机号和密码',
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

                // 密码输入
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '请输入密码',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
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

                // 其他选项
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => context.push('/verification-login'),
                      child: const Text('验证码登录'),
                    ),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('忘记密码'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('还没有账号？'),
                    TextButton(
                      onPressed: () => context.push('/register'),
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
