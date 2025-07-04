import 'dart:io';
import 'package:dio/dio.dart';
import '../config/env_config.dart';

class FileApi {
  static final Dio _dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  /// 下载文件
  static Future<Response> downloadFile(String fileUrl) async {
    try {
      final resp = await _dio.get(
        fileUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );
      return resp;
    } catch (e) {
      throw Exception('下载文件失败: $e');
    }
  }

  /// 上传单个文件
  static Future<Map<String, dynamic>> uploadFile(
      String description, File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'description': description,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final resp = await _dio.post(
        'yjy/general/p/common/resource/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '上传文件失败');
      }
    } catch (e) {
      throw Exception('上传文件失败: $e');
    }
  }

  /// 上传单个文件到指定URL
  static Future<Map<String, dynamic>> uploadFileToUrl(
      String url, String description, File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'description': description,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final resp = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '上传文件失败');
      }
    } catch (e) {
      throw Exception('上传文件失败: $e');
    }
  }

  /// 上传多个文件
  static Future<Map<String, dynamic>> uploadMultipleFiles(
      String description, File file1, File file2) async {
    try {
      final fileName1 = file1.path.split('/').last;
      final fileName2 = file2.path.split('/').last;

      final formData = FormData.fromMap({
        'description': description,
        'file1': await MultipartFile.fromFile(
          file1.path,
          filename: fileName1,
        ),
        'file2': await MultipartFile.fromFile(
          file2.path,
          filename: fileName2,
        ),
      });

      final resp = await _dio.post(
        'upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '上传多个文件失败');
      }
    } catch (e) {
      throw Exception('上传多个文件失败: $e');
    }
  }

  /// 上传多个文件（通用版本）
  static Future<Map<String, dynamic>> uploadMultipleFilesGeneric(
      String description, List<File> files) async {
    try {
      final Map<String, dynamic> formDataMap = {
        'description': description,
      };

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final fileName = file.path.split('/').last;
        formDataMap['file$i'] = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final resp = await _dio.post(
        'upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '上传多个文件失败');
      }
    } catch (e) {
      throw Exception('上传多个文件失败: $e');
    }
  }
}
