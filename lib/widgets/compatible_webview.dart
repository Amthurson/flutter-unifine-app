import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/webview_register/webview_register.dart';
import './bridge_webview.dart';

class CompatibleWebView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (kIsWeb) {
      registerWebViewFactory('iframe-view', url);
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const HtmlElementView(viewType: 'iframe-view'),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return Stack(
        children: [
          BridgeWebViewWidget(
            initialUrl: url,
            onPageStarted: onPageStarted,
            onPageFinished: onPageFinished,
            onNavigationRequest: onNavigationRequest,
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
              final uri = Uri.parse(url);
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
