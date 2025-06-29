# 华新燃气智慧服务平台

这是一个基于Flutter开发的华新燃气智慧服务平台移动应用。

## 项目功能

### 认证模块
- **启动页**: 应用启动时的欢迎页面
- **验证码登录**: 通过手机验证码登录
- **密码登录**: 通过手机号和密码登录
- **找回密码**: 通过手机验证码重置密码
- **快速注册**: 姓名和手机号快速注册
- **个人信息保护指引**: 隐私政策说明页面

### 主要功能
- **主页**: 带底部导航和左侧抽屉菜单的WebView页面
- **通讯录**: 联系人管理，包含新的朋友、我的朋友、协助组
- **消息**: IM消息列表
- **个人中心**: 实名认证、人脸采集、APP分享、关于APP

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── routes/
│   └── app_router.dart       # 路由配置
├── pages/
│   ├── splash_page.dart      # 启动页
│   ├── auth/                 # 认证相关页面
│   │   ├── verification_login_page.dart
│   │   ├── password_login_page.dart
│   │   ├── forgot_password_page.dart
│   │   ├── register_page.dart
│   │   └── privacy_policy_page.dart
│   ├── main/
│   │   └── home_page.dart    # 主页
│   ├── contacts/             # 通讯录相关页面
│   │   ├── contacts_page.dart
│   │   ├── new_friends_page.dart
│   │   ├── my_friends_page.dart
│   │   └── assist_groups_page.dart
│   ├── profile/              # 个人资料相关页面
│   │   ├── real_name_auth_page.dart
│   │   ├── face_collection_page.dart
│   │   ├── app_share_page.dart
│   │   └── about_app_page.dart
│   └── message/
│       └── im_message_list_page.dart
├── widgets/                  # 可复用组件
├── services/                 # 服务层
├── models/                   # 数据模型
├── utils/                    # 工具类
└── providers/                # 状态管理
```

## 技术栈

- **Flutter**: 跨平台移动应用开发框架
- **Go Router**: 路由管理
- **Provider**: 状态管理
- **WebView**: 网页内容展示
- **QR Flutter**: 二维码生成
- **Dio**: 网络请求
- **Shared Preferences**: 本地存储

## 运行项目

1. 确保已安装Flutter SDK
2. 克隆项目到本地
3. 运行 `flutter pub get` 安装依赖
4. 运行 `flutter run` 启动项目

## 路由说明

- `/`: 启动页
- `/verification-login`: 验证码登录
- `/password-login`: 密码登录
- `/forgot-password`: 找回密码
- `/register`: 快速注册
- `/privacy-policy`: 隐私政策
- `/home`: 主页
- `/contacts`: 通讯录
- `/new-friends`: 新的朋友
- `/my-friends`: 我的朋友
- `/assist-groups`: 协助组
- `/real-name-auth`: 实名认证
- `/face-collection`: 人脸采集
- `/app-share`: APP分享
- `/about-app`: 关于APP
- `/im-messages`: IM消息列表

## 开发说明

本项目采用模块化设计，每个功能模块都有独立的页面文件。路由系统使用Go Router进行管理，支持页面间的导航和参数传递。

主要特点：
- 统一的UI设计风格
- 完整的用户认证流程
- 响应式布局设计
- 模块化的代码结构
- 完善的错误处理

## 版本信息

- 版本: 1.0.0
- 更新时间: 2024年1月
- 开发框架: Flutter 3.8.1
