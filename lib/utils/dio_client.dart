import 'package:dio/dio.dart';
import 'package:unified_front_end/config/env_config.dart';
import 'package:unified_front_end/services/user_service.dart';

class DioClient {
  static Dio? _dio;

  static Future<Dio> getInstance() async {
    if (_dio != null) return _dio!;
    _dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    // 添加拦截器
    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await UserService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = token;
        }
        return handler.next(options);
      },
    ));
    return _dio!;
  }
}
