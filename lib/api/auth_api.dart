import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../utils/encrypt_util.dart';
import '../utils/dio_client.dart';

class AuthApi {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// 获取RSA公钥
  static Future<String> getPublicKey() async {
    try {
      final resp = await _dio.get('yjy/general/a/public_key');
      if (resp.data['data'] != null &&
          resp.data['data'].toString().isNotEmpty) {
        final publicKey = resp.data['data'];
        return publicKey;
      } else {
        throw Exception(resp.data['msg'] ?? '获取公钥失败');
      }
    } catch (e) {
      throw Exception('获取公钥失败: $e');
    }
  }

  /// 获取全局配置
  static Future<Map<String, dynamic>> getGlobalConfig() async {
    final dio = await DioClient.getInstance();
    dio.options.baseUrl = EnvConfig.baseUrl;
    final resp = await dio.get('/yjy/cloud/p/service/config/global');
    if (resp.data['code'] == 3001) {
      return resp.data['data'];
    } else {
      throw Exception(resp.data['msg'] ?? '获取全局配置失败');
    }
  }

  /// 获取IM账号信息
  static Future<Map<String, dynamic>> getImAccount(
      Map<String, dynamic> param) async {
    try {
      final resp = await _dio.post(
        '/yjy/general/common/im/account/info',
        data: param,
      );
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取IM账号失败');
      }
    } catch (e) {
      throw Exception('获取IM账号失败: $e');
    }
  }

  /// 发送验证码
  static Future<void> sendCode(String phone, String publicKey) async {
    final encryptedPhone = EncryptUtil.encryptPhone(phone, publicKey);
    final resp = await _dio.post(
      'yjy/general/p/captcha/phone/v3',
      data: {
        'phone': encryptedPhone,
        'smsType': 34390119,
      },
    );
    if (resp.data['code'] != 3001) {
      throw Exception(resp.data['msg'] ?? '发送验证码失败');
    }
  }

  /// 验证码登录
  static Future<Map<String, dynamic>> loginWithCode(
    String phone,
    String code,
    String publicKey,
  ) async {
    try {
      final encryptedPhone = EncryptUtil.encryptPhone(phone, publicKey);
      final resp = await _dio.post(
        'yjy/organ/a/user/login/phone',
        data: {
          'phone': encryptedPhone,
          'captcha': code,
          'userType': '8',
        },
      );
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '登录失败');
      }
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  /// 发送验证码（用加密后的手机号）
  static Future<void> sendCodeWithEncrypted(
      String encryptedPhone, String publicKey) async {
    final resp = await _dio.post(
      'yjy/general/p/captcha/phone/v3',
      data: {
        'phone': encryptedPhone,
        'smsType': 34390119,
      },
    );
    if (resp.data['code'] != 3001) {
      throw Exception(resp.data['msg'] ?? '发送验证码失败');
    }
  }

  /// 登录（用加密后的手机号）
  static Future<Map<String, dynamic>> loginWithEncryptedPhone(
    String encryptedPhone,
    String code,
  ) async {
    final resp = await _dio.post(
      'yjy/organ/a/user/login/phone',
      data: {
        'phone': encryptedPhone,
        'captcha': code,
        'userType': '8',
      },
    );
    if (resp.data['code'] == 3001) {
      return resp.data['data'];
    } else {
      throw Exception(resp.data['msg'] ?? '登录失败');
    }
  }

  /// 登录（重新加密手机号，不包含时间戳）
  static Future<Map<String, dynamic>> loginWithPhone(
    String phone,
    String code,
    String publicKey,
  ) async {
    try {
      final encryptedPhone = EncryptUtil.encryptPhoneForLogin(phone, publicKey);
      final resp = await _dio.post(
        'yjy/organ/a/user/login/phone',
        data: {
          'phone': encryptedPhone,
          'captcha': code,
          'userType': '8',
        },
      );
      if (resp.data['success'] == true) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '登录失败');
      }
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }
}

class PasswordLoginApi {
  static final Dio _dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  /// 密码登录（使用RSA加密账号和密码）
  static Future<Map<String, dynamic>> loginWithPassword(
    String username,
    String password,
    String publicKey,
  ) async {
    try {
      // 使用RSA加密账号和密码
      final encryptedUsername =
          EncryptUtil.encryptUsername(username, publicKey);
      final encryptedPassword =
          EncryptUtil.encryptPassword(password, publicKey);

      final resp = await _dio.post(
        '/yjy/organ/a/user/login/password/v2',
        data: {
          'account': encryptedUsername,
          'password': encryptedPassword,
          'userType': '8',
        },
      );
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '登录失败');
      }
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }
}
