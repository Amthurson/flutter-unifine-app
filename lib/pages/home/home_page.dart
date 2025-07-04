import 'package:flutter/material.dart';
import '../../widgets/compatible_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../widgets/navigation_bar_widget.dart';
import 'package:unified_front_end/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigationBarWidgetState> _navKey = navKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavigationBarWidget(
            key: _navKey,
            title: '主页',
            showBack: false,
            backgroundColor: Colors.white,
            itemColor: Colors.black,
            titleColor: Colors.black,
          ),
          const Expanded(
            child: CompatibleWebView(
              url: '你的主页url',
              title: '主页',
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageWebView extends StatelessWidget {
  final String title;
  final String url;
  final bool isHome;
  final bool hiddenTitle;
  final bool isFunc;

  const HomePageWebView({
    required this.title,
    required this.url,
    this.isHome = false,
    this.hiddenTitle = false,
    this.isFunc = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hiddenTitle
          ? null
          : AppBar(
              title: Text(title),
              automaticallyImplyLeading: !isHome,
              actions: [
                if (isFunc) const Icon(Icons.extension), // 功能页可自定义icon
              ],
            ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
