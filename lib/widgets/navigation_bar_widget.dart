import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  final String title;
  final bool showBack;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? itemColor;
  final String? backgroundImage;

  const NavigationBarWidget({
    super.key,
    required this.title,
    this.showBack = true,
    this.backgroundColor,
    this.titleColor,
    this.itemColor,
    this.backgroundImage,
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

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _showBack = widget.showBack;
    _backgroundColor = widget.backgroundColor;
    _titleColor = widget.titleColor;
    _itemColor = widget.itemColor;
    _backgroundImage = widget.backgroundImage;
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

  void _onBackPressed() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).maybePop();
    } else {
      // 可自定义其它返回逻辑
    }
  }

  void _onMorePressed() {
    Scaffold.of(context).openDrawer();
  }

  void _onHomePressed() {
    // TODO: 跳转到主页，需根据实际路由实现
    // Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onScanPressed() {
    // TODO: 打开扫码页，需根据实际路由实现
    // Navigator.of(context).pushNamed('/scan');
  }

  void _onMessagePressed() {
    // TODO: 跳转消息列表，需根据实际路由实现
    // Navigator.of(context).pushNamed('/messages');
  }

  bool get _shouldShowBack {
    // TODO: 服务窗页面不显示返回按钮，需补充实际判断
    return _showBack && Navigator.of(context).canPop();
  }

  bool isNetworkUrl(String? url) {
    return url != null &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 24;
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
                  if (_shouldShowBack)
                    IconButton(
                      icon: Image.asset(
                          'assets/images/drawable-xxxhdpi/icon_title_back.png',
                          width: iconSize,
                          height: iconSize,
                          color: iconColor),
                      onPressed: _onBackPressed,
                      splashRadius: 20,
                    ),
                  IconButton(
                    icon: Image.asset(
                        'assets/images/drawable-xxxhdpi/icon_home_setting.png',
                        width: iconSize,
                        height: iconSize,
                        color: iconColor),
                    onPressed: _onMorePressed,
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: Image.asset('assets/images/drawable-xhdpi/home.png',
                        width: iconSize, height: iconSize, color: iconColor),
                    onPressed: _onHomePressed,
                    splashRadius: 20,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _title,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                        'assets/images/drawable-xxxhdpi/icon_scan_white.png',
                        width: iconSize,
                        height: iconSize,
                        color: iconColor),
                    onPressed: _onScanPressed,
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: Image.asset(
                        'assets/images/drawable-xxxhdpi/icon_inform.png',
                        width: iconSize,
                        height: iconSize,
                        color: iconColor),
                    onPressed: _onMessagePressed,
                    splashRadius: 20,
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
