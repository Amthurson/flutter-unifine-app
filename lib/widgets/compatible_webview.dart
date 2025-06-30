import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/webview_register/webview_register.dart';

class CompatibleWebView extends StatefulWidget {
  final String url;
  final String? title;

  const CompatibleWebView({super.key, required this.url, this.title});

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
            onPageFinished: (_) => setState(() {
              _loading = false;
              _hasError = false;
            }),
            onPageStarted: (_) => setState(() => _loading = true),
            onWebResourceError: (_) => setState(() {
              _hasError = true;
              _loading = false;
            }),
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
            const Center(child: Text('加载失败，请检查网络或稍后重试'))
          else
            WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        icon: const Icon(Icons.open_in_browser),
        label: const Text('在浏览器中打开'),
      ),
    );
  }
}
