// API索引文件 - 统一导出所有API类

export 'auth_api.dart';
export 'user_api.dart';
export 'common_config_api.dart';
export 'im_api.dart';
export 'cloud_api.dart';
export 'user_management_api.dart';
export 'file_api.dart';

/// API使用示例：
/// 
/// ```dart
/// import 'package:unified_front_end/api/api_index.dart';
/// 
/// // 使用认证API
/// final userInfo = await AuthApi.loginWithCode(phone, code, publicKey);
/// 
/// // 使用IM API
/// await ImApi.addFriend(addFriendParam);
/// 
/// // 使用云服务API
/// final homeInfo = await CloudApi.getHomeUrlInfo();
/// 
/// // 使用用户管理API
/// await UserManagementApi.updateMe(updateParam);
/// 
/// // 使用文件API
/// await FileApi.uploadFile(description, file);
/// ``` 