import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unified_front_end/api/cloud_api.dart';
import 'package:unified_front_end/models/home_url_info.dart';
import 'package:unified_front_end/services/user_service.dart';
import '../providers/user_provider.dart';

/// 导航工具类
/// 对应Android项目中的MainJumpUtils
class NavigationUtils {
  /// 登录后跳转至主页面
  /// 对应Android项目中的MainJumpUtils.jumpMainBridgeActivity方法
  static Future<void> jumpMainBridgeActivity(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    print(
        'NavigationUtils.jumpMainBridgeActivity: 用户信息: ${userProvider.homeUrlInfo}');
    // 检查是否有主页URL信息
    if (userProvider.hasHomeUrlInfo) {
      // 有主页URL信息，跳转到广告页
      final homeUrlInfo = userProvider.homeUrlInfo!;
      final windowsConfig =
          await CloudApi.getWindowsConfig(homeUrlInfo.windowsId);
      // merge 一下当前的homeUrlInfo和windowsConfig
      final newHomeUrlInfo = HomeUrlInfo.fromJson(
        {
          ...homeUrlInfo.toJson(),
          ...windowsConfig,
        },
      );
      // 保存windowsConfig
      await UserService.saveHomeUrlInfo(newHomeUrlInfo);
      context.go('/launch-advert', extra: newHomeUrlInfo);
    } else {
      // 没有主页URL信息，跳转到平台选择页
      context.go('/platform-select');
      // context.go('/token-test');
    }
  }

  /// 跳转到H5页面
  /// 对应Android项目中的MainJumpUtils.jumpToBridgeActivity方法
  static void jumpToBridgeActivity(
    BuildContext context, {
    String? title,
    required String url,
    bool isHome = false,
    bool hiddenTitle = false,
    bool showClose = true,
  }) {
    context.go('/web-home', extra: {
      'title': title,
      'url': url,
      'isHome': isHome,
      'hiddenTitle': hiddenTitle,
      'showClose': showClose,
    });
  }

  /// 跳转到H5页面（应用登录）
  /// 对应Android项目中的MainJumpUtils.jumpToBridgeActivityAppLogin方法
  static void jumpToBridgeActivityAppLogin(
    BuildContext context, {
    String? title,
    required String url,
    bool isHome = false,
    bool hiddenTitle = false,
  }) {
    context.go('/web-home', extra: {
      'title': title,
      'url': url,
      'isHome': isHome,
      'hiddenTitle': hiddenTitle,
      'showClose': true,
      'redirect': true,
    });
  }

  /// 跳转到H5页面（业务页面）
  /// 对应Android项目中的MainJumpUtils.jumpToBridgeActivityBusiness方法
  static void jumpToBridgeActivityBusiness(
    BuildContext context, {
    String? title,
    required String url,
    bool isHome = false,
    bool hiddenTitle = false,
  }) {
    context.go('/web-home', extra: {
      'title': title,
      'url': url,
      'isHome': isHome,
      'hiddenTitle': hiddenTitle,
      'showClose': true,
      'system': false,
    });
  }

  /// 跳转到平台选择页
  /// 对应Android项目中的平台选择功能
  static void jumpToPlatformSelect(BuildContext context) {
    context.go('/platform-select');
  }

  /// 跳转到登录页
  /// 对应Android项目中的MainJumpUtils.jumpToLoginActivity方法
  static void jumpToLoginActivity(BuildContext context) {
    context.go('/verification-login');
  }

  /// 退出登录
  /// 对应Android项目中的MainJumpUtils.logout方法
  static Future<void> logout(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.logout();

    if (context.mounted) {
      // 清除所有页面栈，跳转到登录页
      context.go('/verification-login');
    }
  }

  /// 跳转到主页
  /// 对应Android项目中的MainJumpUtils.jumpMain方法
  static void jumpMain(BuildContext context) {
    context.go('/home');
  }

  /// 检查并跳转到合适的页面
  /// 根据用户状态和主页URL信息决定跳转目标
  static void checkAndNavigate(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    if (!userProvider.isLoggedIn) {
      // 未登录，跳转到登录页
      jumpToLoginActivity(context);
    } else if (userProvider.hasHomeUrlInfo) {
      // 已登录且有主页URL信息，跳转到广告页
      final homeUrlInfo = userProvider.homeUrlInfo!;
      context.go('/launch-advert', extra: homeUrlInfo);
    } else {
      // 已登录但没有主页URL信息，跳转到平台选择页
      jumpToPlatformSelect(context);
    }
  }
}
