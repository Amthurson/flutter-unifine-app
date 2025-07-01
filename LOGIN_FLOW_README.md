# Flutter应用登录流程重构说明

## 概述

本次重构将Flutter应用的登录流程完全还原了Android项目的逻辑，实现了登录成功后显示全屏首屏图片再进入系统的功能。

## Android项目登录流程分析

### 原始流程
1. **登录成功** → 调用 `MainJumpUtils.jumpMainBridgeActivity(context)`
2. **进入SplashActivity**（欢迎/启动页）
3. **判断是否有服务窗地址**：
   - 有：进入 `LaunchAdvertActivity`（广告/首屏页，显示全屏图片，倒计时3秒）
   - 没有：进入平台选择页
4. **倒计时结束** → 自动跳转到主页面（H5或原生）

### 关键文件
- `MainJumpUtils.java` - 跳转工具类
- `SplashActivity.kt` - 启动/欢迎页
- `LaunchAdvertActivity.kt` - 广告/首屏页
- `BridgeActivity.kt` - H5主页面容器
- `MainActivity.java` - 原生主页面

## Flutter应用重构实现

### 新增文件

#### 1. 模型类
- `lib/models/home_url_info.dart` - 主页URL信息模型，对应Android的`H5SaveHomeUrlEntity`

#### 2. 页面
- `lib/pages/launch_advert_page.dart` - 广告/首屏页，对应Android的`LaunchAdvertActivity`
- `lib/pages/platform_select_page.dart` - 平台选择页
- `lib/pages/web_home_page.dart` - Web主页面，对应Android的`BridgeActivity`

#### 3. 工具类
- `lib/utils/navigation_utils.dart` - 导航工具类，对应Android的`MainJumpUtils`

#### 4. 服务类更新
- `lib/services/user_service.dart` - 添加HomeUrlInfo相关方法
- `lib/providers/user_provider.dart` - 添加HomeUrlInfo管理

### 路由配置更新
- `lib/routes/app_router.dart` - 添加新页面路由

## 登录流程实现

### 1. 登录成功处理
```dart
// 在验证码登录和密码登录页面中
if (user.needBindPhone == true) {
  context.go('/set-password'); // 跳转设置密码页面
} else {
  // 使用NavigationUtils进行登录成功后的跳转
  NavigationUtils.jumpMainBridgeActivity(context);
}
```

### 2. 导航工具类实现
```dart
class NavigationUtils {
  /// 登录后跳转至主页面
  /// 对应Android项目中的MainJumpUtils.jumpMainBridgeActivity方法
  static void jumpMainBridgeActivity(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    
    // 检查是否有主页URL信息
    if (userProvider.hasHomeUrlInfo) {
      // 有主页URL信息，跳转到广告页
      final homeUrlInfo = userProvider.homeUrlInfo!;
      context.go('/launch-advert', extra: homeUrlInfo);
    } else {
      // 没有主页URL信息，跳转到平台选择页
      context.go('/platform-select');
    }
  }
}
```

### 3. 广告页实现
```dart
class LaunchAdvertPage extends StatefulWidget {
  final HomeUrlInfo? windowInfo;
  
  // 3秒倒计时，显示全屏背景图片
  // 倒计时结束后自动跳转到主页面
}
```

### 4. 平台选择页实现
```dart
class PlatformSelectPage extends StatefulWidget {
  // 显示可用平台列表
  // 选择平台后保存信息并跳转到广告页
}
```

### 5. Web主页面实现
```dart
class WebHomePage extends StatefulWidget {
  // 使用WebView显示H5内容
  // 支持返回、刷新、菜单等功能
  // 对应Android的BridgeActivity
}
```

## 数据流

### 1. 用户登录
```
登录成功 → UserProvider.login() → 获取全局配置 → 获取用户详情 → 获取IM账号 → 获取主页URL信息
```

### 2. 主页URL信息管理
```
UserProvider.hasHomeUrlInfo → 检查是否有保存的主页URL信息
UserProvider.saveHomeUrlInfo() → 保存主页URL信息到本地存储
UserProvider.getHomeUrlInfo() → 获取主页URL信息
```

### 3. 页面跳转逻辑
```
登录成功 → NavigationUtils.jumpMainBridgeActivity()
  ↓
检查hasHomeUrlInfo
  ↓
有主页URL → LaunchAdvertPage（广告页，3秒倒计时）
  ↓
倒计时结束 → WebHomePage（H5主页面）
  ↓
无主页URL → PlatformSelectPage（平台选择页）
  ↓
选择平台 → LaunchAdvertPage（广告页）
  ↓
倒计时结束 → WebHomePage（H5主页面）
```

## 关键特性

### 1. 全屏广告页
- 显示全屏背景图片
- 3秒倒计时
- 显示服务名称和窗口名称
- 倒计时结束后自动跳转

### 2. 平台选择
- 显示可用平台列表
- 每个平台显示横幅图片、名称、服务名称
- 选择后保存信息并进入广告页

### 3. Web主页面
- 使用WebView显示H5内容
- 支持返回、刷新、菜单等功能
- 对应Android的BridgeActivity功能

### 4. 导航工具类
- 统一管理页面跳转逻辑
- 对应Android的MainJumpUtils功能
- 支持多种跳转方式

## 使用方式

### 1. 登录成功后跳转
```dart
// 在登录页面中
NavigationUtils.jumpMainBridgeActivity(context);
```

### 2. 保存主页URL信息
```dart
// 在平台选择页面中
await userProvider.saveHomeUrlInfo(selectedPlatform);
```

### 3. 跳转到H5页面
```dart
// 跳转到H5页面
NavigationUtils.jumpToBridgeActivity(
  context,
  title: '页面标题',
  url: 'https://example.com',
  isHome: true,
);
```

## 总结

通过本次重构，Flutter应用完全还原了Android项目的登录流程：

1. **登录成功** → 检查主页URL信息
2. **有主页URL** → 显示全屏广告页（3秒倒计时）
3. **无主页URL** → 进入平台选择页
4. **选择平台** → 显示全屏广告页
5. **倒计时结束** → 进入H5主页面

所有跳转逻辑都通过`NavigationUtils`工具类统一管理，确保了代码的一致性和可维护性。 