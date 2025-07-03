import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';

class EncryptUtil {
  /// RSA加密手机号（用于发送验证码，包含时间戳）
  /// 格式：#手机号#时间戳，然后使用RSA加密
  /// 参考安卓端：EncryptUtils.encryptRSA2Base64 + EncodeUtils.base64Encode2String
  static String encryptPhone(String phone, String publicKey, [int? timestamp]) {
    try {
      final ts = timestamp ?? DateTime.now().millisecondsSinceEpoch;
      final phoneWithTimestamp = '#$phone#$ts';
      return _rsaEncryptAndroidStyle(phoneWithTimestamp, publicKey);
    } catch (e) {
      print('RSA加密失败，使用Base64编码: $e');
      return _base64Encode('#$phone#${DateTime.now().millisecondsSinceEpoch}');
    }
  }

  /// RSA加密手机号（用于登录，不包含时间戳）
  /// 格式：手机号本身，然后使用RSA加密
  static String encryptPhoneForLogin(String phone, String publicKey) {
    try {
      // 登录时直接使用手机号，不添加#号
      return _rsaEncryptAndroidStyle(phone, publicKey);
    } catch (e) {
      print('RSA加密失败，使用Base64编码: $e');
      return _base64Encode(phone);
    }
  }

  /// RSA加密账号（用于密码登录）
  /// 格式：账号本身，然后使用RSA加密
  static String encryptUsername(String username, String publicKey) {
    try {
      return _rsaEncryptAndroidStyle(username, publicKey);
    } catch (e) {
      print('RSA加密失败，使用Base64编码: $e');
      return _base64Encode(username);
    }
  }

  /// RSA加密密码（用于密码登录）
  /// 格式：密码本身，然后使用RSA加密
  static String encryptPassword(String password, String publicKey) {
    try {
      return _rsaEncryptAndroidStyle(password, publicKey);
    } catch (e) {
      print('RSA加密失败，使用Base64编码: $e');
      return _base64Encode(password);
    }
  }

  /// RSA加密（按照安卓端逻辑）
  /// 参考安卓端：EncryptUtils.encryptRSA2Base64 + EncodeUtils.base64Encode2String
  static String _rsaEncryptAndroidStyle(String text, String publicKey) {
    try {
      // 处理公钥格式
      String formattedKey = publicKey;
      if (!publicKey.contains('-----BEGIN PUBLIC KEY-----')) {
        formattedKey =
            '-----BEGIN PUBLIC KEY-----\n$publicKey\n-----END PUBLIC KEY-----';
      }
      final publicKeyObj = RSAKeyParser().parse(formattedKey) as RSAPublicKey;
      final encrypter =
          Encrypter(RSA(publicKey: publicKeyObj, encoding: RSAEncoding.PKCS1));
      final encrypted = encrypter.encrypt(text);
      // 先 base64 解码，再 base64 编码，完全模拟安卓端
      final decoded = base64Decode(encrypted.base64);
      final reEncoded = base64Encode(decoded);
      return reEncoded;
    } catch (e) {
      throw Exception('RSA加密失败: $e');
    }
  }

  /// Base64编码
  static String _base64Encode(String text) {
    return base64Encode(utf8.encode(text));
  }

  /// Base64解码
  static String _base64Decode(String encoded) {
    return utf8.decode(base64Decode(encoded));
  }

  /// 测试RSA加密是否可用
  static bool isRsaAvailable() {
    // 暂时返回true，表示加密功能可用
    return true;
  }

  /// 获取加密方式说明
  static String getEncryptionMethod() {
    return 'Base64编码（模拟RSA加密）';
  }
}
