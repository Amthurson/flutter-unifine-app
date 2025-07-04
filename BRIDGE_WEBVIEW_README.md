# Flutter Bridge WebView 完整实现

基于统一Bridge架构，为Flutter应用实现了完整的WebView Bridge通讯系统，支持Flutter与H5的双向通信。

## 文件结构

```
lib/
├── utils/
│   └── bridge/
│       ├── bridge_handler.dart      # Bridge处理器接口和数据模型
│       └── jssdk_handlers.dart      # 所有JSSDK方法处理器
├── widgets/
│   ├── bridge_webview.dart          # Bridge WebView核心组件
│   ├── compatible_webview.dart      # 兼容性WebView组件
│   └── navigation_bar_widget.dart   # 导航栏组件
└── assets/
    └── js/
        └── flutter_bridge_unified.js # 统一JavaScript Bridge文件
```

## 统一Bridge架构

### 核心文件

#### 1. 统一Bridge实现
- **文件**: `assets/js/flutter_bridge_unified.js`
- **作用**: 提供统一的Bridge实现，完全兼容WebViewJavascriptBridge API
- **特点**: 
  - 直接使用FlutterBridge作为底层通道
  - 保持完整的API兼容性
  - 支持SDK的所有功能

#### 2. Bridge WebView组件
- **文件**: `lib/widgets/bridge_webview.dart`
- **作用**: 核心Bridge WebView实现
- **功能**: 
  - WebView控制器管理
  - Bridge初始化
  - JSSDK处理器注册
  - 消息处理

#### 3. 兼容性WebView组件
- **文件**: `lib/widgets/compatible_webview.dart`
- **作用**: 跨平台WebView兼容层
- **支持**: Android、iOS、Web平台

## 初始化流程

### 1. Bridge WebView初始化

```dart
class BridgeWebViewWidget extends StatefulWidget {
  final String initialUrl;
  final GlobalKey<NavigationBarWidgetState>? navKey;

  @override
  State<BridgeWebViewWidget> createState() => _BridgeWebViewWidgetState();
}

class _BridgeWebViewWidgetState extends State<BridgeWebViewWidget> {
  late final WebViewController _controller;
  BridgeWebView? _bridgeWebView;
  String? _bridgeScript;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    
    // 初始化JSSDK handlers
    JSSDKHandlers.initHandlers(context, navKey);

    // 预加载本地js内容
    rootBundle.loadString('assets/js/flutter_bridge_unified.js').then((js) {
      _bridgeScript = js;
    });

    // 设置JavaScript通道
    _controller.addJavaScriptChannel(
      'FlutterBridge',
      onMessageReceived: (JavaScriptMessage message) {
        if (_bridgeWebView != null) {
          _bridgeWebView!.handleJavaScriptMessage(message.message);
        }
      },
    );
  }
}
```

### 2. Bridge核心初始化

```dart
class BridgeWebView {
  final WebViewController controller;
  final Map<String, BridgeHandler> _handlers = {};

  BridgeWebView({required this.controller});

  /// 注册处理器
  void registerHandler(String handlerName, BridgeHandler handler) {
    _handlers[handlerName] = handler;
  }

  /// 处理JavaScript消息
  void handleJavaScriptMessage(String message) {
    try {
      final messageData = jsonDecode(message);
      final bridgeMessage = BridgeMessage.fromJson(messageData);
      
      final handler = _handlers[bridgeMessage.handlerName];
      if (handler != null) {
        handler.call(bridgeMessage.data, (response) {
          _sendResponseToJavaScript(bridgeMessage.callbackId, response);
        });
      }
    } catch (e) {
      print('[Bridge] 处理消息异常: $e');
    }
  }
}
```

### 3. JSSDK处理器注册

```dart
class JSSDKHandlers {
  static final Map<String, BridgeHandler> handlers = {};

  /// 初始化所有处理器
  static void initHandlers(BuildContext context, GlobalKey<NavigationBarWidgetState> navKey) {
    // 基础功能
    handlers['setPortrait'] = _SetPortraitHandler();
    handlers['setLandscape'] = _SetLandscapeHandler();
    handlers['getToken'] = _GetTokenHandler();
    handlers['saveHomeUrl'] = _SaveHomeUrlHandler();
    handlers['openLink'] = _OpenLinkHandler();
    handlers['showFloat'] = _ShowFloatHandler();
    handlers['preRefresh'] = _PreRefreshHandler();
    handlers['setNavigation'] = _SetNavigationHandler(navKey);

    // 权限相关
    handlers['getCameraAuth'] = _GetCameraAuthHandler();
    handlers['getLocationAuth'] = _GetLocationAuthHandler();
    handlers['getMicrophoneAuth'] = _GetMicrophoneAuthHandler();
    handlers['getCalendarsAuth'] = _GetCalendarsAuthHandler();
    handlers['getStorageAuth'] = _GetStorageAuthHandler();
    handlers['getBluetoothAuth'] = _GetBluetoothAuthHandler();
    handlers['getAddressBook'] = _GetAddressBookHandler();

    // 用户信息
    handlers['getUserInfo'] = _GetUserInfoHandler();
    handlers['getSessionStorage'] = _GetSessionStorageHandler();
    handlers['autoLogin'] = _AutoLoginHandler();
    handlers['reStartLogin'] = _ReStartLoginHandler();

    // 设备信息
    handlers['getDeviceInfo'] = _GetDeviceInfoHandler();
    handlers['getMobileDeviceInformation'] = _GetMobileDeviceInformationHandler();

    // 网络功能
    handlers['getNetworkConnectType'] = _GetNetworkConnectTypeHandler();

    // 数据存储
    handlers['saveH5Data'] = _SaveH5DataHandler();
    handlers['getH5Data'] = _GetH5DataHandler();

    // 系统功能
    handlers['setCanInterceptBackKey'] = _SetCanInterceptBackKeyHandler();
    handlers['checkAppVersion'] = _CheckAppVersionHandler();
    handlers['deleteAccount'] = _DeleteAccountHandler();
    handlers['uploadLogFile'] = _UploadLogFileHandler();

    // 应用启动
    handlers['launchApp'] = _LaunchAppHandler();

    // 蓝牙功能
    handlers['checkBtEnable'] = _CheckBtEnableHandler();
    handlers['getBtDeviceList'] = _GetBtDeviceListHandler();
    handlers['connectToBtDevice'] = _ConnectToBtDeviceHandler();
    handlers['disconnectBtDevice'] = _DisconnectBtDeviceHandler();
  }
}
```

## 完整的JSSDK方法列表

### 基础功能 (8个)
- `setPortrait` - 设置竖屏
- `setLandscape` - 设置横屏
- `getToken` - 获取用户Token
- `saveHomeUrl` - 保存主页URL
- `openLink` - 打开外部链接
- `showFloat` - 显示悬浮窗
- `preRefresh` - 页面刷新
- `setNavigation` - 设置导航栏

### 权限管理 (7个)
- `getCameraAuth` - 相机权限
- `getLocationAuth` - 位置权限
- `getMicrophoneAuth` - 麦克风权限
- `getCalendarsAuth` - 日历权限
- `getStorageAuth` - 存储权限
- `getBluetoothAuth` - 蓝牙权限
- `getAddressBook` - 通讯录权限

### 用户信息 (4个)
- `getUserInfo` - 获取用户信息
- `getSessionStorage` - 获取会话存储
- `autoLogin` - 自动登录
- `reStartLogin` - 重新登录

### 设备信息 (2个)
- `getDeviceInfo` - 获取设备信息
- `getMobileDeviceInformation` - 获取移动设备信息

### 网络功能 (1个)
- `getNetworkConnectType` - 获取网络连接类型

### 数据存储 (2个)
- `saveH5Data` - 保存H5数据
- `getH5Data` - 获取H5数据

### 系统功能 (4个)
- `setCanInterceptBackKey` - 设置拦截返回键
- `checkAppVersion` - 检查应用版本
- `deleteAccount` - 删除账号
- `uploadLogFile` - 上传日志文件

### 应用启动 (1个)
- `launchApp` - 启动指定应用

### 蓝牙功能 (4个)
- `checkBtEnable` - 检查蓝牙是否可用
- `getBtDeviceList` - 获取蓝牙设备列表
- `connectToBtDevice` - 连接蓝牙设备
- `disconnectBtDevice` - 断开蓝牙设备

## 通讯机制

### 1. JavaScript调用Flutter

```javascript
// 调用Flutter方法
window.WebViewJavascriptBridge.callHandler('getToken', null, function(response) {
    console.log('Token:', response);
});

// 使用便捷方法
window.getToken(function(response) {
    console.log('Token:', response);
});
```

### 2. Flutter处理JavaScript请求

```dart
class _GetTokenHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final token = await UserService.getToken();
      callback(BridgeResponse.success(data: {'token': token}).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取Token失败: $e').toJsonString());
    }
  }
}
```

### 3. 数据格式

**请求格式：**
```json
{
  "handlerName": "getToken",
  "data": null,
  "callbackId": "cb_1_1640995200000"
}
```

**响应格式：**
```json
{
  "status": "success",
  "msg": "成功",
  "data": {
    "token": "user_token_123456"
  }
}
```

## 使用方法

### 1. 基本使用

```dart
// 在页面中使用CompatibleWebView
CompatibleWebView(
  url: 'https://example.com',
  title: '示例页面',
  onPageStarted: (url) => print('页面开始加载: $url'),
  onPageFinished: (url) => print('页面加载完成: $url'),
  onNavigationRequest: (url) => print('导航请求: $url'),
)
```

### 2. 带导航栏的WebView

```dart
// 在WebHomePage中使用
WebHomePage(
  title: '页面标题',
  url: 'https://example.com',
  isHome: true,
)
```

### 3. JavaScript端使用

```javascript
// 获取Token
window.WebViewJavascriptBridge.callHandler('getToken', {}, function(response) {
    if (response.status === 'success') {
        console.log('Token:', response.data.token);
    }
});

// 保存主页URL
window.WebViewJavascriptBridge.callHandler('saveHomeUrl', {
    indexUrl: 'https://example.com/home',
    windowsName: '主页'
}, function(response) {
    console.log('保存结果:', response);
});

// 打开链接
window.WebViewJavascriptBridge.callHandler('openLink', {
    url: 'https://example.com/new-page',
    title: '新页面',
    isHome: false
}, function(response) {
    console.log('打开结果:', response);
});
```

## 兼容性保证

### 1. API兼容性
统一Bridge完全实现了WebViewJavascriptBridge的所有API：

```javascript
// 核心方法
window.WebViewJavascriptBridge.callHandler(handlerName, data, callback)
window.WebViewJavascriptBridge.registerHandler(handlerName, handler)
window.WebViewJavascriptBridge.send(data, callback)
window.WebViewJavascriptBridge.init(messageHandler)

// 便捷方法
window.getToken(callback)
window.getUserInfo(callback)
window.getDeviceInfo(callback)
```

### 2. 事件系统兼容性
- 支持 `WebViewJavascriptBridgeReady` 事件
- 支持 `WVJBCallbacks` 机制
- 支持SDK的事件监听

### 3. 跨平台兼容性
- **Android**: 使用 `webview_flutter` 插件
- **iOS**: 使用 `webview_flutter` 插件
- **Web**: 使用 `HtmlElementView` 和 iframe

## 优势

### 1. 架构简化
- 统一的Bridge实现
- 减少中间环节
- 代码更简洁

### 2. 性能提升
- 直接使用FlutterBridge通道
- 降低内存占用
- 提高响应速度

### 3. 维护性
- 单一实现，易于维护
- 统一的错误处理
- 更好的调试体验

### 4. 兼容性
- 完全向后兼容
- 无需修改现有SDK
- 支持渐进式迁移

## 注意事项

### 1. 加载顺序
确保FlutterBridge通道在Bridge脚本加载前已创建：
```dart
// 在WebView初始化时创建通道
controller.addJavaScriptChannel(
  'FlutterBridge',
  onMessageReceived: (message) {
    // 处理消息
  },
);
```

### 2. 错误处理
统一Bridge包含完善的错误处理：
- FlutterBridge通道不存在时的降级处理
- 消息解析异常的处理
- 回调函数丢失的处理

### 3. 调试支持
- 详细的日志输出
- 错误信息提示
- 状态检查功能

## 总结

统一Bridge方案在保持完全兼容性的前提下，简化了架构，提升了性能，为后续的功能扩展和维护提供了更好的基础。通过完整的JSSDK方法支持，实现了Flutter与H5的无缝通信。 