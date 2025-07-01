import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/webview_register/webview_register.dart';

class CompatibleWebView extends StatefulWidget {
  final String url;
  final String? title;
  final Function(String)? onPageStarted;
  final Function(String)? onPageFinished;
  final Function(String)? onNavigationRequest;

  const CompatibleWebView({
    super.key,
    required this.url,
    this.title,
    this.onPageStarted,
    this.onPageFinished,
    this.onNavigationRequest,
  });

  @override
  State<CompatibleWebView> createState() => _CompatibleWebViewState();
}

class _CompatibleWebViewState extends State<CompatibleWebView> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _hasError = false;
  static final Set<String> _registeredUrls = {};

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      if (!_registeredUrls.contains(widget.url)) {
        registerWebViewFactory(widget.url, widget.url);
        _registeredUrls.add(widget.url);
      }
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              setState(() {
                _loading = false;
                _hasError = false;
              });
              widget.onPageFinished?.call(url);
            },
            onPageStarted: (url) {
              setState(() => _loading = true);
              widget.onPageStarted?.call(url);
            },
            onWebResourceError: (error) {
              setState(() {
                _hasError = true;
                _loading = false;
              });
            },
            onNavigationRequest: (request) {
              widget.onNavigationRequest?.call(request.url);
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: HtmlElementView(viewType: widget.url),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return Stack(
        children: [
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('加载失败，请检查网络或稍后重试'),
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
            )
          else
            WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.open_in_browser, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('此平台不支持内置浏览器'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse(widget.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.open_in_browser),
            label: const Text('在浏览器中打开'),
          ),
        ],
      ),
    );
  }
}
