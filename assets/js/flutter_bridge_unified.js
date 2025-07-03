/**
 * 统一的Flutter Bridge实现
 * 完全兼容WebViewJavascriptBridge API，但使用FlutterBridge作为底层通道
 * 支持现有SDK的无缝迁移
 */

(function() {
    if (window.WebViewJavascriptBridge) {
        console.log('[FlutterBridge] WebViewJavascriptBridge已存在，跳过初始化');
        return;
    }

    console.log('[FlutterBridge] 开始初始化统一Bridge');

    var messageHandlers = {};
    var responseCallbacks = {};
    var uniqueId = 1;
    var isReady = false;

    /**
     * 发送消息到Flutter
     */
    function _sendMessage(message, responseCallback) {
        console.log('[FlutterBridge] 发送消息:', message);
        
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
        console.log('[FlutterBridge] 收到Flutter消息:', messageJSON);
        
        setTimeout(function() {
            try {
                var message = JSON.parse(messageJSON);
                var responseCallback;

                if (message.responseId) {
                    // 处理响应
                    responseCallback = responseCallbacks[message.responseId];
                    if (!responseCallback) {
                        console.warn('[FlutterBridge] 未找到回调函数:', message.responseId);
                        return;
                    }
                    responseCallback(message.responseData);
                    delete responseCallbacks[message.responseId];
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
                    if (!handler) {
                        console.warn("[FlutterBridge] 未找到处理器:", message.handlerName);
                        if (responseCallback) {
                            responseCallback({ status: 'error', msg: '未找到处理器: ' + message.handlerName });
                        }
                    } else {
                        handler(message.data, responseCallback);
                    }
                }
            } catch (e) {
                console.error('[FlutterBridge] 处理消息异常:', e);
            }
        });
    }

    /**
     * 注册消息处理器
     */
    function registerHandler(handlerName, handler) {
        console.log('[FlutterBridge] 注册处理器:', handlerName);
        messageHandlers[handlerName] = handler;
    }

    /**
     * 调用Flutter方法
     */
    function callHandler(handlerName, data, responseCallback) {
        console.log('[FlutterBridge] 调用Flutter方法:', handlerName, data);
        
        if (arguments.length === 2 && typeof data == 'function') {
            responseCallback = data;
            data = null;
        }
        
        _sendMessage({ 
            handlerName: handlerName, 
            data: data 
        }, responseCallback);
    }

    /**
     * 发送消息到Flutter
     */
    function send(data, responseCallback) {
        _sendMessage(data, responseCallback);
    }

    /**
     * 初始化 - 兼容SDK的init方法
     */
    function init(messageHandler) {
        console.log('[FlutterBridge] 初始化Bridge');
        if (WebViewJavascriptBridge._messageHandler) {
            throw new Error('WebViewJavascriptBridge.init called twice');
        }
        WebViewJavascriptBridge._messageHandler = messageHandler;
        
        // 标记为就绪
        isReady = true;
        
        // 触发就绪事件
        _triggerReadyEvent();
    }

    /**
     * 触发就绪事件
     */
    function _triggerReadyEvent() {
        // 触发WebViewJavascriptBridgeReady事件
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

        console.log('[FlutterBridge] Bridge就绪事件已触发');
    }

    /**
     * 创建全局对象 - 完全兼容WebViewJavascriptBridge API
     */
    window.WebViewJavascriptBridge = {
        registerHandler: registerHandler,
        callHandler: callHandler,
        send: send,
        init: init,
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
     * 便捷方法：获取Token
     */
    window.getToken = function(callback) {
        WebViewJavascriptBridge.callHandler('getToken', {}, callback);
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
        WebViewJavascriptBridge.callHandler('getDeviceInfo', {}, callback);
    };

    /**
     * 便捷方法：打开链接
     */
    window.openLink = function(url, callback) {
        WebViewJavascriptBridge.callHandler('openLink', {url: url}, callback);
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
        WebViewJavascriptBridge.callHandler('saveH5Data', data, callback);
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

    // 自动触发就绪事件（如果FlutterBridge已存在）
    if (window.FlutterBridge) {
        setTimeout(function() {
            if (!isReady) {
                _triggerReadyEvent();
            }
        }, 100);
    }

    console.log('[FlutterBridge] 统一Bridge初始化完成');
})(); 