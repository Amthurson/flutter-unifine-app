/**
 * Flutter WebView JavaScript Bridge
 * 用于Flutter与WebView之间的双向通信
 */

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

    /**
     * 创建消息队列iframe
     */
    function _createQueueReadyIframe(doc) {
        messagingIframe = doc.createElement('iframe');
        messagingIframe.style.display = 'none';
        doc.documentElement.appendChild(messagingIframe);
    }

    /**
     * 发送消息到Flutter
     */
    function _sendMessage(message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
        }

        sendMessageQueue.push(message);
        messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
    }

    /**
     * 处理来自Flutter的消息
     */
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

    /**
     * 注册消息处理器
     */
    function registerHandler(handlerName, handler) {
        messageHandlers[handlerName] = handler;
    }

    /**
     * 调用Flutter方法
     */
    function callHandler(handlerName, data, responseCallback) {
        if (arguments.length === 2 && typeof data == 'function') {
            responseCallback = data;
            data = null;
        }
        _sendMessage({ handlerName: handlerName, data: data }, responseCallback);
    }

    /**
     * 发送消息到Flutter
     */
    function send(data, responseCallback) {
        _sendMessage(data, responseCallback);
    }

    /**
     * 初始化
     */
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

    /**
     * 发送消息到Flutter通道
     */
    function sendToFlutter(message) {
        if (window.FlutterBridge) {
            window.FlutterBridge.postMessage(JSON.stringify(message));
        }
    }

    /**
     * 重写_sendMessage方法，使用Flutter通道
     */
    _sendMessage = function(message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
        }
        sendToFlutter(message);
    };

    /**
     * 创建全局对象
     */
    window.FlutterWebViewJavascriptBridge = {
        registerHandler: registerHandler,
        callHandler: callHandler,
        send: send,
        init: init,
        _messageHandler: null
    };

    /**
     * 创建消息队列iframe
     */
    var doc = document;
    _createQueueReadyIframe(doc);

    /**
     * 注册WebViewJavascriptBridgeReady事件
     */
    var readyEvent = doc.createEvent('Events');
    readyEvent.initEvent('FlutterWebViewJavascriptBridgeReady');
    readyEvent.bridge = FlutterWebViewJavascriptBridge;
    doc.dispatchEvent(readyEvent);

    /**
     * 便捷方法：获取Token
     */
    window.getToken = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('getToken', null, callback);
    };

    /**
     * 便捷方法：获取用户信息
     */
    window.getUserInfo = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('getUserInfo', null, callback);
    };

    /**
     * 便捷方法：获取设备信息
     */
    window.getDeviceInfo = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('getDeviceInfo', null, callback);
    };

    /**
     * 便捷方法：打开链接
     */
    window.openLink = function(url, callback) {
        FlutterWebViewJavascriptBridge.callHandler('openLink', JSON.stringify({url: url}), callback);
    };

    /**
     * 便捷方法：设置屏幕方向
     */
    window.setPortrait = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('setPortrait', null, callback);
    };

    window.setLandscape = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('setLandscape', null, callback);
    };

    /**
     * 便捷方法：获取权限
     */
    window.getCameraAuth = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('getCameraAuth', null, callback);
    };

    window.getLocationAuth = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('getLocationAuth', null, callback);
    };

    window.getMicrophoneAuth = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('getMicrophoneAuth', null, callback);
    };

    /**
     * 便捷方法：数据存储
     */
    window.saveH5Data = function(data, callback) {
        FlutterWebViewJavascriptBridge.callHandler('saveH5Data', JSON.stringify(data), callback);
    };

    window.getH5Data = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('getH5Data', null, callback);
    };

    /**
     * 便捷方法：网络信息
     */
    window.getNetworkConnectType = function(callback) {
        FlutterWebViewJavascriptBridge.callHandler('getNetworkConnectType', null, callback);
    };

    console.log('FlutterWebViewJavascriptBridge initialized');
})(); 