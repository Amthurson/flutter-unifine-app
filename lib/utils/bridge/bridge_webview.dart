import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'bridge_handler.dart';

/// Bridge WebView核心实现
class BridgeWebView {
  final WebViewController controller;
  final Map<String, BridgeHandler> _handlers = {};
  final List<BridgeMessage> _startupMessages = [];
  bool _isReady = false;

  BridgeWebView({required this.controller}) {
    _initBridge();
  }

  /// 初始化Bridge
  void _initBridge() {
    // 注入JavaScript Bridge代码
    _injectBridgeScript();

    // 设置JavaScript通道
    controller.addJavaScriptChannel(
      'FlutterBridge',
      onMessageReceived: (JavaScriptMessage message) {
        _handleJavaScriptMessage(message.message);
      },
    );
  }

  /// 注入Bridge脚本
  void _injectBridgeScript() {
    const bridgeScript = '''
      (function() {
        if (window.FlutterWebViewJavascriptBridge) {
          return;
        }

        var messagingIframe;
        var sendMessageQueue = [];
        var receiveMessageQueue = [];
        var messageHandlers = {};

        var CUSTOM_PROTOCOL_SCHEME = 'flutter';
        var QUEUE_HAS_MESSAGE = '__QUEUE_MESSAGE__/';

        var responseCallbacks = {};
        var uniqueId = 1;

        // 创建消息队列iframe
        function _createQueueReadyIframe(doc) {
          messagingIframe = doc.createElement('iframe');
          messagingIframe.style.display = 'none';
          doc.documentElement.appendChild(messagingIframe);
        }

        // 发送消息到Flutter
        function _sendMessage(message, responseCallback) {
          if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
          }

          sendMessageQueue.push(message);
          messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
        }

        // 处理来自Flutter的消息
        function _dispatchMessageFromFlutter(messageJSON) {
          setTimeout(function _timeoutDispatchMessageFromFlutter() {
            var message = JSON.parse(messageJSON);
            var messageHandler;
            var responseCallback;

            if (message.responseId) {
              responseCallback = responseCallbacks[message.responseId];
              if (!responseCallback) {
                return;
              }
              responseCallback(message.responseData);
              delete responseCallbacks[message.responseId];
            } else {
              if (message.callbackId) {
                var callbackResponseId = message.callbackId;
                responseCallback = function(responseData) {
                  _sendMessage({ responseId: callbackResponseId, responseData: responseData });
                };
              }

              var handler = messageHandlers[message.handlerName];
              if (!handler) {
                console.log("WebViewJavascriptBridge: WARNING: no handler for message from Flutter:", message);
              } else {
                handler(message.data, responseCallback);
              }
            }
          });
          dispatchMessagingIframeEvent();
        }

        // 注册消息处理器
        function registerHandler(handlerName, handler) {
          messageHandlers[handlerName] = handler;
        }

        // 调用Flutter方法
        function callHandler(handlerName, data, responseCallback) {
          if (arguments.length === 2 && typeof data == 'function') {
            responseCallback = data;
            data = null;
          }
          _sendMessage({ handlerName: handlerName, data: data }, responseCallback);
        }

        // 发送消息到Flutter
        function send(data, responseCallback) {
          _sendMessage(data, responseCallback);
        }

        // 初始化
        function init(messageHandler) {
          if (FlutterWebViewJavascriptBridge._messageHandler) {
            throw new Error('FlutterWebViewJavascriptBridge.init called twice');
          }
          FlutterWebViewJavascriptBridge._messageHandler = messageHandler;
          var receivedMessages = receiveMessageQueue;
          receiveMessageQueue = null;
          for (var i = 0; i < receivedMessages.length; i++) {
            _dispatchMessageFromFlutter(receivedMessages[i]);
          }
        }

        // 创建全局对象
        window.FlutterWebViewJavascriptBridge = {
          registerHandler: registerHandler,
          callHandler: callHandler,
          send: send,
          init: init,
          _messageHandler: null
        };

        // 创建消息队列iframe
        var doc = document;
        _createQueueReadyIframe(doc);

        // 注册WebViewJavascriptBridgeReady事件
        var readyEvent = doc.createEvent('Events');
        readyEvent.initEvent('FlutterWebViewJavascriptBridgeReady');
        readyEvent.bridge = FlutterWebViewJavascriptBridge;
        doc.dispatchEvent(readyEvent);

        // 发送消息到Flutter通道
        function sendToFlutter(message) {
          if (window.FlutterBridge) {
            window.FlutterBridge.postMessage(JSON.stringify(message));
          }
        }

        // 重写_sendMessage方法，使用Flutter通道
        _sendMessage = function(message, responseCallback) {
          if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
          }
          sendToFlutter(message);
        };
      })();
    ''';

    controller.runJavaScript(bridgeScript);
  }

  /// 注册处理器
  void registerHandler(String handlerName, BridgeHandler handler) {
    _handlers[handlerName] = handler;
  }

  /// 处理JavaScript消息
  void _handleJavaScriptMessage(String message) {
    try {
      final messageData = jsonDecode(message);
      final bridgeMessage = BridgeMessage.fromJson(messageData);

      final handler = _handlers[bridgeMessage.handlerName];
      if (handler != null) {
        handler.call(bridgeMessage.data, (response) {
          _sendResponseToJavaScript(bridgeMessage.callbackId, response);
        });
      } else {
        print('Bridge: No handler found for ${bridgeMessage.handlerName}');
        _sendResponseToJavaScript(
            bridgeMessage.callbackId,
            BridgeResponse.error(msg: '未找到处理器: ${bridgeMessage.handlerName}')
                .toJsonString());
      }
    } catch (e) {
      print('Bridge: Error handling message: $e');
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
          if (window.FlutterWebViewJavascriptBridge && window.FlutterWebViewJavascriptBridge._messageHandler) {
            window.FlutterWebViewJavascriptBridge._messageHandler(message);
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
        if (window.FlutterWebViewJavascriptBridge) {
          window.FlutterWebViewJavascriptBridge.callHandler('$handlerName', '$data', function(response) {
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
        if (window.FlutterWebViewJavascriptBridge) {
          window.FlutterWebViewJavascriptBridge.send('$data', function(response) {
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