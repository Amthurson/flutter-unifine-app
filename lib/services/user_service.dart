import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_url_info.dart';

class UserService {
  static const String _userInfoKey = 'user_info';
  static const String _homeUrlInfoKey = 'homeUrlInfo';

  /// 保存用户信息
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(userInfo);
    await prefs.setString(_userInfoKey, jsonStr);
    print('UserService.saveUserInfo: 保存用户信息成功，token: ${userInfo['token']}');
  }

  /// 获取用户信息
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_userInfoKey);
    if (jsonStr == null) {
      print('UserService.getUserInfo: 本地没有用户信息');
      return null;
    }
    try {
      final userInfo = jsonDecode(jsonStr);
      print('UserService.getUserInfo: 获取到用户信息，token: ${userInfo['token']}');
      return userInfo;
    } catch (e) {
      print('UserService.getUserInfo: 解析用户信息失败: $e');
      return null;
    }
  }

  /// 获取token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // 首先尝试从user_info中获取token
    final userInfoStr = prefs.getString(_userInfoKey);
    if (userInfoStr != null) {
      try {
        final userInfo = jsonDecode(userInfoStr);
        return userInfo['token'] as String?;
      } catch (e) {
        print('解析用户信息失败: $e');
      }
    }
    // 如果user_info中没有，尝试从单独的token键获取
    return prefs.getString('token');
  }

  /// 清除用户信息
  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userInfoKey);
    await prefs.remove('token'); // 确保单独的token字段也被清理
    await prefs.remove('user'); // 如果有user字段也清理
    await prefs.remove('refreshToken'); // 如果有refreshToken字段也清理
    print('UserService.clearUserInfo: 已清理所有用户相关缓存');
  }

  /// 保存主页URL信息
  static Future<void> saveHomeUrlInfo(HomeUrlInfo homeUrlInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_homeUrlInfoKey, jsonEncode(homeUrlInfo.toJson()));
    print('UserService.saveHomeUrlInfo: 保存主页URL信息成功: ${homeUrlInfo.toJson()}');
  }

  /// 获取主页URL信息
  static Future<HomeUrlInfo?> getHomeUrlInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_homeUrlInfoKey);
    print('UserService.getHomeUrlInfo: 从SharedPreferences获取的原始数据: $str');
    if (str == null) {
      print('UserService.getHomeUrlInfo: 没有找到保存的主页URL信息');
      return null;
    }
    try {
      final homeUrlInfo = HomeUrlInfo.fromJson(jsonDecode(str));
      print('UserService.getHomeUrlInfo: 成功解析主页URL信息: ${homeUrlInfo.toJson()}');
      return homeUrlInfo;
    } catch (e) {
      print('UserService.getHomeUrlInfo: 解析主页URL信息失败: $e');
      return null;
    }
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
