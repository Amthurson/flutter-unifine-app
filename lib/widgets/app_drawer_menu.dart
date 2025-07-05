import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_front_end/providers/user_provider.dart';
import 'package:go_router/go_router.dart';

class AppDrawerMenu extends StatelessWidget {
  final VoidCallback? onSwitchSystem;
  final VoidCallback? onContacts;
  final VoidCallback? onAuth;
  final VoidCallback? onFaceCollect;
  final VoidCallback? onShare;
  final VoidCallback? onAbout;
  final VoidCallback? onLogout;
  final VoidCallback? onClearCache;

  const AppDrawerMenu({
    super.key,
    this.onSwitchSystem,
    this.onContacts,
    this.onAuth,
    this.onFaceCollect,
    this.onShare,
    this.onAbout,
    this.onLogout,
    this.onClearCache,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final homeUrlInfo = userProvider.homeUrlInfo;
    final userInfo = userProvider.currentUser;
    final userName = userInfo?.userName ?? '用户';
    final userAvatar =
        userInfo?.avatar ?? 'assets/images/nim_avatar_default.png';
    final systemName = homeUrlInfo?.serviceName ?? '华新统一门户';
    const version = 'Test-V1.0.0';

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像和用户名
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: userAvatar.startsWith('http')
                          ? NetworkImage(userAvatar) as ImageProvider
                          : AssetImage(userAvatar),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 12),
                    Text(userName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
          ),
          // 系统切换
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: const Color(0xFFF5F8FE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.swap_horiz, color: Color(0xFF3B6EFF)),
                title: const Text('系统切换',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('当前 $systemName',
                    style: const TextStyle(color: Color(0xFF3B6EFF))),
                onTap: () {
                  Navigator.of(context).pop(); // 关闭抽屉
                  context.push('/platform-select', extra: {
                    'selectType': 'mine-server',
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          // 菜单项
          ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('通讯录'),
              onTap: onContacts),
          ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('实名认证'),
              onTap: onAuth),
          ListTile(
              leading: const Icon(Icons.face),
              title: const Text('人脸采集'),
              onTap: onFaceCollect),
          ListTile(
              leading: const Icon(Icons.share),
              title: const Text('APP分享'),
              onTap: onShare),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于华新燃气'),
            trailing: const Text(version,
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            onTap: onAbout,
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('退出登录'),
              onTap: onLogout),
          const Spacer(),
          // 清除缓存按钮
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.cleaning_services),
              label: const Text('清除缓存'),
              onPressed: onClearCache,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
