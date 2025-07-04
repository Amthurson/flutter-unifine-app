import 'package:dio/dio.dart';
import '../config/env_config.dart';

class UserManagementApi {
  static final Dio _dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  /// 获取IM账号信息
  static Future<Map<String, dynamic>> getImAccount(
      Map<String, dynamic> param) async {
    try {
      final resp =
          await _dio.post('yjy/general/common/im/account/info', data: param);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取IM账号失败');
      }
    } catch (e) {
      throw Exception('获取IM账号失败: $e');
    }
  }

  /// 获取好友列表
  static Future<List<dynamic>> getFriendList(String searchName) async {
    try {
      final resp = await _dio.get(
          'porgan/a/get/enterprise/query_friend_list?searchName=$searchName');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取好友列表失败');
      }
    } catch (e) {
      throw Exception('获取好友列表失败: $e');
    }
  }

  /// 验证码校验
  static Future<String> verifyCodeCheck(Map<String, dynamic> body) async {
    try {
      final resp = await _dio.post('yjy/general/p/captcha/phone/validate/v2',
          data: body);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '验证码校验失败');
      }
    } catch (e) {
      throw Exception('验证码校验失败: $e');
    }
  }

  /// 重置密码
  static Future<void> resetPassword(Map<String, dynamic> body) async {
    try {
      final resp =
          await _dio.post('yjy/organ/a/user/password/reset', data: body);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '重置密码失败');
      }
    } catch (e) {
      throw Exception('重置密码失败: $e');
    }
  }

  /// 设置首次密码
  static Future<void> setFirstPassword(Map<String, dynamic> body) async {
    try {
      final resp = await _dio.post('yjy/organ/a/user/set/password', data: body);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '设置密码失败');
      }
    } catch (e) {
      throw Exception('设置密码失败: $e');
    }
  }

  /// 获取用户实名信息
  static Future<Map<String, dynamic>> getUserRealNameInfo() async {
    try {
      final resp = await _dio.get('yjy/organ/a/user/real/name/info');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取用户实名信息失败');
      }
    } catch (e) {
      throw Exception('获取用户实名信息失败: $e');
    }
  }

  /// 保存实名信息
  static Future<void> saveRealNameInfo(
      Map<String, dynamic> realNameParam) async {
    try {
      final resp = await _dio.post('yjy/organ/a/user/real/name/valid',
          data: realNameParam);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '保存实名信息失败');
      }
    } catch (e) {
      throw Exception('保存实名信息失败: $e');
    }
  }

  /// 人脸采集
  static Future<void> collectFace(
      Map<String, dynamic> faceCollectionParam) async {
    try {
      final resp = await _dio.post('yjy/organ/get/face/collection',
          data: faceCollectionParam);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '人脸采集失败');
      }
    } catch (e) {
      throw Exception('人脸采集失败: $e');
    }
  }

  /// 获取应用下载二维码
  static Future<String> getAppDownQrcode(
      Map<String, dynamic> qrcodeParam) async {
    try {
      final resp =
          await _dio.post('yjy/general/p/common/qrcode', data: qrcodeParam);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取二维码失败');
      }
    } catch (e) {
      throw Exception('获取二维码失败: $e');
    }
  }

  /// 修改用户头像
  static Future<String> changeUserHeadImg(Map<String, dynamic> param) async {
    try {
      final resp =
          await _dio.post('yjy/organ/a/user/avatar/update', data: param);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '修改头像失败');
      }
    } catch (e) {
      throw Exception('修改头像失败: $e');
    }
  }

  /// 获取用户头像
  static Future<Map<String, dynamic>> getUserHeadImage() async {
    try {
      final resp = await _dio.post('yjy/organ/a/user/information/get');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取用户头像失败');
      }
    } catch (e) {
      throw Exception('获取用户头像失败: $e');
    }
  }

  /// 更新我的信息
  static Future<void> updateMe(Map<String, dynamic> param) async {
    try {
      final resp =
          await _dio.post('yjy/organ/a/user/basic/info/update', data: param);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '更新信息失败');
      }
    } catch (e) {
      throw Exception('更新信息失败: $e');
    }
  }

  /// 人脸匹配
  static Future<Map<String, dynamic>> startFaceMatch(
      Map<String, dynamic> param) async {
    try {
      final resp = await _dio.post('yjy/cloud/face/match', data: param);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '人脸匹配失败');
      }
    } catch (e) {
      throw Exception('人脸匹配失败: $e');
    }
  }

  /// OAuth登录
  static Future<String> oauthLogin({String platformType = "0"}) async {
    try {
      final resp = await _dio
          .get('yjy/cloud/sso/oauth/login/href?platformType=$platformType');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? 'OAuth登录失败');
      }
    } catch (e) {
      throw Exception('OAuth登录失败: $e');
    }
  }

  /// OAuth登出
  static Future<void> oauthLoginOut({String platformType = "0"}) async {
    try {
      final resp = await _dio
          .get('yjy/cloud/sso/oauth/loginOut?platformType=$platformType');
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? 'OAuth登出失败');
      }
    } catch (e) {
      throw Exception('OAuth登出失败: $e');
    }
  }

  /// 账号注销
  static Future<void> accountCancellation(Map<String, dynamic> param) async {
    try {
      final resp = await _dio.post('yjy/cloud/a/user/writtenOff', data: param);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '账号注销失败');
      }
    } catch (e) {
      throw Exception('账号注销失败: $e');
    }
  }

  /// 用户登出
  static Future<void> loginOut() async {
    try {
      final resp = await _dio.get('yjy/organ/a/user/logout');
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '登出失败');
      }
    } catch (e) {
      throw Exception('登出失败: $e');
    }
  }

  /// 绑定微信手机号
  static Future<Map<String, dynamic>> bindWechatPhone(
      Map<String, dynamic> param) async {
    try {
      final resp =
          await _dio.post('yjy/organ/p/user/wechat/bind-phone', data: param);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '绑定微信手机号失败');
      }
    } catch (e) {
      throw Exception('绑定微信手机号失败: $e');
    }
  }

  /// 微信登录
  static Future<Map<String, dynamic>> wechatLogin(
      Map<String, dynamic> body) async {
    try {
      final resp = await _dio.post('yjy/organ/p/user/wechat/login', data: body);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '微信登录失败');
      }
    } catch (e) {
      throw Exception('微信登录失败: $e');
    }
  }

  /// 获取版本信息
  static Future<Map<String, dynamic>> getVersion(String currentVersion) async {
    try {
      final resp = await _dio.get(
          'yjy/organ/a/version/info?currentVersion=$currentVersion',
          options: Options(headers: {'platform': '0'}));
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取版本信息失败');
      }
    } catch (e) {
      throw Exception('获取版本信息失败: $e');
    }
  }

  /// 请求UM信息
  static Future<void> requestUMInfo(Map<String, dynamic> param) async {
    try {
      final resp = await _dio.post('porgan/a/user/ymDeviceToken', data: param);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '请求UM信息失败');
      }
    } catch (e) {
      throw Exception('请求UM信息失败: $e');
    }
  }

  /// 公告签收
  static Future<void> userSignMsg(Map<String, dynamic> signBean) async {
    try {
      final resp = await _dio.post('sys/biz/a/workbench/notice/user/sign',
          data: signBean);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '公告签收失败');
      }
    } catch (e) {
      throw Exception('公告签收失败: $e');
    }
  }
}
