import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unified_front_end/config/env_config.dart';
import 'package:unified_front_end/models/user.dart';
import 'package:unified_front_end/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'bridge_handler.dart';
import 'package:unified_front_end/services/app_launcher_service.dart';
import 'package:unified_front_end/services/bluetooth_service.dart';
import 'package:unified_front_end/widgets/navigation_bar_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unified_front_end/providers/user_provider.dart';
import 'package:unified_front_end/models/home_url_info.dart';

/// JSSDK处理器管理器
class JSSDKHandlers {
  static final Map<String, BridgeHandler> handlers = {};
  static BuildContext? globalContext;

  /// 初始化所有处理器
  static void initHandlers(
      BuildContext context, GlobalKey<NavigationBarWidgetState> navKey) {
    globalContext = context;
    // 基础功能
    handlers['setPortrait'] = _SetPortraitHandler();
    handlers['setLandscape'] = _SetLandscapeHandler();
    handlers['getToken'] = _GetTokenHandler();
    handlers['saveHomeUrl'] = _SaveHomeUrlHandler();
    handlers['openLink'] = _OpenLinkHandler();
    handlers['showFloat'] = _ShowFloatHandler();
    handlers['preRefresh'] = _PreRefreshHandler();
    handlers['setNavigation'] = _SetNavigationHandler(navKey);

    // 添加简单测试处理器
    handlers['test'] = _TestHandler();

    // 权限相关
    handlers['getCameraAuth'] = _GetCameraAuthHandler();
    handlers['getLocationAuth'] = _GetLocationAuthHandler();
    handlers['getMicrophoneAuth'] = _GetMicrophoneAuthHandler();
    handlers['getCalendarsAuth'] = _GetCalendarsAuthHandler();
    handlers['getStorageAuth'] = _GetStorageAuthHandler();
    handlers['getBluetoothAuth'] = _GetBluetoothAuthHandler();
    handlers['getAddressBook'] = _GetAddressBookHandler();

    // 媒体功能
    handlers['saveImage'] = _SaveImageHandler();
    handlers['showPhotos'] = _ShowPhotosHandler();
    handlers['scanQRCode'] = _ScanQRCodeHandler();
    handlers['scanCodeCard'] = _ScanCodeCardHandler();
    handlers['savePhotoToAlbum'] = _SavePhotoToAlbumHandler();

    // 位置服务
    handlers['getLocation'] = _GetLocationHandler();
    handlers['mapGetLocation'] = _MapGetLocationHandler();
    handlers['navigationto'] = _NavigationToHandler();
    handlers['navigationBackAction'] = _NavigationBackActionHandler();
    handlers['getIsVirtualPositioning'] = _GetIsVirtualPositioningHandler();

    // 会议和通话
    handlers['openMeeting'] = _OpenMeetingHandler();
    handlers['startAudioCall'] = _StartAudioCallHandler();
    handlers['startVideoCall'] = _StartVideoCallHandler();

    // 用户信息
    handlers['getUserInfo'] = _GetUserInfoHandler();
    handlers['getSessionStorage'] = _GetSessionStorageHandler();
    handlers['autoLogin'] = _AutoLoginHandler();
    handlers['reStartLogin'] = _ReStartLoginHandler();

    // 应用管理
    handlers['openNewWebPage'] = _OpenNewWebPageHandler();
    handlers['logout'] = _LogoutHandler();
    handlers['clearCache'] = _ClearCacheHandler();

    // 文件操作
    handlers['fileUpload'] = _FileUploadHandler();
    handlers['fileDownLoadNew'] = _FileDownLoadNewHandler();
    handlers['scanFile'] = _ScanFileHandler();

    // 通讯功能
    handlers['call'] = _CallHandler();
    handlers['startIMChat'] = _StartIMChatHandler();
    handlers['startIMMessageList'] = _StartIMMessageListHandler();

    // 录音和语音
    handlers['startRecord'] = _StartRecordHandler();

    // 设备信息
    handlers['getDeviceInfo'] = _GetDeviceInfoHandler();
    handlers['getMobileDeviceInformation'] =
        _GetMobileDeviceInformationHandler();

    // 人脸识别
    handlers['startFaceCollect'] = _StartFaceCollectHandler();
    handlers['startFaceMatch'] = _StartFaceMatchHandler();

    // 签名功能
    handlers['startSign'] = _StartSignHandler();

    // 数据存储
    handlers['saveH5Data'] = _SaveH5DataHandler();
    handlers['getH5Data'] = _GetH5DataHandler();

    // 系统功能
    handlers['setCanInterceptBackKey'] = _SetCanInterceptBackKeyHandler();
    handlers['checkAppVersion'] = _CheckAppVersionHandler();
    handlers['getNetworkConnectType'] = _GetNetworkConnectTypeHandler();
    handlers['deleteAccount'] = _DeleteAccountHandler();
    handlers['uploadLogFile'] = _UploadLogFileHandler();

    // 视频监控
    handlers['ivmsplayv2'] = _Ivmsplayv2Handler();
    handlers['ivmsplay'] = _IvmsplayHandler();
    handlers['openDaHuaPreVideo'] = _OpenDaHuaPreVideoHandler();

    // 应用启动
    handlers['launchApp'] = _LaunchAppHandler();

    // 蓝牙功能
    handlers['checkBtEnable'] = _CheckBtEnableHandler();
    handlers['getBtDeviceList'] = _GetBtDeviceListHandler();
    handlers['connectToBtDevice'] = _ConnectToBtDeviceHandler();
    handlers['disconnectBtDevice'] = _DisconnectBtDeviceHandler();
  }

  /// 获取所有处理器
  static Map<String, BridgeHandler> getAllHandlers() {
    return handlers;
  }
}

// ==================== 基础功能处理器====================

class _TestHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    print('[Handler] test 被调用 data: $data');
    callback(jsonEncode({
      "status": "success",
      "msg": "测试成功",
      "data": {
        'message': 'Hello from Flutter!',
        'timestamp': DateTime.now().millisecondsSinceEpoch
      }
    }));
  }
}

class _SetPortraitHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _SetLandscapeHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _GetTokenHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    print('[Handler] getToken 被调用 data: $data');
    try {
      final token = await UserService.getToken();
      print('[Handler] getToken 获取到token: $token');
      callback(jsonEncode({
        "status": "success",
        "msg": "成功",
        "data": {'token': token}
      }));
    } catch (e) {
      print('[Handler] getToken 异常: $e');
      callback(
          jsonEncode({"status": "fail", "msg": '获取Token失败: $e', "data": {}}));
    }
  }
}

class _SaveHomeUrlHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      // 兼容 data 可能为 String 或 Map
      final entity = data is String ? jsonDecode(data) : data;
      final indexUrl = entity['indexUrl'] as String?;

      if (indexUrl == null || indexUrl.isEmpty) {
        // 这里可以用 FlutterToast 或其它方式弹提示
        // Fluttertoast.showToast(msg: "暂无数据");
        callback(
            jsonEncode({"status": "fail", "msg": "indexUrl为空", "data": {}}));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('homeUrlInfo', jsonEncode(entity));

      // 更新UserProvider中的homeUrlInfo
      if (JSSDKHandlers.globalContext != null) {
        try {
          final userProvider = Provider.of<UserProvider>(
              JSSDKHandlers.globalContext!,
              listen: false);
          userProvider.cacheCurrentHomeUrlInfo();
          final homeUrlInfo = HomeUrlInfo.fromJson(entity);
          await userProvider.saveHomeUrlInfo(homeUrlInfo);
          print(
              '_SaveHomeUrlHandler: 已更新UserProvider中的homeUrlInfo: ${homeUrlInfo.toJson()}');
        } catch (e) {
          print('_SaveHomeUrlHandler: 更新UserProvider失败: $e');
        }
      }

      // 这里可以实现 selectWindow 逻辑（如有需要）
      // presenter.selectWindow(windowsId ?? "");

      callback(jsonEncode({"status": "success", "msg": "成功", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "保存失败: $e", "data": {}}));
    }
  }
}

class _OpenLinkHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final entity = data is String ? jsonDecode(data) : data;
      final url = entity['url'] as String?;
      final isFunc = entity['isFunc'] as int? ?? 0;
      final title = entity['title'] as String? ?? '';
      final isHome = entity['isHome'] as bool? ?? false;
      final hidden = entity['hidden'] as int? ?? 0;

      if (url == null || url.isEmpty) {
        callback(jsonEncode({"status": "fail", "msg": "暂无数据", "data": {}}));
        return;
      }

      // 使用 go_router 跳转
      GoRouter.of(JSSDKHandlers.globalContext!).push('/web-home', extra: {
        'title': title,
        'url': url,
        'isHome': isHome,
        'hiddenTitle': hidden == 1,
        'isFunc': isFunc == 1,
      });

      callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "打开链接失败: $e", "data": {}}));
    }
  }
}

class _ShowFloatHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _PreRefreshHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _SetNavigationHandler implements BridgeHandler {
  final GlobalKey<NavigationBarWidgetState> navKey;
  _SetNavigationHandler(this.navKey);

  @override
  void call(dynamic data, Function(String) callback) {
    try {
      // 解析data，动态设置导航栏
      final navData = data is String ? jsonDecode(data) : data;

      // 提取导航条样式参数
      final title = navData['title'] as String? ?? '';
      final titleColor = navData['titleColor'] as String? ?? '#000000';
      final backgroundImage = navData['backgroundImage'] as String?;
      final itemColor = navData['itemColor'] as String? ?? '#000000';
      final showBack = navData['showBack'] as bool? ?? true;
      final backgroundColor =
          navData['backgroundColor'] as String? ?? '#ffffff';

      // 更新导航栏
      navKey.currentState?.updateNavigation(
        title: title,
        showBack: showBack,
        backgroundColor: _parseColor(backgroundColor),
        itemColor: _parseColor(itemColor),
        backgroundImage: backgroundImage,
        titleColor: _parseColor(titleColor),
      );

      callback(jsonEncode({
        "status": "success",
        "msg": "导航栏设置成功",
        "data": {
          'title': title,
          'titleColor': titleColor,
          'backgroundImage': backgroundImage,
          'itemColor': itemColor,
          'showBack': showBack
        }
      }));
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "设置导航栏失败: $e", "data": {}}));
    }
  }

  /// 解析颜色字符串为Color对象
  Color _parseColor(String colorStr) {
    if (colorStr.startsWith('#')) {
      // 处理十六进制颜色
      final hex = colorStr.replaceFirst('#', '');
      if (hex.length == 6) {
        final r = int.parse(hex.substring(0, 2), radix: 16);
        final g = int.parse(hex.substring(2, 4), radix: 16);
        final b = int.parse(hex.substring(4, 6), radix: 16);
        return Color.fromARGB(255, r, g, b);
      } else if (hex.length == 8) {
        final a = int.parse(hex.substring(0, 2), radix: 16);
        final r = int.parse(hex.substring(2, 4), radix: 16);
        final g = int.parse(hex.substring(4, 6), radix: 16);
        final b = int.parse(hex.substring(6, 8), radix: 16);
        return Color.fromARGB(a, r, g, b);
      }
    }
    // 默认返回白色
    return Colors.white;
  }
}

// ==================== 权限相关处理器====================

class _GetCameraAuthHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        callback(jsonEncode({"status": "success", "msg": "用户已授权", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "获取用户授权失败", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": '权限请求失败: $e', "data": {}}));
    }
  }
}

class _GetLocationAuthHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        callback(jsonEncode({"status": "success", "msg": "用户已授权", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "获取用户授权失败", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": '权限请求失败: $e', "data": {}}));
    }
  }
}

class _GetMicrophoneAuthHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        callback(jsonEncode({"status": "success", "msg": "用户已授权", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "获取用户授权失败", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": '权限请求失败: $e', "data": {}}));
    }
  }
}

class _GetCalendarsAuthHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final status = await Permission.calendar.request();
      if (status.isGranted) {
        callback(jsonEncode({"status": "success", "msg": "用户已授权", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "获取用户授权失败", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": '权限请求失败: $e', "data": {}}));
    }
  }
}

class _GetStorageAuthHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        callback(jsonEncode({"status": "success", "msg": "用户已授权", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "获取用户授权失败", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": '权限请求失败: $e', "data": {}}));
    }
  }
}

class _GetBluetoothAuthHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final status = await Permission.bluetooth.request();
      if (status.isGranted) {
        callback(jsonEncode({"status": "success", "msg": "用户已授权", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "获取用户授权失败", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": '权限请求失败: $e', "data": {}}));
    }
  }
}

class _GetAddressBookHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        callback(jsonEncode({"status": "success", "msg": "用户已授权", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "获取用户授权失败", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": '权限请求失败: $e', "data": {}}));
    }
  }
}

// ==================== 媒体功能处理器====================

class _SaveImageHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final imageData = data is String ? jsonDecode(data) : data;
      final imageUrl = imageData['url'] as String;

      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/saved_image.jpg');
      await file.writeAsBytes(response.bodyBytes);

      callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": '保存图片失败: $e', "data": {}}));
    }
  }
}

class _ShowPhotosHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _ScanQRCodeHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        const qrContent = "mock_qr_content";
        callback(jsonEncode({
          "status": "success",
          "msg": "",
          "data": {'content': qrContent}
        }));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "扫描取消", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "扫描失败: $e", "data": {}}));
    }
  }
}

class _ScanCodeCardHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        const cardContent = "mock_card_content";
        callback(jsonEncode({
          "status": "success",
          "msg": "",
          "data": {'content': cardContent}
        }));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "扫描取消", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "扫描失败: $e", "data": {}}));
    }
  }
}

class _SavePhotoToAlbumHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final photoData = data is String ? jsonDecode(data) : data;
      final base64Data = photoData['base64data'] as String?;
      final downloadUrl = photoData['downloadurl'] as String?;

      if (base64Data != null) {
        final bytes = base64Decode(base64Data);
        final directory = await getApplicationDocumentsDirectory();
        final file = File(
            '${directory.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(bytes);
      } else if (downloadUrl != null) {
        final response = await http.get(Uri.parse(downloadUrl));
        final directory = await getApplicationDocumentsDirectory();
        final file = File(
            '${directory.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(response.bodyBytes);
      }

      callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "保存图片失败: $e", "data": {}}));
    }
  }
}

// ==================== 位置服务处理器====================

class _GetLocationHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final locationData = {
        'longitude': position.longitude.toString(),
        'latitude': position.latitude.toString(),
        'name': '当前位置',
        'suggestion': '',
        'isVirtualPositioning': 0,
        'message': '',
      };

      callback(
          jsonEncode({"status": "success", "msg": "", "data": locationData}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "获取位置失败: $e", "data": {}}));
    }
  }
}

class _MapGetLocationHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    _GetLocationHandler().call(data, callback);
  }
}

class _NavigationToHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final navData = data is String ? jsonDecode(data) : data;
      final latitude = double.parse(navData['latitude']);
      final longitude = double.parse(navData['longitude']);

      final url = 'https://maps.google.com/maps?q=$latitude,$longitude';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "无法打开地图", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "导航失败: $e", "data": {}}));
    }
  }
}

class _NavigationBackActionHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _GetIsVirtualPositioningHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final isMockLocation = await Geolocator.isLocationServiceEnabled();
      final locationData = {
        'isVirtualPositioning': isMockLocation ? 0 : 1,
        'message': isMockLocation ? '' : '可能为虚拟定位',
      };

      callback(
          jsonEncode({"status": "success", "msg": "", "data": locationData}));
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "检查虚拟定位失败: $e", "data": {}}));
    }
  }
}

// ==================== 用户信息处理器====================

class _GetUserInfoHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      Map<String, dynamic>? userInfoRaw = await UserService.getUserInfo();
      User? userInfo = userInfoRaw != null ? User.fromJson(userInfoRaw) : null;
      if (userInfo != null) {
        callback(jsonEncode(
            {"status": "success", "msg": "成功", "data": userInfo.phone}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "用户未登录", "data": {}}));
      }
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "获取用户信息失败: $e", "data": {}}));
    }
  }
}

class _GetSessionStorageHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      Map<String, dynamic> safeData;
      if (data is Map<String, dynamic>) {
        safeData = data;
      } else if (data is Map) {
        safeData = Map<String, dynamic>.from(data);
      } else {
        safeData = {};
      }

      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic>? userInfoRaw = await UserService.getUserInfo();

      print("userInfoRaw: $userInfoRaw");

      final homeUrlJson = prefs.getString('homeUrlInfo');

      final sessionData = {
        'tokenId': userInfoRaw != null ? userInfoRaw['token'] : '',
        'userId': userInfoRaw != null ? userInfoRaw['userId'] : '',
        'userName': userInfoRaw != null ? userInfoRaw['userName'] : '',
        'mobile': userInfoRaw != null ? userInfoRaw['phone'] : '',
        'eid':
            homeUrlJson != null ? jsonDecode(homeUrlJson)['windowsId'] : null,
        'baseUrl': EnvConfig.baseUrl,
      };

      callback(
          jsonEncode({"status": "success", "msg": "", "data": sessionData}));
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "获取会话存储失败: $e", "data": {}}));
    }
  }
}

class _AutoLoginHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final loginData = data is String ? jsonDecode(data) : data;
      final token = loginData['token'] as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', jsonEncode({'token': token}));

      callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "自动登录失败: $e", "data": {}}));
    }
  }
}

class _ReStartLoginHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = jsonDecode(userJson);
        if (user['refreshToken'] != null) {
          callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
        } else {
          callback(
              jsonEncode({"status": "fail", "msg": "刷新token失败", "data": {}}));
        }
      } else {
        callback(jsonEncode({"status": "fail", "msg": "用户未登录", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "重新登录失败: $e", "data": {}}));
    }
  }
}

// ==================== 设备信息处理器====================

class _GetDeviceInfoHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = '';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }

      final deviceData = {
        'deviceId': deviceId,
        'buildVersionName': '1.0.0',
      };

      callback(
          jsonEncode({"status": "success", "msg": "", "data": deviceData}));
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "获取设备信息失败: $e", "data": {}}));
    }
  }
}

class _GetMobileDeviceInformationHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      Map<String, dynamic> deviceData = {};

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceData = {
          'deviceManufacturer': androidInfo.manufacturer,
          'name': androidInfo.product,
          'model': androidInfo.model,
          'systemVersion': androidInfo.version.release,
          'UUID': androidInfo.id,
          'appVersion': '1.0.0',
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceData = {
          'deviceManufacturer': 'Apple',
          'name': iosInfo.name,
          'model': iosInfo.model,
          'systemVersion': iosInfo.systemVersion,
          'UUID': iosInfo.identifierForVendor ?? '',
          'appVersion': '1.0.0',
        };
      }

      callback(
          jsonEncode({"status": "success", "msg": "", "data": deviceData}));
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "获取移动设备信息失败: $e", "data": {}}));
    }
  }
}

// ==================== 网络功能处理器====================

class _GetNetworkConnectTypeHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      String connectType = 'UNKNOWN';

      switch (connectivityResult) {
        case ConnectivityResult.mobile:
          connectType = 'MOBILE';
          break;
        case ConnectivityResult.wifi:
          connectType = 'WIFI';
          break;
        case ConnectivityResult.ethernet:
          connectType = 'ETHERNET';
          break;
        case ConnectivityResult.none:
          connectType = 'NO';
          break;
        default:
          connectType = 'UNKNOWN';
      }

      final networkData = {'connectType': connectType};
      callback(
          jsonEncode({"status": "success", "msg": "", "data": networkData}));
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "获取网络连接类型失败: $e", "data": {}}));
    }
  }
}

// ==================== 数据存储处理器====================

class _SaveH5DataHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final saveData = data is String ? jsonDecode(data) : data;
      final key = saveData['key'] as String;
      final value = saveData['value'];

      final prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else {
        await prefs.setString(key, jsonEncode(value));
      }

      callback(jsonEncode({"status": "success", "msg": "保存数据成功", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "保存数据失败: $e", "data": {}}));
    }
  }
}

class _GetH5DataHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final getData = data is String ? jsonDecode(data) : data;
      final key = getData['key'] as String;

      final prefs = await SharedPreferences.getInstance();
      final value = prefs.get(key);

      callback(jsonEncode({"status": "success", "msg": "", "data": value}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "获取数据失败: $e", "data": {}}));
    }
  }
}

// ==================== 系统功能处理器====================

class _SetCanInterceptBackKeyHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _CheckAppVersionHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _DeleteAccountHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      await UserService.logout();
      callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "删除账号失败: $e", "data": {}}));
    }
  }
}

class _UploadLogFileHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final logFile =
          File('${(await getApplicationDocumentsDirectory()).path}/log.txt');
      if (await logFile.exists()) {
        callback(jsonEncode({
          "status": "success",
          "msg": "",
          "data": {'fileUrl': 'mock_file_url'}
        }));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "日志文件不存在", "data": {}}));
      }
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "上传日志文件失败: $e", "data": {}}));
    }
  }
}

// ==================== 文件操作处理器====================

class _FileUploadHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final uploadData = jsonDecode(data);
      final maxCount = uploadData['maxCount'] as int? ?? 1;
      final uploadUrl = uploadData['uploadurl'] as String? ?? '';

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: maxCount > 1,
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        final uploadedFiles = result.files.map((file) => file.path).toList();
        callback(jsonEncode(
            {"status": "success", "msg": "", "data": uploadedFiles}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "未选择文件", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "文件上传失败: $e", "data": {}}));
    }
  }
}

class _FileDownLoadNewHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final downloadData = jsonDecode(data);
      final appDownloadUrl = downloadData['appDownloadUrl'] as String;

      if (appDownloadUrl.isNotEmpty) {
        final response = await http.get(Uri.parse(appDownloadUrl));
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'download_${DateTime.now().millisecondsSinceEpoch}';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "下载地址有误", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "文件下载失败: $e", "data": {}}));
    }
  }
}

class _ScanFileHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

// ==================== 通讯功能处理器====================

class _CallHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final callData = data is String ? jsonDecode(data) : data;
      final phone = callData['phone'] as String;

      final uri = Uri.parse('tel:$phone');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "无法拨打电话", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "拨打电话失败: $e", "data": {}}));
    }
  }
}

class _StartIMChatHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _StartIMMessageListHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

// ==================== 录音和语音处理器====================

class _StartRecordHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      const recognizeResult = "mock_recognize_result";
      callback(jsonEncode(
          {"status": "success", "msg": "操作成功", "data": recognizeResult}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "语音识别失败: $e", "data": {}}));
    }
  }
}

// ==================== 人脸识别处理器====================

class _StartFaceCollectHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final faceImageUrl = image.path;
        callback(jsonEncode({
          "status": "success",
          "msg": "",
          "data": {'faceImageUrl': faceImageUrl}
        }));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "人脸采集取消", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "人脸采集失败: $e", "data": {}}));
    }
  }
}

class _StartFaceMatchHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final matchData = jsonDecode(data);
      final faceUrl = matchData['faceUrl'] as String;

      const matchResult = true;
      callback(jsonEncode({
        "status": "success",
        "msg": "",
        "data": {'matchResult': matchResult}
      }));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "人脸匹配失败: $e", "data": {}}));
    }
  }
}

// ==================== 签名功能处理器====================

class _StartSignHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      const signImageBase64 = "mock_sign_image_base64";
      callback(jsonEncode({
        "status": "success",
        "msg": "",
        "data": {'signImageBase64': signImageBase64}
      }));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "签名失败: $e", "data": {}}));
    }
  }
}

// ==================== 会议和通话处理器====================

class _OpenMeetingHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _StartAudioCallHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _StartVideoCallHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _OpenNewWebPageHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final url = data is String ? jsonDecode(data)['url'] : data['url'];
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "无法打开链接", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "打开链接失败: $e", "data": {}}));
    }
  }
}

class _LogoutHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      await UserService.logout();
      callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "退出登录失败: $e", "data": {}}));
    }
  }
}

class _ClearCacheHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      await UserService.clearCache();
      callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "清除缓存失败: $e", "data": {}}));
    }
  }
}

// ==================== 视频监控处理器====================

class _Ivmsplayv2Handler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _IvmsplayHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

class _OpenDaHuaPreVideoHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) {
    callback(jsonEncode({"status": "success", "msg": "", "data": {}}));
  }
}

// ==================== 应用启动处理器====================

class _LaunchAppHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final launchData = data is String ? jsonDecode(data) : data;
      final packageName = launchData['packageName'] as String;

      final appLauncherService = AppLauncherService();
      final isInstalled = await appLauncherService.isAppInstalled(packageName);

      if (isInstalled) {
        final success = await appLauncherService.launchApp(packageName);
        if (success) {
          callback(jsonEncode({"status": "success", "msg": "成功", "data": {}}));
        } else {
          callback(jsonEncode({"status": "fail", "msg": "启动应用失败", "data": {}}));
        }
      } else {
        callback(jsonEncode({"status": "fail", "msg": "应用未安装", "data": {}}));
      }
    } catch (e) {
      callback(jsonEncode({"status": "fail", "msg": "启动应用失败: $e", "data": {}}));
    }
  }
}

// ==================== 蓝牙功能处理器====================

class _CheckBtEnableHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final bluetoothService = BluetoothDeviceManager();
      await bluetoothService.initialize();

      final isSupportBle = await bluetoothService.isSupportBle();
      if (!isSupportBle) {
        callback(
            jsonEncode({"status": "fail", "msg": "该设备不支持蓝牙功能", "data": {}}));
        return;
      }

      final hasPermission = await bluetoothService.checkPermission();
      if (!hasPermission) {
        callback(
            jsonEncode({"status": "fail", "msg": "没有蓝牙使用权限，请先授权", "data": {}}));
        return;
      }

      final isBlueEnable = await bluetoothService.isBlueEnable();
      if (!isBlueEnable) {
        callback(
            jsonEncode({"status": "fail", "msg": "蓝牙未开启，请先开启蓝牙", "data": {}}));
        return;
      }

      callback(jsonEncode(
          {"status": "success", "msg": "蓝牙已开启，可以执行后续操作", "data": {}}));
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "检查蓝牙状态失败: $e", "data": {}}));
    }
  }
}

class _GetBtDeviceListHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final bluetoothService = BluetoothDeviceManager();
      await bluetoothService.initialize();

      final isSupportBle = await bluetoothService.isSupportBle();
      if (!isSupportBle) {
        callback(
            jsonEncode({"status": "fail", "msg": "该设备不支持蓝牙功能", "data": {}}));
        return;
      }

      final hasPermission = await bluetoothService.checkPermission();
      if (!hasPermission) {
        callback(
            jsonEncode({"status": "fail", "msg": "没有蓝牙使用权限，请先授权", "data": {}}));
        return;
      }

      final isBlueEnable = await bluetoothService.isBlueEnable();
      if (!isBlueEnable) {
        callback(
            jsonEncode({"status": "fail", "msg": "蓝牙未开启，请先开启蓝牙", "data": {}}));
        return;
      }

      final devices = await bluetoothService.scanDevices();
      callback(jsonEncode({
        "status": "success",
        "msg": "",
        "data": {'devices': devices}
      }));
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "获取蓝牙设备列表失败: $e", "data": {}}));
    }
  }
}

class _ConnectToBtDeviceHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final connectData = data is String ? jsonDecode(data) : data;
      final identifier = connectData['identifier'] as String;
      final serviceUUID = connectData['serviceUUID'] as String;
      final characterUUID = connectData['characterUUID'] as String;

      if (identifier.isEmpty) {
        callback(
            jsonEncode({"status": "fail", "msg": "mac地址不能为空", "data": {}}));
        return;
      }

      if (serviceUUID.isEmpty) {
        callback(jsonEncode(
            {"status": "fail", "msg": "serviceUUID不能为空", "data": {}}));
        return;
      }

      if (characterUUID.isEmpty) {
        callback(jsonEncode(
            {"status": "fail", "msg": "characterUUID不能为空", "data": {}}));
        return;
      }

      final bluetoothService = BluetoothDeviceManager();
      final success = await bluetoothService.connectToDevice(
        identifier: identifier,
        serviceUUID: serviceUUID,
        characterUUID: characterUUID,
      );

      if (success) {
        callback(jsonEncode({"status": "success", "msg": "蓝牙已连接", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "连接失败", "data": {}}));
      }
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "连接蓝牙设备失败: $e", "data": {}}));
    }
  }
}

class _DisconnectBtDeviceHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final disconnectData = data is String ? jsonDecode(data) : data;
      final identifier = disconnectData['identifier'] as String;

      if (identifier.isEmpty) {
        callback(
            jsonEncode({"status": "fail", "msg": "mac地址不能为空", "data": {}}));
        return;
      }

      final bluetoothService = BluetoothDeviceManager();
      final success = await bluetoothService.disconnectDevice(identifier);

      if (success) {
        callback(
            jsonEncode({"status": "success", "msg": "设备已断开连接", "data": {}}));
      } else {
        callback(jsonEncode({"status": "fail", "msg": "断开连接失败", "data": {}}));
      }
    } catch (e) {
      callback(
          jsonEncode({"status": "fail", "msg": "断开蓝牙设备失败: $e", "data": {}}));
    }
  }
}
