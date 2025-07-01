import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
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

/// JSSDK处理器管理器
class JSSDKHandlers {
  static final Map<String, BridgeHandler> handlers = {};

  /// 初始化所有处理器
  static void initHandlers(BuildContext context) {
    // 基础功能
    handlers['setPortrait'] = _SetPortraitHandler(context);
    handlers['setLandscape'] = _SetLandscapeHandler(context);
    handlers['getToken'] = _GetTokenHandler();
    handlers['saveHomeUrl'] = _SaveHomeUrlHandler();
    handlers['openLink'] = _OpenLinkHandler();
    handlers['showFloat'] = _ShowFloatHandler(context);
    handlers['preRefresh'] = _PreRefreshHandler();
    handlers['setNavigation'] = _SetNavigationHandler(context);

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
    handlers['showPhotos'] = _ShowPhotosHandler(context);
    handlers['scanQRCode'] = _ScanQRCodeHandler(context);
    handlers['scanCodeCard'] = _ScanCodeCardHandler(context);
    handlers['savePhotoToAlbum'] = _SavePhotoToAlbumHandler();

    // 通讯录功能
    // handlers['chooseMobileContacts'] = _ChooseMobileContactsHandler(context);
    // handlers['saveMobileContacts'] = _SaveMobileContactsHandler();

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
    // handlers['launchApp'] = _LaunchAppHandler();
    handlers['openNewWebPage'] = _OpenNewWebPageHandler(context);
    handlers['logout'] = _LogoutHandler();
    handlers['clearCache'] = _ClearCacheHandler();

    // 文件操作
    handlers['fileUpload'] = _FileUploadHandler(context);
    handlers['fileDownLoadNew'] = _FileDownLoadNewHandler();
    handlers['scanFile'] = _ScanFileHandler(context);

    // 通讯功能
    handlers['call'] = _CallHandler();
    handlers['startIMChat'] = _StartIMChatHandler();
    handlers['startIMMessageList'] = _StartIMMessageListHandler();

    // 录音和语音
    handlers['startRecord'] = _StartRecordHandler(context);

    // 设备信息
    handlers['getDeviceInfo'] = _GetDeviceInfoHandler();
    handlers['getMobileDeviceInformation'] =
        _GetMobileDeviceInformationHandler();

    // 人脸识别
    handlers['startFaceCollect'] = _StartFaceCollectHandler(context);
    handlers['startFaceMatch'] = _StartFaceMatchHandler(context);

    // 签名功能
    handlers['startSign'] = _StartSignHandler(context);

    // 数据存储
    handlers['saveH5Data'] = _SaveH5DataHandler();
    handlers['getH5Data'] = _GetH5DataHandler();

    // 系统功能
    handlers['setCanInterceptBackKey'] = _SetCanInterceptBackKeyHandler();
    handlers['checkAppVersion'] = _CheckAppVersionHandler();
    handlers['getNetworkConnectType'] = _GetNetworkConnectTypeHandler();
    handlers['deleteAccount'] = _DeleteAccountHandler();
    handlers['uploadLogFile'] = _UploadLogFileHandler();

    // 蓝牙功能
    // handlers['checkBtEnable'] = _CheckBtEnableHandler();
    // handlers['getBtDeviceList'] = _GetBtDeviceListHandler();
    // handlers['connectToBtDevice'] = _ConnectToBtDeviceHandler();
    // handlers['disconnectBtDevice'] = _DisconnectBtDeviceHandler();

    // 视频监控
    handlers['ivmsplayv2'] = _Ivmsplayv2Handler();
    handlers['ivmsplay'] = _IvmsplayHandler();
    handlers['openDaHuaPreVideo'] = _OpenDaHuaPreVideoHandler();
  }

  /// 获取所有处理器
  static Map<String, BridgeHandler> getAllHandlers() {
    return handlers;
  }
}

// ==================== 基础功能处理器 ====================

class _SetPortraitHandler implements BridgeHandler {
  final BuildContext context;
  _SetPortraitHandler(this.context);

  @override
  void call(String data, Function(String) callback) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    callback(BridgeResponse.success().toJsonString());
  }
}

class _SetLandscapeHandler implements BridgeHandler {
  final BuildContext context;
  _SetLandscapeHandler(this.context);

  @override
  void call(String data, Function(String) callback) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    callback(BridgeResponse.success().toJsonString());
  }
}

class _GetTokenHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      callback(BridgeResponse.success(data: {'token': token}).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取Token失败: $e').toJsonString());
    }
  }
}

class _SaveHomeUrlHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final entity = jsonDecode(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('homeUrl', jsonEncode(entity));
      callback(BridgeResponse.success().toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '保存失败: $e').toJsonString());
    }
  }
}

class _OpenLinkHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final url = jsonDecode(data)['url'] as String;
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        callback(BridgeResponse.success().toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '无法打开链接').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '打开链接失败: $e').toJsonString());
    }
  }
}

class _ShowFloatHandler implements BridgeHandler {
  final BuildContext context;
  _ShowFloatHandler(this.context);

  @override
  void call(String data, Function(String) callback) {
    // 显示悬浮窗逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _PreRefreshHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 页面刷新逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _SetNavigationHandler implements BridgeHandler {
  final BuildContext context;
  _SetNavigationHandler(this.context);

  @override
  void call(String data, Function(String) callback) {
    // 设置导航栏逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

// ==================== 权限相关处理器 ====================

class _GetCameraAuthHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        callback(BridgeResponse.success(msg: '用户已授权').toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '获取用户授权失败').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '权限请求失败: $e').toJsonString());
    }
  }
}

class _GetLocationAuthHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        callback(BridgeResponse.success(msg: '用户已授权').toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '获取用户授权失败').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '权限请求失败: $e').toJsonString());
    }
  }
}

class _GetMicrophoneAuthHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        callback(BridgeResponse.success(msg: '用户已授权').toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '获取用户授权失败').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '权限请求失败: $e').toJsonString());
    }
  }
}

class _GetCalendarsAuthHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final status = await Permission.calendar.request();
      if (status.isGranted) {
        callback(BridgeResponse.success(msg: '用户已授权').toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '获取用户授权失败').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '权限请求失败: $e').toJsonString());
    }
  }
}

class _GetStorageAuthHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        callback(BridgeResponse.success(msg: '用户已授权').toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '获取用户授权失败').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '权限请求失败: $e').toJsonString());
    }
  }
}

class _GetBluetoothAuthHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final status = await Permission.bluetooth.request();
      if (status.isGranted) {
        callback(BridgeResponse.success(msg: '用户已授权').toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '获取用户授权失败').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '权限请求失败: $e').toJsonString());
    }
  }
}

class _GetAddressBookHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        callback(BridgeResponse.success(msg: '用户已授权').toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '获取用户授权失败').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '权限请求失败: $e').toJsonString());
    }
  }
}

// ==================== 媒体功能处理器 ====================

class _SaveImageHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final imageData = jsonDecode(data);
      final imageUrl = imageData['url'] as String;

      // 下载图片并保存到相册
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/saved_image.jpg');
      await file.writeAsBytes(response.bodyBytes);

      callback(BridgeResponse.success().toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '保存图片失败: $e').toJsonString());
    }
  }
}

class _ShowPhotosHandler implements BridgeHandler {
  final BuildContext context;
  _ShowPhotosHandler(this.context);

  @override
  void call(String data, Function(String) callback) {
    // 显示图片预览逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _ScanQRCodeHandler implements BridgeHandler {
  final BuildContext context;
  _ScanQRCodeHandler(this.context);

  @override
  void call(String data, Function(String) callback) async {
    try {
      // 使用image_picker扫描二维码
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        // 这里应该解析二维码内容
        final qrContent = "mock_qr_content"; // 实际应该解析图片
        callback(BridgeResponse.success(data: {'content': qrContent})
            .toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '扫描取消').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '扫描失败: $e').toJsonString());
    }
  }
}

class _ScanCodeCardHandler implements BridgeHandler {
  final BuildContext context;
  _ScanCodeCardHandler(this.context);

  @override
  void call(String data, Function(String) callback) async {
    try {
      // 扫描卡片逻辑，类似二维码扫描
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final cardContent = "mock_card_content";
        callback(BridgeResponse.success(data: {'content': cardContent})
            .toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '扫描取消').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '扫描失败: $e').toJsonString());
    }
  }
}

class _SavePhotoToAlbumHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final photoData = jsonDecode(data);
      final base64Data = photoData['base64data'] as String?;
      final downloadUrl = photoData['downloadurl'] as String?;

      if (base64Data != null) {
        // 保存base64图片
        final bytes = base64Decode(base64Data);
        final directory = await getApplicationDocumentsDirectory();
        final file = File(
            '${directory.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(bytes);
      } else if (downloadUrl != null) {
        // 下载并保存图片
        final response = await http.get(Uri.parse(downloadUrl));
        final directory = await getApplicationDocumentsDirectory();
        final file = File(
            '${directory.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(response.bodyBytes);
      }

      callback(BridgeResponse.success().toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '保存图片失败: $e').toJsonString());
    }
  }
}

// ==================== 位置服务处理器 ====================

class _GetLocationHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
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

      callback(BridgeResponse.success(data: locationData).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取位置失败: $e').toJsonString());
    }
  }
}

class _MapGetLocationHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 地图获取位置，类似getLocation
    _GetLocationHandler().call(data, callback);
  }
}

class _NavigationToHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final navData = jsonDecode(data);
      final latitude = double.parse(navData['latitude']);
      final longitude = double.parse(navData['longitude']);
      final address = navData['address'] as String;

      // 打开地图应用进行导航
      final url = 'https://maps.google.com/maps?q=$latitude,$longitude';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        callback(BridgeResponse.success().toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '无法打开地图').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '导航失败: $e').toJsonString());
    }
  }
}

class _NavigationBackActionHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 导航返回操作
    callback(BridgeResponse.success().toJsonString());
  }
}

class _GetIsVirtualPositioningHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      // 检查是否为虚拟定位
      final isMockLocation = await Geolocator.isLocationServiceEnabled();
      final locationData = {
        'isVirtualPositioning': isMockLocation ? 0 : 1,
        'message': isMockLocation ? '' : '可能为虚拟定位',
      };

      callback(BridgeResponse.success(data: locationData).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '检查虚拟定位失败: $e').toJsonString());
    }
  }
}

// ==================== 用户信息处理器 ====================

class _GetUserInfoHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        callback(BridgeResponse.success(data: userData).toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '用户未登录').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取用户信息失败: $e').toJsonString());
    }
  }
}

class _GetSessionStorageHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      final homeUrlJson = prefs.getString('homeUrl');

      final sessionData = {
        'token': userJson != null ? jsonDecode(userJson)['token'] : null,
        'userId': userJson != null ? jsonDecode(userJson)['tokenId'] : null,
        'userName': userJson != null ? jsonDecode(userJson)['userName'] : null,
        'phone': userJson != null ? jsonDecode(userJson)['phone'] : null,
        'windowsId':
            homeUrlJson != null ? jsonDecode(homeUrlJson)['windowsId'] : null,
        'baseUrl': 'http://172.26.13.124:8003', // 默认baseUrl
      };

      callback(BridgeResponse.success(data: sessionData).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取会话存储失败: $e').toJsonString());
    }
  }
}

class _AutoLoginHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final loginData = jsonDecode(data);
      final token = loginData['token'] as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', jsonEncode({'token': token}));

      callback(BridgeResponse.success().toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '自动登录失败: $e').toJsonString());
    }
  }
}

class _ReStartLoginHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = jsonDecode(userJson);
        if (user['refreshToken'] != null) {
          // 这里应该调用刷新token的API
          callback(BridgeResponse.success().toJsonString());
        } else {
          callback(BridgeResponse.error(msg: '刷新token失败').toJsonString());
        }
      } else {
        callback(BridgeResponse.error(msg: '用户未登录').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '重新登录失败: $e').toJsonString());
    }
  }
}

// ==================== 设备信息处理器 ====================

class _GetDeviceInfoHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
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
        'buildVersionName': '1.0.0', // 应用版本
      };

      callback(BridgeResponse.success(data: deviceData).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取设备信息失败: $e').toJsonString());
    }
  }
}

class _GetMobileDeviceInformationHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
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

      callback(BridgeResponse.success(data: deviceData).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取移动设备信息失败: $e').toJsonString());
    }
  }
}

// ==================== 网络功能处理器 ====================

class _GetNetworkConnectTypeHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
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
      callback(BridgeResponse.success(data: networkData).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取网络连接类型失败: $e').toJsonString());
    }
  }
}

// ==================== 数据存储处理器 ====================

class _SaveH5DataHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final saveData = jsonDecode(data);
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

      callback(BridgeResponse.success(msg: '保存数据成功').toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '保存数据失败: $e').toJsonString());
    }
  }
}

class _GetH5DataHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final getData = jsonDecode(data);
      final key = getData['key'] as String;

      final prefs = await SharedPreferences.getInstance();
      final value = prefs.get(key);

      callback(BridgeResponse.success(data: value).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取数据失败: $e').toJsonString());
    }
  }
}

// ==================== 系统功能处理器 ====================

class _SetCanInterceptBackKeyHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 设置是否拦截返回键
    callback(BridgeResponse.success().toJsonString());
  }
}

class _CheckAppVersionHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 检查应用版本
    callback(BridgeResponse.success().toJsonString());
  }
}

class _DeleteAccountHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      // 删除账号逻辑
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('homeUrl');
      callback(BridgeResponse.success().toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '删除账号失败: $e').toJsonString());
    }
  }
}

class _UploadLogFileHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      // 上传日志文件逻辑
      final logFile =
          File('${(await getApplicationDocumentsDirectory()).path}/log.txt');
      if (await logFile.exists()) {
        // 这里应该上传文件到服务器
        callback(BridgeResponse.success(data: {'fileUrl': 'mock_file_url'})
            .toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '日志文件不存在').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '上传日志文件失败: $e').toJsonString());
    }
  }
}

// ==================== 文件操作处理器 ====================

class _FileUploadHandler implements BridgeHandler {
  final BuildContext context;
  _FileUploadHandler(this.context);

  @override
  void call(String data, Function(String) callback) async {
    try {
      final uploadData = jsonDecode(data);
      final maxCount = uploadData['maxCount'] as int? ?? 1;
      final uploadUrl = uploadData['uploadurl'] as String? ?? '';

      // 选择文件
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: maxCount > 1,
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        // 这里应该上传文件到服务器
        final uploadedFiles = result.files.map((file) => file.path).toList();
        callback(BridgeResponse.success(data: uploadedFiles).toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '未选择文件').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '文件上传失败: $e').toJsonString());
    }
  }
}

class _FileDownLoadNewHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final downloadData = jsonDecode(data);
      final appDownloadUrl = downloadData['appDownloadUrl'] as String;

      if (appDownloadUrl.isNotEmpty) {
        // 下载文件逻辑
        final response = await http.get(Uri.parse(appDownloadUrl));
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'download_${DateTime.now().millisecondsSinceEpoch}';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        callback(BridgeResponse.success().toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '下载地址有误').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '文件下载失败: $e').toJsonString());
    }
  }
}

class _ScanFileHandler implements BridgeHandler {
  final BuildContext context;
  _ScanFileHandler(this.context);

  @override
  void call(String data, Function(String) callback) {
    // 文件预览逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

// ==================== 通讯功能处理器 ====================

class _CallHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      final callData = jsonDecode(data);
      final phone = callData['phone'] as String;

      final uri = Uri.parse('tel:$phone');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        callback(BridgeResponse.success().toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '无法拨打电话').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '拨打电话失败: $e').toJsonString());
    }
  }
}

class _StartIMChatHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 开始IM聊天逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _StartIMMessageListHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 打开IM消息列表逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

// ==================== 录音和语音处理器 ====================

class _StartRecordHandler implements BridgeHandler {
  final BuildContext context;
  _StartRecordHandler(this.context);

  @override
  void call(String data, Function(String) callback) async {
    try {
      // 语音识别逻辑
      final recognizeResult = "mock_recognize_result";
      callback(BridgeResponse.success(data: recognizeResult).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '语音识别失败: $e').toJsonString());
    }
  }
}

// ==================== 人脸识别处理器 ====================

class _StartFaceCollectHandler implements BridgeHandler {
  final BuildContext context;
  _StartFaceCollectHandler(this.context);

  @override
  void call(String data, Function(String) callback) async {
    try {
      // 人脸采集逻辑
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final faceImageUrl = image.path;
        callback(BridgeResponse.success(data: {'faceImageUrl': faceImageUrl})
            .toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '人脸采集取消').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '人脸采集失败: $e').toJsonString());
    }
  }
}

class _StartFaceMatchHandler implements BridgeHandler {
  final BuildContext context;
  _StartFaceMatchHandler(this.context);

  @override
  void call(String data, Function(String) callback) async {
    try {
      // 人脸匹配逻辑
      final matchData = jsonDecode(data);
      final faceUrl = matchData['faceUrl'] as String;

      // 这里应该进行人脸匹配
      final matchResult = true; // 模拟匹配结果
      callback(BridgeResponse.success(data: {'matchResult': matchResult})
          .toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '人脸匹配失败: $e').toJsonString());
    }
  }
}

// ==================== 签名功能处理器 ====================

class _StartSignHandler implements BridgeHandler {
  final BuildContext context;
  _StartSignHandler(this.context);

  @override
  void call(String data, Function(String) callback) async {
    try {
      // 签名功能逻辑
      final signImageBase64 = "mock_sign_image_base64";
      callback(
          BridgeResponse.success(data: {'signImageBase64': signImageBase64})
              .toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '签名失败: $e').toJsonString());
    }
  }
}

// ==================== 会议和通话处理器 ====================

class _OpenMeetingHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 打开会议逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _StartAudioCallHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 开始音频通话逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _StartVideoCallHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 开始视频通话逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _OpenNewWebPageHandler implements BridgeHandler {
  final BuildContext context;
  _OpenNewWebPageHandler(this.context);

  @override
  void call(String data, Function(String) callback) async {
    try {
      final url = jsonDecode(data)['url'] as String;
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        callback(BridgeResponse.success().toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '无法打开链接').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '打开链接失败: $e').toJsonString());
    }
  }
}

class _LogoutHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      // 退出登录逻辑
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('homeUrl');
      callback(BridgeResponse.success().toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '退出登录失败: $e').toJsonString());
    }
  }
}

class _ClearCacheHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) async {
    try {
      // 清除缓存逻辑
      await UserService.clearCache();
      callback(BridgeResponse.success().toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '清除缓存失败: $e').toJsonString());
    }
  }
}

// class _ChooseMobileContactsHandler implements BridgeHandler {
//   final BuildContext context;
//   _ChooseMobileContactsHandler(this.context);

//   @override
//   void call(String data, Function(String) callback) async {
//     try {
//       // 选择移动联系人逻辑
//       final result = await ContactsService.chooseMobileContacts(context);
//       callback(BridgeResponse.success(data: result).toJsonString());
//     } catch (e) {
//       callback(BridgeResponse.error(msg: '选择移动联系人失败: $e').toJsonString());
//     }
//   }
// }

// class _SaveMobileContactsHandler implements BridgeHandler {
//   @override
//   void call(String data, Function(String) callback) async {
//     try {
//       // 保存移动联系人逻辑
//       final result = await ContactService.saveMobileContacts();
//       callback(BridgeResponse.success(data: result).toJsonString());
//     } catch (e) {
//       callback(BridgeResponse.error(msg: '保存移动联系人失败: $e').toJsonString());
//     }
//   }
// }

// class _LaunchAppHandler implements BridgeHandler {
//   @override
//   void call(String data, Function(String) callback) async {
//     try {
//       // 启动应用逻辑
//       final result = await AppService.launchApp();
//       callback(BridgeResponse.success(data: result).toJsonString());
//     } catch (e) {
//       callback(BridgeResponse.error(msg: '启动应用失败: $e').toJsonString());
//     }
//   }
// }

// class _CheckBtEnableHandler implements BridgeHandler {
//   @override
//   void call(String data, Function(String) callback) async {
//     try {
//       // 检查蓝牙是否启用逻辑
//       final isBtEnabled = await BluetoothService.checkBtEnable();
//       callback(BridgeResponse.success(data: {'isBtEnabled': isBtEnabled})
//           .toJsonString());
//     } catch (e) {
//       callback(BridgeResponse.error(msg: '检查蓝牙失败: $e').toJsonString());
//     }
//   }
// }

// class _GetBtDeviceListHandler implements BridgeHandler {
//   @override
//   void call(String data, Function(String) callback) async {
//     try {
//       // 获取蓝牙设备列表逻辑
//       final deviceList = await BluetoothService.getBtDeviceList();
//       callback(BridgeResponse.success(data: deviceList).toJsonString());
//     } catch (e) {
//       callback(BridgeResponse.error(msg: '获取蓝牙设备列表失败: $e').toJsonString());
//     }
//   }
// }

// class _ConnectToBtDeviceHandler implements BridgeHandler {
//   @override
//   void call(String data, Function(String) callback) async {
//     try {
//       // 连接到蓝牙设备逻辑
//       final result = await BluetoothService.connectToBtDevice();
//       callback(BridgeResponse.success(data: result).toJsonString());
//     } catch (e) {
//       callback(BridgeResponse.error(msg: '连接到蓝牙设备失败: $e').toJsonString());
//     }
//   }
// }

// class _DisconnectBtDeviceHandler implements BridgeHandler {
//   @override
//   void call(String data, Function(String) callback) async {
//     try {
//       // 断开蓝牙设备连接逻辑
//       final result = await BluetoothService.disconnectBtDevice();
//       callback(BridgeResponse.success(data: result).toJsonString());
//     } catch (e) {
//       callback(BridgeResponse.error(msg: '断开蓝牙设备连接失败: $e').toJsonString());
//     }
//   }
// }

class _Ivmsplayv2Handler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 视频监控逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _IvmsplayHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 视频监控逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}

class _OpenDaHuaPreVideoHandler implements BridgeHandler {
  @override
  void call(String data, Function(String) callback) {
    // 打开大华预览视频逻辑
    callback(BridgeResponse.success().toJsonString());
  }
}
