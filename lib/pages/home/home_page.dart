import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/user_service.dart';
import '../../models/home_url_info.dart';
import '../../models/user.dart';
import '../../widgets/compatible_webview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final user = await UserService.getUserInfo();
    if (mounted) {
      setState(() {
        _user = user as User?;
      });
    }
  }

  void _logout() async {
    await UserService.clearUserInfo();
    if (mounted) {
      context.go('/verification-login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主页'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: FutureBuilder<HomeUrlInfo?>(
        future: UserService.getHomeUrlInfo(),
        builder: (context, snapshot) {
          return CompatibleWebView(
            url: snapshot.data?.indexUrl ?? '',
            title: '主页',
          );
        },
      ),
    );
  }
}
