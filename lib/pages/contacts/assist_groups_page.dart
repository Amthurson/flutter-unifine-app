import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AssistGroupsPage extends StatelessWidget {
  const AssistGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('协助组'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildGroupItem('技术支持组', '5人', '在线'),
          _buildGroupItem('客服协助组', '8人', '在线'),
          _buildGroupItem('维修协助组', '3人', '离线'),
        ],
      ),
    );
  }

  Widget _buildGroupItem(String name, String memberCount, String status) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(Icons.group, color: Colors.white),
      ),
      title: Text(name),
      subtitle: Text('成员: $memberCount'),
      trailing: Text(
        status,
        style: TextStyle(color: status == '在线' ? Colors.green : Colors.grey),
      ),
      onTap: () {
        // 跳转到群聊页面
      },
    );
  }
}
