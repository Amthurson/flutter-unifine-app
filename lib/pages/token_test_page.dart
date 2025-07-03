import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../widgets/bridge_webview.dart';

class TokenTestPage extends StatefulWidget {
  const TokenTestPage({super.key});

  @override
  State<TokenTestPage> createState() => _TokenTestPageState();
}

class _TokenTestPageState extends State<TokenTestPage> {
  String? dataUrl;

  @override
  void initState() {
    super.initState();
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    final html = await rootBundle.loadString('assets/test_token.html');
    final uri = Uri.dataFromString(
      html,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );
    setState(() {
      dataUrl = uri.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Token测试页面'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: dataUrl == null
          ? const Center(child: CircularProgressIndicator())
          : BridgeWebViewWidget(
              initialUrl: dataUrl!,
            ),
    );
  }
}
