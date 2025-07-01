# Flutter Bridge WebView 完整实现

基于安卓JSSDK Bridge分析，为Flutter应用实现了完整的WebView Bridge通讯系统。

## 文件结构

```
lib/
├── utils/
│   └── bridge/
│       ├── bridge_handler.dart      # Bridge处理器接口和数据模型
│       ├── bridge_webview.dart      # Bridge WebView核心实现
│       └── jssdk_handlers.dart      # 所有JSSDK方法处理器
├── widgets/
│   ├── bridge_webview.dart          # Bridge WebView组件
│   └── compatible_webview.dart      # 兼容性WebView组件
├── pages/
│   └── bridge_demo_page.dart        # Bridge演示页面
└── assets/
    └── js/
        └── webview_javascript_bridge.js  # JavaScript Bridge文件
```

## 初始化流程

### 1. 用户登录成功后跳转

```dart
// 在登录成功后，跳转到Bridge WebView页面
Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (context) => BridgeWebViewPage(
      url: homeUrl,
      title: '主页',
      isHome: true,
    ),
  ),
);
```

### 2. Bridge WebView初始化

```dart
class _BridgeWebViewState extends State<BridgeWebView> {
  late final WebViewController _controller;
  late final bridge.BridgeWebView _bridgeWebView;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    // 1. 创建WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(...))
      ..loadRequest(Uri.parse(widget.url));

    // 2. 初始化Bridge
    _bridgeWebView = bridge.BridgeWebView(controller: _controller);
    
    // 3. 注册所有JSSDK处理器
    _registerHandlers();
  }
}
```

### 3. Bridge核心初始化

```dart
class BridgeWebView {
  BridgeWebView({required this.controller}) {
    _initBridge();
  }

  void _initBridge() {
    // 1. 注入JavaScript Bridge代码
    _injectBridgeScript();
    
    // 2. 设置JavaScript通道
    controller.addJavaScriptChannel(
      'FlutterBridge',
      onMessageReceived: (JavaScriptMessage message) {
        _handleJavaScriptMessage(message.message);
      },
    );
  }
}
```

### 4. JavaScript Bridge注入

```dart
void _injectBridgeScript() {
  const bridgeScript = '''
    (function() {
      // JavaScript Bridge实现代码
      // 创建全局FlutterWebViewJavascriptBridge对象
      // 设置消息队列和回调机制
    })();
  ''';
  
  controller.runJavaScript(bridgeScript);
}
```

### 5. JSSDK处理器注册

```dart
void _registerHandlers() {
  // 初始化所有处理器
  JSSDKHandlers.initHandlers(context);
  
  // 注册所有处理器
  final handlers = JSSDKHandlers.getAllHandlers();
  handlers.forEach((handlerName, handler) {
    _bridgeWebView.registerHandler(handlerName, handler);
  });
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

## 通讯机制

### 1. JavaScript调用Flutter

```javascript
// 调用Flutter方法
window.FlutterWebViewJavascriptBridge.callHandler('getToken', null, function(response) {
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
  void call(String data, Function(String) callback) {
    final token = "mock_token_123456";
    callback(BridgeResponse.success(data: {'token': token}).toJsonString());
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
    "token": "mock_token_123456"
  }
}
```

## 使用方法

### 1. 基本使用

```dart
// 打开Bridge WebView页面
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => BridgeWebViewPage(
      url: 'https://example.com',
      title: '示例页面',
    ),
  ),
);
```

### 2. 自定义配置

```dart
BridgeWebView(
  url: 'https://example.com',
  title: '自定义页面',
  isHome: true,
  isShowClose: false,
  onPageStarted: (url) => print('页面开始加载: $url'),
  onPageFinished: (url) => print('页面加载完成: $url'),
  onNavigationRequest: (url) => print('导航请求: $url'),
  onError: (error) => print('页面错误: $error'),
)
```

### 3. JavaScript端使用

```html
<!DOCTYPE html>
<html>
<head>
    <title>Bridge测试</title>
</head>
<body>
    <button onclick="testBridge()">测试Bridge</button>
    <div id="result"></div>

    <script>
        // 等待Bridge初始化
        document.addEventListener('FlutterWebViewJavascriptBridgeReady', function(event) {
            console.log('Bridge已就绪');
        });

        function testBridge() {
            // 获取Token
            window.getToken(function(response) {
                document.getElementById('result').textContent = 
                    'Token: ' + JSON.stringify(response);
            });
        }
    </script>
</body>
</html>
```

## 依赖包

在`pubspec.yaml`中添加以下依赖：

```yaml
dependencies:
  webview_flutter: ^4.4.2
  permission_handler: ^11.1.0
  device_info_plus: ^9.1.1
  connectivity_plus: ^5.0.2
  shared_preferences: ^2.2.2
  url_launcher: ^6.2.2
```

## 注意事项

1. **权限配置**：在Android和iOS平台需要配置相应的权限
2. **JavaScript注入**：确保在页面加载完成后注入Bridge脚本
3. **错误处理**：所有处理器都应该包含适当的错误处理
4. **内存管理**：及时清理回调函数避免内存泄漏
5. **平台兼容**：确保在不同平台上的一致性

## 扩展功能

可以根据需要添加更多JSSDK方法：

1. 在`jssdk_handlers.dart`中添加新的处理器
2. 在`JSSDKHandlers.initHandlers()`中注册新处理器
3. 在JavaScript Bridge文件中添加便捷方法

这个实现提供了完整的Flutter WebView Bridge通讯系统，支持双向通信和丰富的原生功能调用。 