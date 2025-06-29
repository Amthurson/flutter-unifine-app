import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImMessageListPage extends StatelessWidget {
  const ImMessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('消息'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 搜索消息
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildMessageItem('张三', '您好，请问有什么可以帮助您的吗？', '14:30', '2', true),
          _buildMessageItem('李四', '燃气费用查询', '13:45', '', false),
          _buildMessageItem('技术支持组', '王五: 系统维护通知', '12:20', '5', true),
          _buildMessageItem('客服协助组', '欢迎使用华新燃气服务', '昨天', '', false),
          _buildMessageItem('赵六', '谢谢您的帮助', '昨天', '', false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 新建聊天
        },
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildMessageItem(
    String name,
    String lastMessage,
    String time,
    String unreadCount,
    bool isUnread,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isUnread ? Colors.blue : Colors.grey,
        child: Text(name[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: TextStyle(
          color: isUnread ? Colors.black87 : Colors.grey,
          fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isUnread ? Colors.blue : Colors.grey,
            ),
          ),
          if (unreadCount.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                unreadCount,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () {
        // 跳转到聊天页面
      },
    );
  }
}
