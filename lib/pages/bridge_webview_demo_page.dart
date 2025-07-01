import 'package:flutter/material.dart';
import 'package:unified_front_end/services/user_service.dart';
import '../widgets/bridge_webview.dart';

/// Bridge WebView演示页面
class BridgeWebViewDemoPage extends StatelessWidget {
  const BridgeWebViewDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bridge WebView 演示'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '选择要测试的WebView页面：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 测试页面按钮
            ElevatedButton(
              onPressed: () => _openTestPage(context, '本地测试页面'),
              child: const Text('打开本地测试页面'),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _openTestPage(context, '远程测试页面'),
              child: const Text('打开远程测试页面'),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _openTestPage(context, '主页'),
              child: const Text('打开主页'),
            ),
            const SizedBox(height: 20),

            const Text(
              'Bridge功能说明：',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureItem(
                      title: '基础功能',
                      items: [
                        'setPortrait - 设置竖屏',
                        'setLandscape - 设置横屏',
                        'getToken - 获取用户Token',
                        'openLink - 打开外部链接',
                        'showFloat - 显示悬浮窗',
                        'preRefresh - 页面刷新',
                        'setNavigation - 设置导航栏',
                      ],
                    ),
                    SizedBox(height: 16),
                    _FeatureItem(
                      title: '权限管理',
                      items: [
                        'getCameraAuth - 相机权限',
                        'getLocationAuth - 位置权限',
                        'getMicrophoneAuth - 麦克风权限',
                        'getCalendarsAuth - 日历权限',
                        'getStorageAuth - 存储权限',
                        'getBluetoothAuth - 蓝牙权限',
                        'getAddressBook - 通讯录权限',
                      ],
                    ),
                    SizedBox(height: 16),
                    _FeatureItem(
                      title: '用户信息',
                      items: [
                        'getUserInfo - 获取用户信息',
                        'getSessionStorage - 获取会话存储',
                        'autoLogin - 自动登录',
                        'reStartLogin - 重新登录',
                      ],
                    ),
                    SizedBox(height: 16),
                    _FeatureItem(
                      title: '设备信息',
                      items: [
                        'getDeviceInfo - 获取设备信息',
                        'getMobileDeviceInformation - 获取移动设备信息',
                      ],
                    ),
                    SizedBox(height: 16),
                    _FeatureItem(
                      title: '网络功能',
                      items: [
                        'getNetworkConnectType - 获取网络连接类型',
                      ],
                    ),
                    SizedBox(height: 16),
                    _FeatureItem(
                      title: '数据存储',
                      items: [
                        'saveH5Data - 保存H5数据',
                        'getH5Data - 获取H5数据',
                      ],
                    ),
                    SizedBox(height: 16),
                    _FeatureItem(
                      title: '系统功能',
                      items: [
                        'setCanInterceptBackKey - 设置拦截返回键',
                        'checkAppVersion - 检查应用版本',
                        'deleteAccount - 删除账号',
                        'uploadLogFile - 上传日志文件',
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 打开测试页面
  Future<void> _openTestPage(BuildContext context, String type) async {
    String url;
    String title;
    bool isHome = false;

    switch (type) {
      case '本地测试页面':
        url = 'data:text/html,${Uri.encodeComponent(_getLocalTestHtml())}';
        title = '本地测试页面';
        break;
      case '远程测试页面':
        url = 'https://httpbin.org/html';
        title = '远程测试页面';
        break;
      case '主页':
        final homeUrlInfo = await UserService.getHomeUrlInfo();
        url = homeUrlInfo?.indexUrl ?? '';
        title = '主页';
        isHome = true;
        break;
      default:
        url = 'https://www.google.com';
        title = '默认页面';
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BridgeWebViewPage(
          url: url,
          title: title,
          isHome: isHome,
        ),
      ),
    );
  }

  /// 获取本地测试HTML
  String _getLocalTestHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bridge WebView 测试页面</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .button { background: #007bff; color: white; border: none; padding: 10px 20px; margin: 5px; border-radius: 4px; cursor: pointer; }
        .result { background: #f8f9fa; border: 1px solid #dee2e6; padding: 10px; margin: 10px 0; white-space: pre-wrap; }
    </style>
</head>
<body>
    <h1>Bridge WebView 测试页面</h1>
    <button class="button" onclick="testGetToken()">获取Token</button>
    <button class="button" onclick="testGetUserInfo()">获取用户信息</button>
    <button class="button" onclick="testGetDeviceInfo()">获取设备信息</button>
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
                    showResult('获取Token结果: ' + JSON.stringify(response, null, 2));
                });
            } else {
                showResult('getToken方法不可用');
            }
        }

        function testGetUserInfo() {
            if (window.getUserInfo) {
                window.getUserInfo(function(response) {
                    showResult('获取用户信息结果: ' + JSON.stringify(response, null, 2));
                });
            } else {
                showResult('getUserInfo方法不可用');
            }
        }

        function testGetDeviceInfo() {
            if (window.getDeviceInfo) {
                window.getDeviceInfo(function(response) {
                    showResult('获取设备信息结果: ' + JSON.stringify(response, null, 2));
                });
            } else {
                showResult('getDeviceInfo方法不可用');
            }
        }
    </script>
</body>
</html>
    ''';
  }
}

/// 功能项组件
class _FeatureItem extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FeatureItem({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(
                '• $item',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )),
      ],
    );
  }
}
