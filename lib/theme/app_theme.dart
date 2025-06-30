import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0000FE); // 品牌蓝色
  static const Color backgroundColor = Color(0xFFF5F7FA); // 浅灰背景
  static const Color textColor = Color(0xFF222B45); // 主文字色
  static const Color subTextColor = Color(0xFF8F9BB3); // 次要文字色
  static const Color dividerColor = Color(0xFFE4E9F2); // 分割线
  static const Color buttonColor = primaryColor;
  static const Color buttonTextColor = Colors.white;
  static const Color inputFillColor = Colors.white;
  static const Color inputBorderColor = Color(0xFFE4E9F2);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Roboto', // 如需自定义字体可修改
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textColor),
        bodyMedium: TextStyle(fontSize: 14, color: subTextColor),
        labelLarge: TextStyle(
          fontSize: 16,
          color: buttonTextColor,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(fontSize: 16, color: textColor),
        titleSmall: TextStyle(fontSize: 14, color: subTextColor),
        bodySmall: TextStyle(fontSize: 12, color: subTextColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: TextStyle(color: Color(0xFFBFC5D2), fontSize: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: buttonTextColor,
          disabledBackgroundColor: Color(0xFFBFC5D2),
          disabledForegroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      dividerColor: dividerColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
