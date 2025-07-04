import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../utils/dio_client.dart';

class UserApi {
  static final Dio _dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  /// 获取用户信息
  static Future<Map<String, dynamic>> getUserInfo() async {
    final dio = await DioClient.getInstance();
    try {
      final resp = await dio.post(
        'yjy/organ/a/login/user/info/v3',
      );
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取用户信息失败');
      }
    } catch (e) {
      throw Exception('获取用户信息失败: $e');
    }
  }

  /// 获取图形验证码
  static Future<Map<String, dynamic>> getImageCode() async {
    try {
      final resp = await _dio.get('yjy/general/a/captcha/login/image');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取图形验证码失败');
      }
    } catch (e) {
      throw Exception('获取图形验证码失败: $e');
    }
  }

  /// 手机号码登录
  static Future<Map<String, dynamic>> messageCodeLogin(
      Map<String, dynamic> param) async {
    try {
      final resp = await _dio.post('yjy/organ/a/user/login/phone', data: param);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '手机号码登录失败');
      }
    } catch (e) {
      throw Exception('手机号码登录失败: $e');
    }
  }

  /// 密码登录
  static Future<Map<String, dynamic>> passwordLogin(
      Map<String, dynamic> body) async {
    try {
      final resp =
          await _dio.post('yjy/organ/a/user/login/password/v2', data: body);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '密码登录失败');
      }
    } catch (e) {
      throw Exception('密码登录失败: $e');
    }
  }

  /// 获取登录公钥
  static Future<String> getLoginKey() async {
    try {
      final resp = await _dio.get('yjy/general/a/public_key');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取登录公钥失败');
      }
    } catch (e) {
      throw Exception('获取登录公钥失败: $e');
    }
  }
}
