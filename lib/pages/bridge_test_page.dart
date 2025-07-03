import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../widgets/bridge_webview.dart';

class BridgeTestPage extends StatefulWidget {
  const BridgeTestPage({super.key});

  @override
  State<BridgeTestPage> createState() => _BridgeTestPageState();
}

class _BridgeTestPageState extends State<BridgeTestPage> {
  String? dataUrl;

  @override
  void initState() {
    super.initState();
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    final html = await rootBundle.loadString('assets/test_unified.html');
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
        title: const Text('Bridge测试页面'),
        backgroundColor: Colors.blue,
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
