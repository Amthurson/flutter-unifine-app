import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../utils/dio_client.dart';

class CloudApi {
  /// 获取用户首页信息
  static Future<Map<String, dynamic>> getHomeUrlInfo() async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get('yjy/cloud/a/master/service');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取首页信息失败');
      }
    } catch (e) {
      throw Exception('获取首页信息失败: $e');
    }
  }

  /// 公司组织架构人员搜索
  static Future<List<dynamic>> searchCompanyUser(
      Map<String, dynamic> searchCompanyUserParam) async {
    try {
      final dio = await DioClient.getInstance();
      final resp =
          await dio.post('yjy/cloud/a/user/list', data: searchCompanyUserParam);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '搜索公司用户失败');
      }
    } catch (e) {
      throw Exception('搜索公司用户失败: $e');
    }
  }

  /// 公司组织架构
  static Future<Map<String, dynamic>> getCompanyDetail(
      Map<String, dynamic> companyDetailParam) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.post('yjy/cloud/a/direct/org/and/user/list',
          data: companyDetailParam);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取公司详情失败');
      }
    } catch (e) {
      throw Exception('获取公司详情失败: $e');
    }
  }

  /// 通讯录公司数据
  static Future<List<dynamic>> getCompanyList() async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get('yjy/cloud/a/user/server/list');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取公司列表失败');
      }
    } catch (e) {
      throw Exception('获取公司列表失败: $e');
    }
  }

  /// 扫码登录
  static Future<void> scanLogin(String token) async {
    try {
      final dio = await DioClient.getInstance();
      final resp =
          await dio.get('yjy/cloud/login/qrcode/authorization?token=$token');
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '扫码登录失败');
      }
    } catch (e) {
      throw Exception('扫码登录失败: $e');
    }
  }

  /// 获取组织架构
  static Future<Map<String, dynamic>> getOrganTree(
      String busBusinessId, String organUuid) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get(
          'porgan/a/enterprise/book/query_organ_tree?busBusinessId=$busBusinessId&organUuid=$organUuid');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取组织架构失败');
      }
    } catch (e) {
      throw Exception('获取组织架构失败: $e');
    }
  }

  /// 获取企业信息
  static Future<Map<String, dynamic>> getEnterpriseInfo(
      String busBusinessUuid) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get(
          'porgan/a/enterprise/enterpriseQrcode/queryEnterpriseInfo?busBusinessUuid=$busBusinessUuid');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取企业信息失败');
      }
    } catch (e) {
      throw Exception('获取企业信息失败: $e');
    }
  }

  /// 加入企业
  static Future<void> joinEnterprise(String busBusinessUuid) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get(
          'porgan/a/enterprise/enterpriseQrcode/bindUserSubmit?busBusinessUuid=$busBusinessUuid');
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '加入企业失败');
      }
    } catch (e) {
      throw Exception('加入企业失败: $e');
    }
  }

  /// 获取组织架构树
  static Future<List<dynamic>> getOrganTreeList(String busBusinessUuid) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get(
          'porgan/a/enterprise/book/queryOrganTree?busBusinessUuid=$busBusinessUuid');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取组织架构树失败');
      }
    } catch (e) {
      throw Exception('获取组织架构树失败: $e');
    }
  }

  /// 查询用户
  static Future<List<dynamic>> getAddressUser(
      Map<String, dynamic> param) async {
    try {
      final dio = await DioClient.getInstance();
      final resp =
          await dio.post('porgan/a/enterprise/book/queryUser', data: param);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '查询用户失败');
      }
    } catch (e) {
      throw Exception('查询用户失败: $e');
    }
  }

  /// 查询所有用户
  static Future<List<dynamic>> getAllUser(String busBusinessUuid) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get(
          'porgan/a/enterprise/book/queryAllUser?busBusinessUuid=$busBusinessUuid');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '查询所有用户失败');
      }
    } catch (e) {
      throw Exception('查询所有用户失败: $e');
    }
  }

  /// 请求业务UUID
  static Future<Map<String, dynamic>> requestBusinessUuid(
      String url, String deviceImei) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get('$url?deviceImei=$deviceImei');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '请求业务UUID失败');
      }
    } catch (e) {
      throw Exception('请求业务UUID失败: $e');
    }
  }

  /// 访客登录
  static Future<Map<String, dynamic>> visitorLogin() async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get('porgan/a/user/login/visitorLoginSubmit');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '访客登录失败');
      }
    } catch (e) {
      throw Exception('访客登录失败: $e');
    }
  }

  /// 获取园区信息
  static Future<Map<String, dynamic>> getParkInfo(String bpParkUuid) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio
          .get('porgan/a/park/queryAppParkInfo?bpParkUuid=$bpParkUuid');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取园区信息失败');
      }
    } catch (e) {
      throw Exception('获取园区信息失败: $e');
    }
  }

  /// 获取服务窗详情
  static Future<Map<String, dynamic>> getWindowInfo(String windowsId) async {
    try {
      final dio = await DioClient.getInstance();
      final resp =
          await dio.get('yjy/cloud/a/windows/info?windowsId=$windowsId');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取服务窗详情失败');
      }
    } catch (e) {
      throw Exception('获取服务窗详情失败: $e');
    }
  }

  /// 服务窗切换上报
  static Future<void> selectWindow(String windowsId) async {
    try {
      final dio = await DioClient.getInstance();
      final resp =
          await dio.get('yjy/cloud/a/windows/select?windowsId=$windowsId');
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '服务窗切换失败');
      }
    } catch (e) {
      throw Exception('服务窗切换失败: $e');
    }
  }

  /// 获取全局配置
  static Future<Map<String, dynamic>> getGlobalConfig() async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.get('yjy/cloud/p/service/config/global');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取全局配置失败');
      }
    } catch (e) {
      throw Exception('获取全局配置失败: $e');
    }
  }

  /// 获取服务窗配置
  static Future<Map<String, dynamic>> getWindowsConfig(
      String? windowsId) async {
    try {
      final dio = await DioClient.getInstance();
      final url = windowsId != null
          ? 'yjy/cloud/p/service/config/windows?windowsId=$windowsId'
          : 'yjy/cloud/p/service/config/windows';
      final resp = await dio.get(url);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取服务窗配置失败');
      }
    } catch (e) {
      throw Exception('获取服务窗配置失败: $e');
    }
  }

  /// 通过用户获取atrust用户信息
  static Future<Map<String, dynamic>> getLxrApi(String mobile) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio
          .post('yjy/external/portal/service/unified-lxr-api?mobile=$mobile');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取atrust用户信息失败');
      }
    } catch (e) {
      throw Exception('获取atrust用户信息失败: $e');
    }
  }

  /// 用户数据采集
  static Future<void> setUserAction(Map<String, dynamic> param) async {
    try {
      final dio = await DioClient.getInstance();
      final resp = await dio.post('yjy/cloud/p/sys/user/action', data: param);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '用户数据采集失败');
      }
    } catch (e) {
      throw Exception('用户数据采集失败: $e');
    }
  }

  /// 直接请求，用于服务端获取数据，不关心结果
  static Future<void> directRequest(String url) async {
    try {
      final dio = await DioClient.getInstance();
      await dio.get(url);
    } catch (e) {
      throw Exception('直接请求失败: $e');
    }
  }
}
