# API 接口文档

本项目包含了完整的API接口实现，按照功能模块进行了分类。

## 文件结构

```
lib/api/
├── api_index.dart          # API统一导出文件
├── auth_api.dart           # 认证相关API
├── user_api.dart           # 用户基础API
├── common_config_api.dart  # 通用配置API
├── im_api.dart            # IM聊天相关API
├── cloud_api.dart         # 云服务相关API
├── user_management_api.dart # 用户管理API
├── file_api.dart          # 文件上传下载API
└── README.md              # 本文档
```

## 使用方式

### 1. 统一导入

```dart
import 'package:unified_front_end/api/api_index.dart';
```

### 2. 分类导入

```dart
import 'package:unified_front_end/api/auth_api.dart';
import 'package:unified_front_end/api/im_api.dart';
import 'package:unified_front_end/api/cloud_api.dart';
```

## API分类说明

### AuthApi - 认证相关
- 获取RSA公钥
- 发送验证码
- 验证码登录
- 密码登录
- 微信登录
- 获取全局配置

### UserApi - 用户基础
- 获取用户信息
- 获取图形验证码
- 手机号码登录
- 密码登录
- 获取登录公钥

### ImApi - IM聊天相关
- 刷新用户token
- 添加好友
- 创建群组
- 删除好友
- 设置用户别名
- 获取用户详情
- 好友列表管理
- 群组管理

### CloudApi - 云服务相关
- 获取用户首页信息
- 公司组织架构
- 用户搜索
- 企业信息
- 服务窗管理
- 组织架构树
- 访客登录

### UserManagementApi - 用户管理
- 获取IM账号信息
- 验证码校验
- 密码管理
- 实名认证
- 人脸采集
- 头像管理
- OAuth登录
- 账号注销

### FileApi - 文件操作
- 文件下载
- 单文件上传
- 多文件上传
- 指定URL上传

### CommonConfigApi - 通用配置
- 保存首页URL信息
- 获取首页URL信息

## 使用示例

### 登录流程

```dart
// 1. 获取公钥
final publicKey = await AuthApi.getPublicKey();

// 2. 发送验证码
await AuthApi.sendCode(phone, publicKey);

// 3. 验证码登录
final userInfo = await AuthApi.loginWithCode(phone, code, publicKey);
```

### IM功能

```dart
// 添加好友
await ImApi.addFriend({
  'userId': '123456',
  'message': '你好，我想添加你为好友'
});

// 获取好友列表
final friendList = await ImApi.getMyFriendList({
  'page': 1,
  'size': 20
});

// 创建群组
await ImApi.createTeam({
  'groupName': '测试群组',
  'memberIds': ['user1', 'user2', 'user3']
});
```

### 文件上传

```dart
// 上传单个文件
final result = await FileApi.uploadFile('文件描述', file);

// 上传多个文件
final result = await FileApi.uploadMultipleFilesGeneric('描述', [file1, file2, file3]);
```

### 用户管理

```dart
// 更新用户信息
await UserManagementApi.updateMe({
  'nickname': '新昵称',
  'email': 'new@example.com'
});

// 修改头像
final avatarUrl = await UserManagementApi.changeUserHeadImg({
  'avatar': 'base64编码的图片数据'
});
```

## 错误处理

所有API都包含了统一的错误处理机制：

```dart
try {
  final result = await AuthApi.loginWithCode(phone, code, publicKey);
  // 处理成功结果
} catch (e) {
  // 处理错误
  print('登录失败: $e');
}
```

## 注意事项

1. 所有API都使用统一的响应格式，成功时返回 `code: 3001`
2. 文件上传API支持多种格式和批量上传
3. 认证相关API需要先获取RSA公钥进行加密
4. IM相关API需要用户已登录状态
5. 部分API需要特定的权限或角色

## 配置

API的基础URL配置在 `lib/config/env_config.dart` 中：

```dart
class EnvConfig {
  static const String baseUrl = 'http://your-backend-url.com';
}
```

请根据实际环境修改此配置。 