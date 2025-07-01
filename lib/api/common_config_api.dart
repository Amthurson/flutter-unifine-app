import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CommonConfig {
  // 首页平台选择
  static const String workbenchSelectUrl =
      "http://你的后端地址/cloudApp/selectSys/index";
  static const String homeMenuWorkbenchSelectUrl =
      "http://你的后端地址/cloudApp/selectSys/mineServer";
  static const String registerUrl = "http://你的后端地址/cloudApp/register/index";
  static const String privacyUrl = "http://你的后端地址/cloudApp/privacy/index";

  static const String homeUrlInfoKey = "home_url_info";

  // 保存 homeUrlInfo
  static Future<void> saveHomeUrlInfo(Map<String, dynamic> entity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(homeUrlInfoKey, jsonEncode(entity));
  }

  // 获取 homeUrlInfo
  static Future<Map<String, dynamic>?> getHomeUrlInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(homeUrlInfoKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    return jsonDecode(jsonStr);
  }
}
