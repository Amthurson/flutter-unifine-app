import 'package:flutter/material.dart';
import '../widgets/bridge_webview.dart';

class BridgeDemoPage extends StatelessWidget {
  const BridgeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bridge WebView 演示')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Bridge WebView 功能演示',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openTestPage(context),
              child: const Text('打开测试页面'),
            ),
            const SizedBox(height: 20),
            const Text('支持的功能：'),
            const SizedBox(height: 10),
            const Text('• 获取Token和用户信息'),
            const Text('• 设备信息和网络状态'),
            const Text('• 权限管理（相机、位置等）'),
            const Text('• 数据存储'),
            const Text('• 屏幕方向控制'),
          ],
        ),
      ),
    );
  }

  void _openTestPage(BuildContext context) {
    final testHtml = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bridge 测试</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .btn { background: #007bff; color: white; border: none; padding: 10px 20px; margin: 5px; border-radius: 4px; cursor: pointer; }
        .result { background: #f8f9fa; border: 1px solid #ddd; padding: 10px; margin: 10px 0; white-space: pre-wrap; }
    </style>
</head>
<body>
    <h1>Bridge WebView 测试</h1>
    <button class="btn" onclick="testGetToken()">获取Token</button>
    <button class="btn" onclick="testGetUserInfo()">获取用户信息</button>
    <button class="btn" onclick="testGetDeviceInfo()">获取设备信息</button>
    <button class="btn" onclick="testNetworkType()">获取网络类型</button>
    <div id="result" class="result">等待测试...</div>

    <script>
        document.addEventListener('FlutterWebViewJavascriptBridgeReady', function(event) {
            document.getElementById('result').textContent = 'Bridge已初始化完成';
        });

        function showResult(message) {
            document.getElementById('result').textContent = message;
        }

        function testGetToken() {
            if (window.getToken) {
                window.getToken(function(response) {
                    showResult('Token结果: ' + JSON.stringify(response, null, 2));
                });
            } else {
                showResult('getToken方法不可用');
            }
        }

        function testGetUserInfo() {
            if (window.getUserInfo) {
                window.getUserInfo(function(response) {
                    showResult('用户信息: ' + JSON.stringify(response, null, 2));
                });
            } else {
                showResult('getUserInfo方法不可用');
            }
        }

        function testGetDeviceInfo() {
            if (window.getDeviceInfo) {
                window.getDeviceInfo(function(response) {
                    showResult('设备信息: ' + JSON.stringify(response, null, 2));
                });
            } else {
                showResult('getDeviceInfo方法不可用');
            }
        }

        function testNetworkType() {
            if (window.getNetworkConnectType) {
                window.getNetworkConnectType(function(response) {
                    showResult('网络类型: ' + JSON.stringify(response, null, 2));
                });
            } else {
                showResult('getNetworkConnectType方法不可用');
            }
        }
    </script>
</body>
</html>
    ''';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BridgeWebViewPage(
          url: 'data:text/html,${Uri.encodeComponent(testHtml)}',
          title: 'Bridge 测试页面',
        ),
      ),
    );
  }
}
