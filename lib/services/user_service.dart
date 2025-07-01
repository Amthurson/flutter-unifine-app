import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_url_info.dart';

class UserService {
  static const String _userInfoKey = 'user_info';
  static const String _homeUrlInfoKey = 'homeUrlInfo';

  /// 保存用户信息
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userInfoKey, jsonEncode(userInfo));
  }

  /// 获取用户信息
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_userInfoKey);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr);
  }

  /// 获取token
  static Future<String?> getToken() async {
    final userInfo = await getUserInfo();
    return userInfo?['token'];
  }

  /// 清除用户信息
  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userInfoKey);
  }

  /// 保存主页URL信息
  static Future<void> saveHomeUrlInfo(HomeUrlInfo homeUrlInfo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_homeUrlInfoKey, jsonEncode(homeUrlInfo.toJson()));
  }

  /// 获取主页URL信息
  static Future<HomeUrlInfo?> getHomeUrlInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_homeUrlInfoKey);
    if (str == null) return null;
    return HomeUrlInfo.fromJson(jsonDecode(str));
  }

  /// 清除主页URL信息
  static Future<void> clearHomeUrlInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_homeUrlInfoKey);
  }

  // ==================== 新增方法 ====================

  /// 退出登录
  static Future<void> logout() async {
    await clearUserInfo();
    await clearHomeUrlInfo();
  }

  /// 清除缓存
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// 选择移动联系人
  static Future<List<Map<String, dynamic>>> chooseMobileContacts() async {
    // 模拟选择联系人
    return [
      {
        'name': '张三',
        'phone': '13800138000',
      },
      {
        'name': '李四',
        'phone': '13800138001',
      },
    ];
  }

  /// 保存移动联系人
  static Future<bool> saveMobileContacts() async {
    // 模拟保存联系人
    return true;
  }

  /// 启动应用
  static Future<bool> launchApp() async {
    // 模拟启动应用
    return true;
  }

  /// 检查蓝牙是否启用
  static Future<bool> checkBtEnable() async {
    // 模拟检查蓝牙状态
    return true;
  }

  /// 获取蓝牙设备列表
  static Future<List<Map<String, dynamic>>> getBtDeviceList() async {
    // 模拟获取蓝牙设备列表
    return [
      {
        'name': '蓝牙设备1',
        'address': '00:11:22:33:44:55',
      },
      {
        'name': '蓝牙设备2',
        'address': '00:11:22:33:44:66',
      },
    ];
  }

  /// 连接到蓝牙设备
  static Future<bool> connectToBtDevice() async {
    // 模拟连接蓝牙设备
    return true;
  }

  /// 断开蓝牙设备连接
  static Future<bool> disconnectBtDevice() async {
    // 模拟断开蓝牙设备连接
    return true;
  }
}
