import 'package:flutter/foundation.dart';
import '../api/user_api.dart';
import '../models/user.dart';
import '../models/home_url_info.dart';
import '../services/user_service.dart';
import '../api/auth_api.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  Map<String, dynamic>? _globalConfig;
  Map<String, dynamic>? _userDetailInfo;
  Map<String, dynamic>? _imAccountInfo;
  HomeUrlInfo? _homeUrlInfo;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get globalConfig => _globalConfig;
  Map<String, dynamic>? get userDetailInfo => _userDetailInfo;
  Map<String, dynamic>? get imAccountInfo => _imAccountInfo;
  HomeUrlInfo? get homeUrlInfo => _homeUrlInfo;

  /// 初始化用户状态
  Future<void> initializeUser() async {
    print('UserProvider.initializeUser: 开始初始化用户状态');
    _isLoading = true;
    notifyListeners();

    try {
      print('UserProvider.initializeUser: 从本地存储获取用户信息');
      final user = await UserService.getUserInfo();
      print('UserProvider.initializeUser: 本地用户信息: $user');

      if (user != null && user is User && user.token != null) {
        print('UserProvider.initializeUser: 用户信息有效，设置登录状态');
        _currentUser = user as User;
        _isLoggedIn = true;

        // 初始化时获取用户详细信息
        print('UserProvider.initializeUser: 获取用户详细信息');
        await _fetchUserDetailInfo();

        // 获取保存的主页URL信息
        print('UserProvider.initializeUser: 获取保存的主页URL信息');
        await _loadHomeUrlInfo();

        print('UserProvider.initializeUser: 初始化完成，登录状态: $_isLoggedIn');
      } else {
        print('UserProvider.initializeUser: 用户信息无效或为空');
      }
    } catch (e) {
      print('UserProvider.initializeUser: 初始化用户状态失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 用户登录（完整流程）
  Future<void> login(User user) async {
    print('UserProvider.login: 开始登录流程');
    _isLoading = true;
    notifyListeners();

    try {
      // 1. 保存用户基本信息
      print('UserProvider.login: 保存用户基本信息');
      await UserService.saveUserInfo(user.toJson());
      _currentUser = user;
      _isLoggedIn = true;

      // 2. 获取全局配置
      print('UserProvider.login: 获取全局配置');
      await _fetchGlobalConfig();

      // 3. 获取用户详细信息
      print('UserProvider.login: 获取用户详细信息');
      await _fetchUserDetailInfo();

      // 4. 获取IM账号信息
      print('UserProvider.login: 获取IM账号信息');
      await _fetchImAccount();

      // 5. 获取主页URL信息
      print('UserProvider.login: 获取主页URL信息');
      await _fetchHomeUrlInfo();

      // 6. 通知登录成功
      print('UserProvider.login: 登录流程完成，通知登录成功');
      notifyLoginSuccess();
    } catch (e) {
      print('UserProvider.login: 登录流程失败: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取全局配置
  Future<void> _fetchGlobalConfig() async {
    try {
      _globalConfig = await AuthApi.getGlobalConfig();
      print('获取全局配置成功');
    } catch (e) {
      print('获取全局配置失败: $e');
    }
  }

  /// 获取用户详细信息
  Future<void> _fetchUserDetailInfo() async {
    if (_currentUser?.token == null) return;
    try {
      final v3Info = await UserApi.getUserInfo();
      // 合并token等关键信息
      final merged = {
        ..._currentUser!.toJson(),
        ...v3Info,
        // 其它你需要保留的字段
      };
      _userDetailInfo = merged;
      print("merged: $merged");
      await UserService.saveUserInfo(merged);
      print('获取用户详细信息成功');
    } catch (e) {
      print('获取用户详细信息失败: $e');
    }
  }

  /// 获取IM账号信息
  Future<void> _fetchImAccount() async {
    if (_currentUser?.token == null) return;
    try {
      _imAccountInfo =
          await AuthApi.getImAccount({'token': _currentUser!.token!});
      print('获取IM账号信息成功');

      // 这里可以初始化IM登录
      await _initImLogin();
    } catch (e) {
      print('获取IM账号信息失败: $e');
    }
  }

  /// 初始化IM登录
  Future<void> _initImLogin() async {
    if (_imAccountInfo == null) return;

    try {
      // 这里调用IM SDK的登录方法
      // 例如：await NimChatUtil.initChatLogin(_imAccountInfo!);
      print('IM登录初始化成功');
    } catch (e) {
      print('IM登录初始化失败: $e');
    }
  }

  /// 获取主页URL信息
  Future<void> _fetchHomeUrlInfo() async {
    if (_currentUser?.token == null) return;

    try {
      // 这里应该调用实际的API获取主页URL信息
      // 暂时使用模拟数据
      await Future.delayed(const Duration(milliseconds: 500));

      // 检查是否有保存的主页URL信息
      await _loadHomeUrlInfo();
    } catch (e) {
      print('获取主页URL信息失败: $e');
    }
  }

  /// 加载保存的主页URL信息
  Future<void> _loadHomeUrlInfo() async {
    try {
      final savedInfo = await UserService.getHomeUrlInfo();
      if (savedInfo != null) {
        _homeUrlInfo = savedInfo;
        print('加载保存的主页URL信息成功');
      }
    } catch (e) {
      print('加载保存的主页URL信息失败: $e');
    }
  }

  /// 保存主页URL信息
  Future<void> saveHomeUrlInfo(HomeUrlInfo homeUrlInfo) async {
    try {
      await UserService.saveHomeUrlInfo(homeUrlInfo);
      _homeUrlInfo = homeUrlInfo;
      notifyListeners();
      print('保存主页URL信息成功');
    } catch (e) {
      print('保存主页URL信息失败: $e');
      rethrow;
    }
  }

  /// 获取主页URL信息（供外部调用）
  HomeUrlInfo? getHomeUrlInfo() {
    return _homeUrlInfo;
  }

  /// 检查是否有主页URL信息
  bool get hasHomeUrlInfo {
    final hasInfo = _homeUrlInfo != null &&
        _homeUrlInfo!.indexUrl != null &&
        _homeUrlInfo!.indexUrl!.isNotEmpty;
    print('UserProvider.hasHomeUrlInfo: $_homeUrlInfo, 结果: $hasInfo');
    return hasInfo;
  }

  /// 通知登录成功
  void notifyLoginSuccess() {
    // 使用Provider的notifyListeners()通知所有监听者
    notifyListeners();

    // 这里可以添加EventBus事件通知
    // EventBus.getDefault().post(LoginSuccessEvent());

    print('登录成功事件已发送');
  }

  /// 用户登出
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await UserService.clearUserInfo();
      await UserService.clearHomeUrlInfo();
      _currentUser = null;
      _isLoggedIn = false;
      _globalConfig = null;
      _userDetailInfo = null;
      _imAccountInfo = null;
      _homeUrlInfo = null;
    } catch (e) {
      print('清除用户信息失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 更新用户信息
  Future<void> updateUserInfo(User user) async {
    try {
      // 合并token等关键信息
      final merged = {
        ..._userDetailInfo!,
        ...user.toJson(),
        // 其它你需要保留的字段
      };
      _userDetailInfo = merged;
      print("merged: $merged");
      await UserService.saveUserInfo(merged);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      print('更新用户信息失败: $e');
      rethrow;
    }
  }

  /// 检查是否需要绑定手机号
  bool get needBindPhone {
    return _currentUser?.needBindPhone == true;
  }

  /// 获取用户token
  String? get token {
    return _currentUser?.token;
  }

  /// 获取用户名
  String? get userName {
    return _currentUser?.userName;
  }

  /// 获取组织名称
  String? get orgName {
    return _currentUser?.orgName;
  }

  /// 获取用户详细信息中的特定字段
  String? getUserDetailField(String field) {
    return _userDetailInfo?[field]?.toString();
  }

  /// 获取全局配置中的特定字段
  String? getGlobalConfigField(String field) {
    return _globalConfig?[field]?.toString();
  }
}

extension on Map<String, dynamic> {
  get token => null;
}
