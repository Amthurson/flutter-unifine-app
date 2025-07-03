/**
 * Flutter WebView JavaScript Bridge
 * 用于Flutter与WebView之间的双向通信
 */

(function() {
    if (window.WebViewJavascriptBridge) {
        return;
    }

    var messagingIframe;
    var sendMessageQueue = [];
    var receiveMessageQueue = [];
    var messageHandlers = {};

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
        // 兼容H5依赖的iframe触发（可选）
        sendMessageQueue.push(message);
        if (messagingIframe) {
            messagingIframe.src = 'flutter://' + '__QUEUE_MESSAGE__/';
        }
        // 真正发给Flutter
        if (window.FlutterBridge) {
            window.FlutterBridge.postMessage(JSON.stringify(message));
        }
    }

    /**
     * 处理来自Flutter的消息
     */
    function _dispatchMessageFromFlutter(messageJSON) {
        setTimeout(function() {
            var message = JSON.parse(messageJSON);
            var responseCallback;
            if (message.responseId) {
                responseCallback = responseCallbacks[message.responseId];
                if (!responseCallback) return;
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
        if (WebViewJavascriptBridge._messageHandler) {
            throw new Error('WebViewJavascriptBridge.init called twice');
        }
        WebViewJavascriptBridge._messageHandler = messageHandler;
        var receivedMessages = receiveMessageQueue;
        receiveMessageQueue = null;
        for (var i = 0; i < receivedMessages.length; i++) {
            _dispatchMessageFromFlutter(receivedMessages[i]);
        }
    }

    // Flutter端会主动调用此方法，把消息回传给JS
    window._handleMessageFromFlutter = function(messageJSON) {
        _dispatchMessageFromFlutter(messageJSON);
    };

    /**
     * 创建全局对象
     */
    window.WebViewJavascriptBridge = {
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
    readyEvent.initEvent('WebViewJavascriptBridgeReady');
    readyEvent.bridge = WebViewJavascriptBridge;
    doc.dispatchEvent(readyEvent);

    /**
     * 便捷方法：获取Token
     */
    window.getToken = function(callback) {
        WebViewJavascriptBridge.callHandler('getToken', JSON.stringify({}), callback);
    };

    /**
     * 便捷方法：获取用户信息
     */
    window.getUserInfo = function(callback) {
        WebViewJavascriptBridge.callHandler('getUserInfo', null, callback);
    };

    /**
     * 便捷方法：获取设备信息
     */
    window.getDeviceInfo = function(callback) {
        WebViewJavascriptBridge.callHandler('getDeviceInfo', JSON.stringify({}), callback);
    };

    /**
     * 便捷方法：打开链接
     */
    window.openLink = function(url, callback) {
        WebViewJavascriptBridge.callHandler('openLink', JSON.stringify({url: url}), callback);
    };

    /**
     * 便捷方法：设置屏幕方向
     */
    window.setPortrait = function(callback) {
        WebViewJavascriptBridge.callHandler('setPortrait', null, callback);
    };

    window.setLandscape = function(callback) {
        WebViewJavascriptBridge.callHandler('setLandscape', null, callback);
    };

    /**
     * 便捷方法：获取权限
     */
    window.getCameraAuth = function(callback) {
        WebViewJavascriptBridge.callHandler('getCameraAuth', null, callback);
    };

    window.getLocationAuth = function(callback) {
        WebViewJavascriptBridge.callHandler('getLocationAuth', null, callback);
    };

    window.getMicrophoneAuth = function(callback) {
        WebViewJavascriptBridge.callHandler('getMicrophoneAuth', null, callback);
    };

    /**
     * 便捷方法：数据存储
     */
    window.saveH5Data = function(data, callback) {
        WebViewJavascriptBridge.callHandler('saveH5Data', JSON.stringify(data), callback);
    };

    window.getH5Data = function(callback) {
        WebViewJavascriptBridge.callHandler('getH5Data', null, callback);
    };

    /**
     * 便捷方法：网络信息
     */
    window.getNetworkConnectType = function(callback) {
        WebViewJavascriptBridge.callHandler('getNetworkConnectType', null, callback);
    };

    console.log('WebViewJavascriptBridge (Flutter版) initialized');
})(); 