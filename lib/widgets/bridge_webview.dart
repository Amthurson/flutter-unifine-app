import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:unified_front_end/utils/bridge/bridge_handler.dart';
import 'package:unified_front_end/utils/bridge/jssdk_handlers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:unified_front_end/widgets/navigation_bar_widget.dart';

/// Bridge WebView核心实现
class BridgeWebView {
  final WebViewController controller;
  final Map<String, BridgeHandler> _handlers = {};

  BridgeWebView({required this.controller});

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
  final GlobalKey<NavigationBarWidgetState>? navKey;
  final WebViewController? webViewController;

  const BridgeWebViewWidget({
    required this.initialUrl,
    this.onWebViewCreated,
    super.key,
    this.onPageStarted,
    this.onPageFinished,
    this.onNavigationRequest,
    this.navKey,
    this.webViewController,
  });

  @override
  State<BridgeWebViewWidget> createState() => _BridgeWebViewWidgetState();
}

class _BridgeWebViewWidgetState extends State<BridgeWebViewWidget> {
  late final WebViewController _controller;
  BridgeWebView? _bridgeWebView;
  bool _isInitialized = false;
  String? _bridgeScript;
  late final GlobalKey<NavigationBarWidgetState> navKey;

  @override
  void initState() {
    super.initState();
    _controller = widget.webViewController ?? WebViewController();

    navKey = widget.navKey ?? GlobalKey<NavigationBarWidgetState>();

    // 初始化JSSDK handlers
    JSSDKHandlers.initHandlers(context, navKey);

    // 预加载本地js内容
    rootBundle.loadString('assets/js/flutter_bridge_unified.js').then((js) {
      _bridgeScript = js;
    });

    _controller.addJavaScriptChannel(
      'FlutterBridge',
      onMessageReceived: (JavaScriptMessage message) {
        if (_bridgeWebView != null) {
          _bridgeWebView!.handleJavaScriptMessage(message.message);
        }
      },
    );

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          widget.onPageStarted?.call(url);
        },
        onPageFinished: (String url) async {
          widget.onPageFinished?.call(url);

          if (_isInitialized) {
            // 页面加载完成后检查历史状态
            _updateNavigationBarHistory();
            return;
          }

          _isInitialized = true;

          // 注入Bridge脚本
          if (_bridgeScript != null) {
            await _controller.runJavaScript(_bridgeScript!);
          } else {
            final js = await rootBundle
                .loadString('assets/js/flutter_bridge_unified.js');
            await _controller.runJavaScript(js);
          }

          // 注册所有handlers
          _bridgeWebView = BridgeWebView(controller: _controller);
          final allHandlers = JSSDKHandlers.getAllHandlers();
          allHandlers.forEach((name, handler) {
            _bridgeWebView!.registerHandler(name, handler);
          });

          // 初始化完成后检查历史状态
          _updateNavigationBarHistory();

          print('[Bridge] WebViewJavascriptBridge注入完成');
        },
        onNavigationRequest: (NavigationRequest request) {
          widget.onNavigationRequest?.call(request.url);
          return NavigationDecision.navigate;
        },
        onUrlChange: (UrlChange change) {
          // URL 变化时检查历史状态
          _updateNavigationBarHistory();
        },
      ),
    );
  }

  // 新增：更新导航栏历史状态
  Future<void> _updateNavigationBarHistory() async {
    try {
      final canGoBack = await _controller.canGoBack();
      navKey.currentState?.updateWebViewHistory(canGoBack);
    } catch (e) {
      print('[Bridge] 更新导航栏历史状态失败: $e');
    }
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
