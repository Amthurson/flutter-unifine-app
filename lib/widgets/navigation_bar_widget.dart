import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/font_size_provider.dart';

class NavigationBarWidget extends StatefulWidget {
  final String title;
  final bool showBack;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? itemColor;
  final String? backgroundImage;
  final void Function(BuildContext context)? onBack;
  final void Function(BuildContext context)? onHome;
  final void Function(BuildContext context)? onMore;
  final void Function(BuildContext context)? onScan;
  final void Function(BuildContext context)? onMessage;

  const NavigationBarWidget({
    super.key,
    required this.title,
    this.showBack = true,
    this.backgroundColor,
    this.titleColor,
    this.itemColor,
    this.backgroundImage,
    this.onBack,
    this.onHome,
    this.onMore,
    this.onScan,
    this.onMessage,
  });

  @override
  State<NavigationBarWidget> createState() => NavigationBarWidgetState();
}

class NavigationBarWidgetState extends State<NavigationBarWidget> {
  late String _title;
  late bool _showBack;
  Color? _backgroundColor;
  Color? _titleColor;
  Color? _itemColor;
  String? _backgroundImage;
  bool _canGoBack = false; // 新增：WebView 是否可以返回

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _showBack = widget.showBack;
    _backgroundColor = widget.backgroundColor;
    _titleColor = widget.titleColor;
    _itemColor = widget.itemColor;
    _backgroundImage = widget.backgroundImage;

    // 初始化时检查 WebView 历史状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWebViewHistory();
    });
  }

  // 新增：检查 WebView 历史状态
  Future<void> _checkWebViewHistory() async {
    try {
      final webViewController = context.read<WebViewController>();
      final canGoBack = await webViewController.canGoBack();
      if (mounted && _canGoBack != canGoBack) {
        setState(() {
          _canGoBack = canGoBack;
        });
      }
    } catch (e) {
      // WebViewController 可能不存在，忽略错误
      print('NavigationBarWidget: 无法获取 WebView 历史状态: $e');
    }
  }

  // 新增：更新 WebView 历史状态的方法，供外部调用
  void updateWebViewHistory(bool canGoBack) {
    if (mounted && _canGoBack != canGoBack) {
      setState(() {
        _canGoBack = canGoBack;
      });
    }
  }

  // 提供方法供JSSDK调用
  void updateNavigation({
    String? title,
    bool? showBack,
    Color? backgroundColor,
    Color? titleColor,
    Color? itemColor,
    String? backgroundImage,
  }) {
    setState(() {
      if (title != null) _title = title;
      if (showBack != null) _showBack = showBack;
      if (backgroundColor != null) _backgroundColor = backgroundColor;
      if (titleColor != null) _titleColor = titleColor;
      if (itemColor != null) _itemColor = itemColor;
      if (backgroundImage != null) _backgroundImage = backgroundImage;
    });
  }

  void _onBackPressed() async {
    // 先执行返回操作
    widget.onBack?.call(context);

    // 返回操作后检查历史状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWebViewHistory();
    });
  }

  void _onMorePressed() {
    widget.onMore?.call(context);
  }

  void _onHomePressed() {
    widget.onHome?.call(context);
  }

  void _onScanPressed() {
    widget.onScan?.call(context);
  }

  void _onMessagePressed() {
    widget.onMessage?.call(context);
  }

  // 修改：将 Future<bool> 改为同步的 bool 计算属性
  bool get _shouldShowBack {
    return _showBack && _canGoBack;
  }

  bool isNetworkUrl(String? url) {
    return url != null &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  void resetNavigation() {
    setState(() {
      _title = widget.title;
      _showBack = widget.showBack;
      _backgroundColor = widget.backgroundColor;
      _titleColor = widget.titleColor;
      _itemColor = widget.itemColor;
      _backgroundImage = widget.backgroundImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontScale = Provider.of<FontSizeProvider>(context).fontScale;
    double iconScale = (0.95 + 0.05 * fontScale).clamp(0.9, 1.1);
    final double iconSize = 22.0 * iconScale;
    final double backIconSize = 16.0 * iconScale;
    final double iconPadding = 0.5 * iconScale;
    const double appBarHeight = kToolbarHeight;
    final Color iconColor = _itemColor ?? Colors.black87;
    final Color titleColor = _titleColor ?? Colors.black87;

    return SizedBox(
      height: appBarHeight + MediaQuery.of(context).padding.top,
      child: Stack(
        children: [
          // 背景图/色，延伸到最顶部
          Positioned.fill(
            child: _backgroundImage != null && _backgroundImage!.isNotEmpty
                ? Image(
                    image: isNetworkUrl(_backgroundImage!)
                        ? NetworkImage(_backgroundImage!)
                        : AssetImage(_backgroundImage!) as ImageProvider,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: _backgroundColor ?? Colors.white,
                  ),
          ),
          // 内容，SafeArea保证不被状态栏遮挡
          SafeArea(
            bottom: false,
            child: SizedBox(
              height: appBarHeight,
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 0,
                    children: [
                      if (_shouldShowBack)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: iconPadding),
                          child: IconButton(
                            icon: Image.asset(
                                'assets/images/drawable-xxxhdpi/icon_title_back.png',
                                width: backIconSize,
                                height: backIconSize,
                                color: iconColor),
                            onPressed: _onBackPressed,
                            splashRadius: backIconSize,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                                minWidth: backIconSize + iconPadding,
                                minHeight: backIconSize + iconPadding),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: iconPadding),
                        child: IconButton(
                          icon: Image.asset(
                              'assets/images/drawable-xxxhdpi/icon_home_setting.png',
                              width: iconSize,
                              height: iconSize,
                              color: iconColor),
                          onPressed: _onMorePressed,
                          splashRadius: iconSize,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                              minWidth: iconSize + iconPadding,
                              minHeight: iconSize + iconPadding),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: iconPadding),
                        child: IconButton(
                          icon: Image.asset(
                              'assets/images/drawable-xhdpi/home.png',
                              width: iconSize,
                              height: iconSize,
                              color: iconColor),
                          onPressed: _onHomePressed,
                          splashRadius: iconSize,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                              minWidth: iconSize + iconPadding,
                              minHeight: iconSize + iconPadding),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _title,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18 * fontScale,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: iconPadding),
                        child: IconButton(
                          icon: Image.asset(
                              'assets/images/drawable-xxxhdpi/icon_scan_white.png',
                              width: iconSize,
                              height: iconSize,
                              color: iconColor),
                          onPressed: _onScanPressed,
                          splashRadius: iconSize,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                              minWidth: iconSize + iconPadding,
                              minHeight: iconSize + iconPadding),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: iconPadding),
                        child: IconButton(
                          icon: Image.asset(
                              'assets/images/drawable-xxxhdpi/icon_inform.png',
                              width: iconSize,
                              height: iconSize,
                              color: iconColor),
                          onPressed: _onMessagePressed,
                          splashRadius: iconSize,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                              minWidth: iconSize + iconPadding,
                              minHeight: iconSize + iconPadding),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
