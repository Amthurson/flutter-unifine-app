import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/bridge/bridge_webview.dart' as bridge;
import '../utils/bridge/jssdk_handlers.dart';

/// Bridge WebView组件
class BridgeWebView extends StatefulWidget {
  final String url;
  final String? title;
  final bool isHome;
  final bool isShowClose;
  final Function(String)? onPageStarted;
  final Function(String)? onPageFinished;
  final Function(String)? onNavigationRequest;
  final Function(String)? onError;

  const BridgeWebView({
    super.key,
    required this.url,
    this.title,
    this.isHome = false,
    this.isShowClose = true,
    this.onPageStarted,
    this.onPageFinished,
    this.onNavigationRequest,
    this.onError,
  });

  @override
  State<BridgeWebView> createState() => _BridgeWebViewState();
}

class _BridgeWebViewState extends State<BridgeWebView> {
  late final WebViewController _controller;
  late final bridge.BridgeWebView _bridgeWebView;
  bool _loading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  /// 初始化WebView
  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _loading = true;
              _hasError = false;
            });
            widget.onPageStarted?.call(url);
          },
          onPageFinished: (url) {
            setState(() {
              _loading = false;
              _hasError = false;
            });
            widget.onPageFinished?.call(url);
            _initBridge();
          },
          onWebResourceError: (error) {
            setState(() {
              _hasError = true;
              _loading = false;
              _errorMessage = error.description;
            });
            widget.onError?.call(error.description);
          },
          onNavigationRequest: (request) {
            widget.onNavigationRequest?.call(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    // 初始化Bridge
    _bridgeWebView = bridge.BridgeWebView(controller: _controller);
    _registerHandlers();
  }

  /// 初始化Bridge
  void _initBridge() {
    // Bridge已经在构造函数中初始化，这里可以添加额外的初始化逻辑
  }

  /// 注册所有JSSDK处理器
  void _registerHandlers() {
    // 初始化处理器
    JSSDKHandlers.initHandlers(context);

    // 注册所有处理器
    final handlers = JSSDKHandlers.getAllHandlers();
    handlers.forEach((handlerName, handler) {
      _bridgeWebView.registerHandler(handlerName, handler);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null
          ? AppBar(
              title: Text(widget.title!),
              automaticallyImplyLeading: widget.isShowClose,
              leading: widget.isShowClose
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              actions: [
                if (widget.isHome)
                  IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      // 返回主页逻辑
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
              ],
            )
          : null,
      body: Stack(
        children: [
          if (_hasError)
            _buildErrorWidget()
          else
            WebViewWidget(controller: _controller),
          if (_loading && !_hasError)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  /// 构建错误显示组件
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('加载失败: $_errorMessage'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _loading = true;
              });
              _controller.reload();
            },
            child: const Text('重新加载'),
          ),
        ],
      ),
    );
  }
}

/// Bridge WebView页面
class BridgeWebViewPage extends StatelessWidget {
  final String url;
  final String? title;
  final bool isHome;
  final bool isShowClose;

  const BridgeWebViewPage({
    super.key,
    required this.url,
    this.title,
    this.isHome = false,
    this.isShowClose = true,
  });

  @override
  Widget build(BuildContext context) {
    return BridgeWebView(
      url: url,
      title: title,
      isHome: isHome,
      isShowClose: isShowClose,
      onPageStarted: (url) {
        print('页面开始加载: $url');
      },
      onPageFinished: (url) {
        print('页面加载完成: $url');
      },
      onNavigationRequest: (url) {
        print('导航请求: $url');
      },
      onError: (error) {
        print('页面加载错误: $error');
      },
    );
  }
}
