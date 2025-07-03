# 统一Flutter Bridge方案

## 概述

本项目实现了统一的Flutter Bridge方案，将原有的双重Bridge架构（`window.WebViewJavascriptBridge` + `window.FlutterBridge`）统一为单一架构，同时保持与现有SDK的完全兼容性。

## 架构对比

### 原有架构
```
JavaScript SDK
    ↓ (依赖)
window.WebViewJavascriptBridge (API层)
    ↓ (消息传输)
window.FlutterBridge (Flutter通道)
    ↓
Flutter WebView
```

### 统一架构
```
JavaScript SDK
    ↓ (依赖)
window.WebViewJavascriptBridge (统一实现)
    ↓ (直接使用)
window.FlutterBridge (Flutter通道)
    ↓
Flutter WebView
```

## 核心文件

### 1. 统一Bridge实现
- **文件**: `assets/js/flutter_bridge_unified.js`
- **作用**: 提供统一的Bridge实现，完全兼容WebViewJavascriptBridge API
- **特点**: 
  - 直接使用FlutterBridge作为底层通道
  - 保持完整的API兼容性
  - 支持SDK的所有功能

### 2. 测试页面
- **文件**: `assets/test_unified.html`
- **作用**: 验证统一Bridge的功能和兼容性
- **测试项目**:
  - Bridge状态检查
  - 基础功能测试
  - SDK兼容性测试
  - 事件系统测试
  - 错误处理测试

### 3. Flutter集成
- **文件**: `lib/widgets/bridge_webview.dart`
- **修改**: 简化Bridge注入逻辑，使用统一的Bridge脚本

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
// ... 其他便捷方法
```

### 2. 事件系统兼容性
- 支持 `WebViewJavascriptBridgeReady` 事件
- 支持 `WVJBCallbacks` 机制
- 支持SDK的事件监听

### 3. SDK兼容性
基于你提供的SDK代码，统一Bridge支持：

```typescript
// SDK初始化
if (window.WebViewJavascriptBridge) {
    this.init(window.WebViewJavascriptBridge);
} else {
    document.addEventListener('WebViewJavascriptBridgeReady', () => {
        this.init(window.WebViewJavascriptBridge);
    });
}

// WVJBCallbacks机制
if (window.WVJBCallbacks) {
    window.WVJBCallbacks.push(this.init);
}

// Bridge方法调用
this.bridge.callHandler(handlerName, param, callback);
```

## 优势

### 1. 架构简化
- 减少了一层抽象
- 消息传输更直接
- 代码更简洁

### 2. 性能提升
- 减少中间环节
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

## 使用方法

### 1. 在Flutter中使用
```dart
// 使用统一的BridgeWebViewWidget
BridgeWebViewWidget(
  initialUrl: 'your-url',
  onWebViewCreated: (controller) {
    // 处理WebView创建
  },
)
```

### 2. 在JavaScript中使用
```javascript
// 现有代码无需修改
document.addEventListener('WebViewJavascriptBridgeReady', function() {
    // Bridge已就绪
});

// 调用Flutter方法
window.WebViewJavascriptBridge.callHandler('getToken', {}, function(response) {
    console.log('Token:', response);
});
```

### 3. 测试统一方案
```dart
// 导航到统一Bridge测试页面
context.go('/bridge-unified-test');
```

## 迁移指南

### 1. 渐进式迁移
1. 部署统一Bridge实现
2. 在测试环境验证兼容性
3. 逐步替换现有Bridge
4. 监控性能和稳定性

### 2. 回滚方案
如果遇到问题，可以快速回滚到原有实现：
- 恢复原有的Bridge注入逻辑
- 保持API不变，确保兼容性

### 3. 监控指标
- Bridge初始化成功率
- 消息传输延迟
- 错误率统计
- SDK兼容性验证

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

统一Bridge方案在保持完全兼容性的前提下，简化了架构，提升了性能，为后续的功能扩展和维护提供了更好的基础。建议在充分测试后进行生产环境部署。 