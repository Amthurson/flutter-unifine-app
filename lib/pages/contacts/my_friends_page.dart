import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyFriendsPage extends StatelessWidget {
  const MyFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('我的朋友'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildFriendItem('张三', '138****1234', '在线'),
          _buildFriendItem('李四', '139****5678', '离线'),
          _buildFriendItem('王五', '137****9012', '在线'),
          _buildFriendItem('赵六', '136****3456', '离线'),
        ],
      ),
    );
  }

  Widget _buildFriendItem(String name, String phone, String status) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: status == '在线' ? Colors.green : Colors.grey,
        child: Text(name[0]),
      ),
      title: Text(name),
      subtitle: Text(phone),
      trailing: Text(
        status,
        style: TextStyle(color: status == '在线' ? Colors.green : Colors.grey),
      ),
      onTap: () {
        // 跳转到聊天页面
      },
    );
  }
}
