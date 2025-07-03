import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 应用启动服务类
class AppLauncherService {
  static final AppLauncherService _instance = AppLauncherService._internal();
  factory AppLauncherService() => _instance;
  AppLauncherService._internal();

  /// 检查应用是否已安装
  Future<bool> isAppInstalled(String packageName) async {
    try {
      if (Platform.isAndroid) {
        // 在Android上检查应用是否安装
        final uri = Uri.parse('package:$packageName');
        return await canLaunchUrl(uri);
      } else if (Platform.isIOS) {
        // 在iOS上检查应用是否安装
        final uri = Uri.parse('$packageName://');
        return await canLaunchUrl(uri);
      }
      return false;
    } catch (e) {
      print('检查应用安装状态失败: $e');
      return false;
    }
  }

  /// 启动应用
  Future<bool> launchApp(String packageName) async {
    try {
      if (Platform.isAndroid) {
        // 在Android上启动应用
        final uri = Uri.parse('package:$packageName');
        if (await canLaunchUrl(uri)) {
          return await launchUrl(uri);
        }
      } else if (Platform.isIOS) {
        // 在iOS上启动应用
        final uri = Uri.parse('$packageName://');
        if (await canLaunchUrl(uri)) {
          return await launchUrl(uri);
        }
      }
      return false;
    } catch (e) {
      print('启动应用失败: $e');
      return false;
    }
  }

  /// 获取当前应用信息
  Future<Map<String, dynamic>> getCurrentAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return {
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      };
    } catch (e) {
      print('获取应用信息失败: $e');
      return {};
    }
  }

  /// 打开应用商店
  Future<bool> openAppStore(String packageName) async {
    try {
      Uri uri;
      if (Platform.isAndroid) {
        // Google Play Store
        uri = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');
      } else if (Platform.isIOS) {
        // App Store
        uri = Uri.parse('https://apps.apple.com/app/id$packageName');
      } else {
        return false;
      }

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      print('打开应用商店失败: $e');
      return false;
    }
  }
}
