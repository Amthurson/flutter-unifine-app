# 统一前端 - Flutter跨平台应用

这是一个基于Flutter开发的统一前端移动应用，实现了完整的用户认证、H5页面展示、Bridge通信等功能。

## 项目功能

### 认证模块
- **启动页**: 应用启动时的欢迎页面，自动初始化用户状态
- **验证码登录**: 通过手机验证码登录
- **密码登录**: 通过手机号和密码登录
- **找回密码**: 通过手机验证码重置密码
- **快速注册**: 姓名和手机号快速注册
- **个人信息保护指引**: 隐私政策说明页面

### 主要功能
- **广告页**: 全屏广告展示，3秒倒计时后自动跳转
- **平台选择页**: H5平台选择，支持服务窗选择
- **Web主页面**: 基于WebView的H5页面展示，支持Bridge通信
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
│   ├── launch_advert_page.dart # 广告页
│   ├── platform_select_page.dart # 平台选择页
│   ├── web_home_page.dart    # Web主页面
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
│   ├── bridge_webview.dart   # Bridge WebView组件
│   ├── compatible_webview.dart # 兼容性WebView组件
│   └── navigation_bar_widget.dart # 导航栏组件
├── services/                 # 服务层
│   ├── user_service.dart     # 用户服务
│   ├── app_launcher_service.dart # 应用启动服务
│   └── bluetooth_service.dart # 蓝牙服务
├── models/                   # 数据模型
│   ├── user.dart            # 用户模型
│   └── home_url_info.dart   # 主页URL信息模型
├── utils/                    # 工具类
│   ├── bridge/              # Bridge相关工具
│   │   ├── bridge_handler.dart # Bridge处理器接口
│   │   └── jssdk_handlers.dart # JSSDK处理器
│   ├── navigation_utils.dart # 导航工具类
│   └── webview_register/    # WebView注册
├── providers/                # 状态管理
│   └── user_provider.dart   # 用户状态管理
├── api/                     # API接口
│   ├── auth_api.dart        # 认证API
│   ├── user_api.dart        # 用户API
│   └── common_config_api.dart # 通用配置API
└── config/                  # 配置
    └── env_config.dart      # 环境配置
```

## 技术栈

- **Flutter**: 跨平台移动应用开发框架
- **Go Router**: 路由管理
- **Provider**: 状态管理
- **WebView**: 网页内容展示
- **Bridge通信**: Flutter与H5的双向通信
- **Dio**: 网络请求
- **Shared Preferences**: 本地存储
- **flutter_blue_plus**: 蓝牙功能
- **app_launcher**: 应用启动

## 核心特性

### 1. 统一Bridge通信
- 实现Flutter与H5的双向通信
- 支持完整的JSSDK方法
- 兼容现有WebViewJavascriptBridge API

### 2. 用户认证流程
- 支持验证码和密码登录
- 自动登录和手动登录
- 完整的用户状态管理

### 3. 页面跳转逻辑
- 启动页 → 登录页/主页
- 登录成功 → 广告页/平台选择页
- 平台选择 → 广告页 → Web主页面

### 4. 设备功能
- 蓝牙设备管理
- 应用启动功能
- 权限管理

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
- `/launch-advert`: 广告页
- `/platform-select`: 平台选择页
- `/web-home`: Web主页面
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
- 完整的Bridge通信系统

## 版本信息

- 版本: 1.0.0
- 更新时间: 2024年1月
- 开发框架: Flutter 3.8.1
