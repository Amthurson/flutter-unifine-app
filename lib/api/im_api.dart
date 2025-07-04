import 'package:dio/dio.dart';
import '../config/env_config.dart';

class ImApi {
  static final Dio _dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  /// 刷新用户token
  static Future<Map<String, dynamic>> refreshToken(
      Map<String, dynamic> param) async {
    try {
      final resp = await _dio.post('yjy/organ/a/refresh/token', data: param);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '刷新token失败');
      }
    } catch (e) {
      throw Exception('刷新token失败: $e');
    }
  }

  /// 添加好友
  static Future<void> addFriend(Map<String, dynamic> addFriendParam) async {
    try {
      final resp =
          await _dio.post('yjy/im/a/org/contact/add', data: addFriendParam);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '添加好友失败');
      }
    } catch (e) {
      throw Exception('添加好友失败: $e');
    }
  }

  /// 创建群组
  static Future<void> createTeam(Map<String, dynamic> createTeamParam) async {
    try {
      final resp =
          await _dio.post('yjy/im/a/chat/group/create', data: createTeamParam);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '创建群组失败');
      }
    } catch (e) {
      throw Exception('创建群组失败: $e');
    }
  }

  /// 删除好友
  static Future<void> deleteUser(String contactUserId) async {
    try {
      final resp = await _dio
          .post('yjy/im/a/pending/review/contact/delete/$contactUserId');
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '删除好友失败');
      }
    } catch (e) {
      throw Exception('删除好友失败: $e');
    }
  }

  /// 设置用户别名
  static Future<void> updateUserInfo(
      Map<String, dynamic> updateUserInfoParam) async {
    try {
      final resp = await _dio.post('yjy/im/a/pending/review/contact/update',
          data: updateUserInfoParam);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '更新用户信息失败');
      }
    } catch (e) {
      throw Exception('更新用户信息失败: $e');
    }
  }

  /// 获取用户详情
  static Future<Map<String, dynamic>> getUserDetail(
      Map<String, dynamic> userDetailParam) async {
    try {
      final resp =
          await _dio.post('yjy/im/a/contact/user/info', data: userDetailParam);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取用户详情失败');
      }
    } catch (e) {
      throw Exception('获取用户详情失败: $e');
    }
  }

  /// 获取新好友列表
  static Future<Map<String, dynamic>> getNewFriendList(
      Map<String, dynamic> body) async {
    try {
      final resp =
          await _dio.post('yjy/im/a/pending/review/contact/page', data: body);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取新好友列表失败');
      }
    } catch (e) {
      throw Exception('获取新好友列表失败: $e');
    }
  }

  /// 接受新好友
  static Future<void> acceptNewFriend(Map<String, dynamic> body) async {
    try {
      final resp =
          await _dio.post('yjy/im/a/pending/review/contact/pass', data: body);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '接受好友失败');
      }
    } catch (e) {
      throw Exception('接受好友失败: $e');
    }
  }

  /// 拒绝新好友
  static Future<void> refuseNewFriend(Map<String, dynamic> body) async {
    try {
      final resp =
          await _dio.post('yjy/im/a/pending/review/contact/refuse', data: body);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '拒绝好友失败');
      }
    } catch (e) {
      throw Exception('拒绝好友失败: $e');
    }
  }

  /// 获取我的好友列表
  static Future<Map<String, dynamic>> getMyFriendList(
      Map<String, dynamic> body) async {
    try {
      final resp = await _dio.post('yjy/im/a/contact/list', data: body);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取好友列表失败');
      }
    } catch (e) {
      throw Exception('获取好友列表失败: $e');
    }
  }

  /// 获取我的群组列表
  static Future<List<dynamic>> getMyGroupList(Map<String, dynamic> body) async {
    try {
      final resp = await _dio.post('yjy/im/a/chat/group/list', data: body);
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取群组列表失败');
      }
    } catch (e) {
      throw Exception('获取群组列表失败: $e');
    }
  }

  /// 获取群组列表
  static Future<Map<String, dynamic>> getGroupList(
      bool isICreate, Map<String, dynamic> bean) async {
    try {
      final resp = await _dio.post(
        'yjy/biz/a/chat/group/list?is_i_create=$isICreate',
        data: bean,
      );
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取群组列表失败');
      }
    } catch (e) {
      throw Exception('获取群组列表失败: $e');
    }
  }

  /// 解散群组
  static Future<void> deleteGroup(String groupChatAccount) async {
    try {
      final resp = await _dio
          .get('im/a/chat/delete/groupChat?groupChatAccount=$groupChatAccount');
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '解散群组失败');
      }
    } catch (e) {
      throw Exception('解散群组失败: $e');
    }
  }

  /// 获取群成员信息
  static Future<Map<String, dynamic>> getTeamUserList(
      String groupChatAccount) async {
    try {
      final resp = await _dio.get(
          'porgan/a/enterprise/book/query/group_chat_people?groupChatAccount=$groupChatAccount');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取群成员信息失败');
      }
    } catch (e) {
      throw Exception('获取群成员信息失败: $e');
    }
  }

  /// 获取群组列表
  static Future<List<dynamic>> getTeamList(String searchName) async {
    try {
      final resp =
          await _dio.get('im/a/chat/query/getChatList?searchName=$searchName');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取群组列表失败');
      }
    } catch (e) {
      throw Exception('获取群组列表失败: $e');
    }
  }

  /// 获取好友信息
  static Future<Map<String, dynamic>> getFriendInfo(String userUuid) async {
    try {
      final resp = await _dio
          .get('porgan/a/get/enterprise/query_friend_info?userUuid=$userUuid');
      if (resp.data['code'] == 3001) {
        return resp.data['data'];
      } else {
        throw Exception(resp.data['msg'] ?? '获取好友信息失败');
      }
    } catch (e) {
      throw Exception('获取好友信息失败: $e');
    }
  }

  /// 添加好友
  static Future<void> addFriendByUuid(String puUserId) async {
    try {
      final resp = await _dio
          .get('porgan/a/enterprise/book/addFriend?puUserId=$puUserId');
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '添加好友失败');
      }
    } catch (e) {
      throw Exception('添加好友失败: $e');
    }
  }

  /// 创建群组
  static Future<void> createGroup(Map<String, dynamic> createTeamBody) async {
    try {
      final resp =
          await _dio.post('im/a/chat/createGroupChat', data: createTeamBody);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '创建群组失败');
      }
    } catch (e) {
      throw Exception('创建群组失败: $e');
    }
  }

  /// 修改群组名称
  static Future<void> updateGroupName(
      Map<String, dynamic> updateTeamNameParams) async {
    try {
      final resp = await _dio.post('im/a/chat/updateGroupChat',
          data: updateTeamNameParams);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '修改群组名称失败');
      }
    } catch (e) {
      throw Exception('修改群组名称失败: $e');
    }
  }

  /// 群组添加人员
  static Future<void> groupAddPeople(
      Map<String, dynamic> teamAddUserParams) async {
    try {
      final resp =
          await _dio.post('im/a/chat/addChatPeople', data: teamAddUserParams);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '群组添加人员失败');
      }
    } catch (e) {
      throw Exception('群组添加人员失败: $e');
    }
  }

  /// 群组删减人员
  static Future<void> groupDeletePeople(
      Map<String, dynamic> teamAddUserParams) async {
    try {
      final resp =
          await _dio.post('im/a/chat/delChatPeople', data: teamAddUserParams);
      if (resp.data['code'] != 3001) {
        throw Exception(resp.data['msg'] ?? '群组删减人员失败');
      }
    } catch (e) {
      throw Exception('群组删减人员失败: $e');
    }
  }
}
