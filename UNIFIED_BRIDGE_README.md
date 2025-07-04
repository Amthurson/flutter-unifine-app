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

### 2. Bridge WebView组件
- **文件**: `lib/widgets/bridge_webview.dart`
- **作用**: 核心Bridge WebView实现
- **功能**: 
  - WebView控制器管理
  - Bridge初始化
  - JSSDK处理器注册
  - 消息处理

### 3. JSSDK处理器
- **文件**: `lib/utils/bridge/jssdk_handlers.dart`
- **作用**: 所有JSSDK方法的Flutter端处理器
- **包含**: 基础功能、权限管理、用户信息、设备信息、蓝牙功能等

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
基于现有SDK代码，统一Bridge支持：

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

## 实现细节

### 1. JavaScript端实现

```javascript
// flutter_bridge_unified.js
(function() {
    if (window.WebViewJavascriptBridge) {
        console.log('[FlutterBridge] WebViewJavascriptBridge已存在，跳过初始化');
        return;
    }

    console.log('[FlutterBridge] 开始初始化统一Bridge');

    var messageHandlers = {};
    var responseCallbacks = {};
    var uniqueId = 1;

    /**
     * 发送消息到Flutter
     */
    function _sendMessage(message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
        }

        // 直接使用FlutterBridge发送
        if (window.FlutterBridge) {
            window.FlutterBridge.postMessage(JSON.stringify(message));
        } else {
            console.error('[FlutterBridge] FlutterBridge通道不存在');
            if (responseCallback) {
                responseCallback({ status: 'error', msg: 'FlutterBridge通道不存在' });
            }
        }
    }

    /**
     * 处理来自Flutter的消息
     */
    function _dispatchMessageFromFlutter(messageJSON) {
        setTimeout(function() {
            try {
                var message = JSON.parse(messageJSON);
                var responseCallback;

                if (message.responseId) {
                    // 处理响应
                    responseCallback = responseCallbacks[message.responseId];
                    if (responseCallback) {
                        responseCallback(message.responseData);
                        delete responseCallbacks[message.responseId];
                    }
                } else {
                    // 处理请求
                    if (message.callbackId) {
                        var callbackResponseId = message.callbackId;
                        responseCallback = function(responseData) {
                            _sendMessage({ 
                                responseId: callbackResponseId, 
                                responseData: responseData 
                            });
                        };
                    }

                    var handler = messageHandlers[message.handlerName];
                    if (handler) {
                        handler(message.data, responseCallback);
                    } else {
                        if (responseCallback) {
                            responseCallback({ status: 'error', msg: '未找到处理器: ' + message.handlerName });
                        }
                    }
                }
            } catch (e) {
                console.error('[FlutterBridge] 处理消息异常:', e);
            }
        });
    }

    /**
     * 创建全局对象 - 完全兼容WebViewJavascriptBridge API
     */
    window.WebViewJavascriptBridge = {
        registerHandler: function(handlerName, handler) {
            messageHandlers[handlerName] = handler;
        },
        callHandler: function(handlerName, data, responseCallback) {
            _sendMessage({ 
                handlerName: handlerName, 
                data: data 
            }, responseCallback);
        },
        send: function(data, responseCallback) {
            _sendMessage(data, responseCallback);
        },
        init: function(messageHandler) {
            if (WebViewJavascriptBridge._messageHandler) {
                throw new Error('WebViewJavascriptBridge.init called twice');
            }
            WebViewJavascriptBridge._messageHandler = messageHandler;
            
            // 触发就绪事件
            var readyEvent = document.createEvent('Events');
            readyEvent.initEvent('WebViewJavascriptBridgeReady');
            readyEvent.bridge = WebViewJavascriptBridge;
            document.dispatchEvent(readyEvent);

            // 处理WVJBCallbacks
            if (window.WVJBCallbacks) {
                window.WVJBCallbacks.forEach(function(callback) {
                    callback(WebViewJavascriptBridge);
                });
                window.WVJBCallbacks = null;
            }
        },
        _messageHandler: null
    };

    /**
     * Flutter端调用此方法处理消息
     */
    window._handleMessageFromFlutter = function(messageJSON) {
        _dispatchMessageFromFlutter(messageJSON);
    };

    /**
     * 兼容SDK的WVJBCallbacks机制
     */
    if (!window.WVJBCallbacks) {
        window.WVJBCallbacks = [];
    }

    /**
     * 便捷方法
     */
    window.getToken = function(callback) {
        WebViewJavascriptBridge.callHandler('getToken', {}, callback);
    };

    window.getUserInfo = function(callback) {
        WebViewJavascriptBridge.callHandler('getUserInfo', null, callback);
    };

    window.getDeviceInfo = function(callback) {
        WebViewJavascriptBridge.callHandler('getDeviceInfo', null, callback);
    };
})();
```

### 2. Flutter端实现

```dart
// bridge_webview.dart
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

  /// 发送响应到JavaScript
  void _sendResponseToJavaScript(String? callbackId, String response) {
    if (callbackId != null) {
      final responseScript = '''
        (function() {
          var message = {
            responseId: '$callbackId',
            responseData: $response
          };
          if (window._handleMessageFromFlutter) {
            window._handleMessageFromFlutter(JSON.stringify(message));
          }
        })();
      ''';
      controller.runJavaScript(responseScript);
    }
  }
}
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
// 使用BridgeWebViewWidget
BridgeWebViewWidget(
  initialUrl: 'your-url',
  navKey: navKey,
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

### 3. 在H5页面中使用
```javascript
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

统一Bridge方案在保持完全兼容性的前提下，简化了架构，提升了性能，为后续的功能扩展和维护提供了更好的基础。通过完整的JSSDK方法支持，实现了Flutter与H5的无缝通信。

建议在充分测试后进行生产环境部署，并持续监控系统性能和稳定性。 