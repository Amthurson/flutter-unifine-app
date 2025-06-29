import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewFriendsPage extends StatelessWidget {
  const NewFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('新的朋友'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildAddFriendCard(context),
          const Divider(),
          _buildFriendRequest('张三', '138****1234', '请求添加您为好友'),
          _buildFriendRequest('李四', '139****5678', '请求添加您为好友'),
        ],
      ),
    );
  }

  Widget _buildAddFriendCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              '添加朋友',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('通过手机号或二维码添加朋友', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 通过手机号添加
                    },
                    child: const Text('通过手机号添加'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 扫描二维码
                    },
                    child: const Text('扫描二维码'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRequest(String name, String phone, String message) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(phone),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('接受'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: () {}, child: const Text('拒绝')),
        ],
      ),
    );
  }
}
