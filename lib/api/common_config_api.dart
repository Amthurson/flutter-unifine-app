import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_front_end/config/env_config.dart';

class CommonConfig {
  // 首页平台选择
  static final String workbenchSelectUrl =
      "${EnvConfig.baseUrl}cloudApp/selectSys/index";
  static final String homeMenuWorkbenchSelectUrl =
      "${EnvConfig.baseUrl}cloudApp/selectSys/mineServer";
  static final String registerUrl =
      "${EnvConfig.baseUrl}cloudApp/register/index";
  static final String privacyUrl = "${EnvConfig.baseUrl}cloudApp/privacy/index";

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
