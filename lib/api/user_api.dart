import 'package:unified_front_end/utils/dio_client.dart';

class UserApi {
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
}
