import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:unified_front_end/utils/bridge/bridge_handler.dart';
import 'package:unified_front_end/utils/bridge/jssdk_handlers.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Bridge WebView核心实现
class BridgeWebView {
  final WebViewController controller;
  final Map<String, BridgeHandler> _handlers = {};
  final List<BridgeMessage> _startupMessages = [];
  final bool _isReady = false;

  BridgeWebView({required this.controller}) {
    _initBridge();
  }

  /// 初始化Bridge
  void _initBridge() {
    print('[Bridge] 初始化Bridge');
    // 注入JavaScript Bridge代码
    _injectBridgeScript();
  }

  /// 注入统一的Bridge脚本
  void _injectBridgeScript() {
    // 使用统一的Bridge实现
    controller.runJavaScript('''
      // 加载统一的Bridge脚本
      var script = document.createElement('script');
      script.src = 'assets/js/flutter_bridge_unified.js';
      document.head.appendChild(script);
    ''');
  }

  /// 注册处理器
  void registerHandler(String handlerName, BridgeHandler handler) {
    print('[Bridge] 注册handler: $handlerName');
    _handlers[handlerName] = handler;
  }

  /// 处理JavaScript消息
  void handleJavaScriptMessage(String message) {
    print('[Bridge] 收到JS消息: $message');
    try {
      final messageData = jsonDecode(message);
      print('[Bridge] 解析后的消息数据: $messageData');

      // 检查消息格式
      if (messageData['handlerName'] == null) {
        print('[Bridge] 消息格式错误，缺少handlerName');
        return;
      }

      final bridgeMessage = BridgeMessage.fromJson(messageData);
      print(
          '[Bridge] handlerName: ${bridgeMessage.handlerName}, callbackId: ${bridgeMessage.callbackId}');

      final handler = _handlers[bridgeMessage.handlerName];
      if (handler != null) {
        print('[Bridge] 调用handler: ${bridgeMessage.handlerName}');
        // 直接传递data，让handler自己处理类型转换
        handler.call(bridgeMessage.data, (response) {
          print('[Bridge] handler响应: $response');
          _sendResponseToJavaScript(bridgeMessage.callbackId, response);
        });
      } else {
        print('[Bridge] 未找到handler: ${bridgeMessage.handlerName}');
        print('[Bridge] 可用的handlers: ${_handlers.keys.toList()}');
        _sendResponseToJavaScript(
            bridgeMessage.callbackId,
            BridgeResponse.error(msg: '未找到处理器: ${bridgeMessage.handlerName}')
                .toJsonString());
      }
    } catch (e) {
      print('[Bridge] 处理消息异常: $e');
      print('[Bridge] 原始消息: $message');
    }
  }

  /// 发送响应到JavaScript
  void _sendResponseToJavaScript(String? callbackId, String response) {
    if (callbackId != null) {
      print('[Bridge] 发送响应到JS, callbackId: $callbackId, response: $response');
      final responseScript = '''
        (function() {
          var message = {
            responseId: '$callbackId',
            responseData: $response
          };
          console.log('[Bridge] 发送响应消息:', message);
          // 直接调用统一Bridge的消息处理函数
          if (window._handleMessageFromFlutter) {
            window._handleMessageFromFlutter(JSON.stringify(message));
          } else {
            console.error('[Bridge] _handleMessageFromFlutter不存在');
          }
        })();
      ''';
      controller.runJavaScript(responseScript);
    }
  }

  /// 调用JavaScript方法
  void callHandler(
      String handlerName, String data, Function(String)? callback) {
    final script = '''
      (function() {
        if (window.WebViewJavascriptBridge) {
          window.WebViewJavascriptBridge.callHandler('$handlerName', '$data', function(response) {
            window.FlutterBridge.postMessage(JSON.stringify({
              type: 'callback',
              data: response
            }));
          });
        }
      })();
    ''';
    controller.runJavaScript(script);
  }

  /// 发送消息到JavaScript
  void send(String data, Function(String)? callback) {
    final script = '''
      (function() {
        if (window.WebViewJavascriptBridge) {
          window.WebViewJavascriptBridge.send('$data', function(response) {
            window.FlutterBridge.postMessage(JSON.stringify({
              type: 'callback',
              data: response
            }));
          });
        }
      })();
    ''';
    controller.runJavaScript(script);
  }
}

class BridgeWebViewWidget extends StatefulWidget {
  final String initialUrl;
  final void Function(WebViewController controller)? onWebViewCreated;
  final void Function(String url)? onPageStarted;
  final void Function(String url)? onPageFinished;
  final void Function(String url)? onNavigationRequest;

  const BridgeWebViewWidget(
      {required this.initialUrl,
      this.onWebViewCreated,
      super.key,
      this.onPageStarted,
      this.onPageFinished,
      this.onNavigationRequest});

  @override
  State<BridgeWebViewWidget> createState() => _BridgeWebViewWidgetState();
}

class _BridgeWebViewWidgetState extends State<BridgeWebViewWidget> {
  late final WebViewController _controller;
  BridgeWebView? _bridgeWebView;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();

    // 初始化JSSDK handlers
    JSSDKHandlers.initHandlers(context);

    _controller.addJavaScriptChannel(
      'FlutterBridge',
      onMessageReceived: (JavaScriptMessage message) {
        print('[Bridge] 收到FlutterBridge消息: ${message.message}');
        // 如果有BridgeWebView实例，则处理消息
        if (_bridgeWebView != null) {
          _bridgeWebView!.handleJavaScriptMessage(message.message);
        } else {
          print('[Bridge] BridgeWebView实例不存在，无法处理消息');
        }
      },
    );

    // 设置导航代理
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) async {
          print('[Bridge] 页面加载完成: $url');
          if (_isInitialized) return;
          _isInitialized = true;

          // 注册所有handlers
          _bridgeWebView = BridgeWebView(controller: _controller);
          final allHandlers = JSSDKHandlers.getAllHandlers();
          allHandlers.forEach((name, handler) {
            _bridgeWebView!.registerHandler(name, handler);
          });

          // 注入Bridge脚本
          final bridgeScript = await loadBridgeScript();
          await _controller.runJavaScript(bridgeScript);
          print('[Bridge] WebViewJavascriptBridge注入完成');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller
        ..loadRequest(Uri.parse(widget.initialUrl))
        ..setJavaScriptMode(JavaScriptMode.unrestricted),
    );
  }
}

Future<String> loadBridgeScript() async {
  return await rootBundle.loadString('assets/js/flutter_bridge_unified.js');
}
