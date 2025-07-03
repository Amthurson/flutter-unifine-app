import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  final String title;
  final bool showBack;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const NavigationBarWidget({
    Key? key,
    required this.title,
    this.showBack = true,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  State<NavigationBarWidget> createState() => NavigationBarWidgetState();
}

class NavigationBarWidgetState extends State<NavigationBarWidget> {
  late String _title;
  late bool _showBack;
  Color? _backgroundColor;
  Color? _foregroundColor;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _showBack = widget.showBack;
    _backgroundColor = widget.backgroundColor;
    _foregroundColor = widget.foregroundColor;
  }

  // 提供方法供JSSDK调用
  void updateNavigation({
    String? title,
    bool? showBack,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    setState(() {
      if (title != null) _title = title;
      if (showBack != null) _showBack = showBack;
      if (backgroundColor != null) _backgroundColor = backgroundColor;
      if (foregroundColor != null) _foregroundColor = foregroundColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title, style: TextStyle(color: _foregroundColor)),
      backgroundColor: _backgroundColor,
      automaticallyImplyLeading: _showBack,
      elevation: 0,
    );
  }
}
