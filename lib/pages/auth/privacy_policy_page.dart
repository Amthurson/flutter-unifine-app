import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
        title: const Text('个人信息保护指引', style: TextStyle(color: Colors.black87)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '个人信息保护指引',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  '更新日期：2024年1月1日',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                _buildSection(
                  '1. 信息收集',
                  '我们收集的信息包括：\n'
                      '• 手机号码：用于账号注册和登录\n'
                      '• 姓名：用于身份验证\n'
                      '• 设备信息：用于安全防护\n'
                      '• 使用记录：用于服务优化',
                ),

                _buildSection(
                  '2. 信息使用',
                  '我们使用收集的信息用于：\n'
                      '• 提供燃气服务\n'
                      '• 身份验证和安全防护\n'
                      '• 客户服务和支持\n'
                      '• 服务改进和优化',
                ),

                _buildSection(
                  '3. 信息保护',
                  '我们采取严格的安全措施保护您的个人信息：\n'
                      '• 数据加密传输和存储\n'
                      '• 访问权限控制\n'
                      '• 定期安全审计\n'
                      '• 员工保密培训',
                ),

                _buildSection(
                  '4. 信息共享',
                  '除以下情况外，我们不会与第三方共享您的个人信息：\n'
                      '• 获得您的明确同意\n'
                      '• 法律法规要求\n'
                      '• 保护用户和公众安全\n'
                      '• 与授权合作伙伴共享必要信息',
                ),

                _buildSection(
                  '5. 您的权利',
                  '您享有以下权利：\n'
                      '• 访问和查看个人信息\n'
                      '• 更正不准确的信息\n'
                      '• 删除个人信息\n'
                      '• 撤回同意授权',
                ),

                _buildSection(
                  '6. 联系我们',
                  '如果您对本指引有任何疑问，请联系我们：\n'
                      '• 客服电话：400-123-4567\n'
                      '• 邮箱：privacy@huaxingas.com\n'
                      '• 地址：华新燃气集团总部',
                ),

                const SizedBox(height: 30),

                // 同意按钮
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
                    onPressed: () => context.pop(),
                    child: const Text('我已了解', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
