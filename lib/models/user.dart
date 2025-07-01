class User {
  String? token;
  String? userName;
  String? refreshToken;
  String? phone;
  String? account;
  String? imAccid;
  String? imToken;
  int? tokenId;
  int? tokenLifeTime;
  String? orgId;
  String? orgName;
  bool? needBindPhone;
  String? openid;
  String? userId;
  String? accountId;
  int? status;
  String? email;
  String? address;
  String? faceCollection;
  int? type;
  List<int>? userTypeList;
  String? position;
  String? joinOrgDate;
  int? hasPassword;
  String? avatar;
  bool? isRealName;
  List<dynamic>? orgList;
  List<dynamic>? roleList;

  User({
    this.token,
    this.userName,
    this.refreshToken,
    this.phone,
    this.account,
    this.imAccid,
    this.imToken,
    this.tokenId,
    this.tokenLifeTime,
    this.orgId,
    this.orgName,
    this.needBindPhone,
    this.openid,
    this.userId,
    this.accountId,
    this.status,
    this.email,
    this.address,
    this.faceCollection,
    this.type,
    this.userTypeList,
    this.position,
    this.joinOrgDate,
    this.hasPassword,
    this.avatar,
    this.isRealName,
    this.orgList,
    this.roleList,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'] as String?,
      userName: json['userName'] as String?,
      refreshToken: json['refreshToken'] as String?,
      phone: json['phone'] as String?,
      account: json['account'] as String?,
      imAccid: json['imAccid'] as String?,
      imToken: json['imToken'] as String?,
      tokenId: json['tokenId'] as int?,
      tokenLifeTime: json['tokenLifeTime'] as int?,
      orgId: json['orgId'] as String?,
      orgName: json['orgName'] as String?,
      needBindPhone: json['needBindPhone'] as bool?,
      openid: json['openid'] as String?,
      userId: json['userId'] as String?,
      accountId: json['accountId'] as String?,
      status: json['status'] as int?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      faceCollection: json['faceCollection'] as String?,
      type: json['type'] as int?,
      userTypeList:
          (json['userTypeList'] as List?)?.map((e) => e as int).toList(),
      position: json['position'] as String?,
      joinOrgDate: json['joinOrgDate'] as String?,
      hasPassword: json['hasPassword'] as int?,
      avatar: json['avatar'] as String?,
      isRealName: json['isRealName'] == null
          ? null
          : (json['isRealName'] is bool
              ? json['isRealName']
              : (json['isRealName'] == 1)),
      orgList: json['orgList'] as List?,
      roleList: json['roleList'] as List?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userName': userName,
      'refreshToken': refreshToken,
      'phone': phone,
      'account': account,
      'imAccid': imAccid,
      'imToken': imToken,
      'tokenId': tokenId,
      'tokenLifeTime': tokenLifeTime,
      'orgId': orgId,
      'orgName': orgName,
      'needBindPhone': needBindPhone,
      'openid': openid,
      'userId': userId,
      'accountId': accountId,
      'status': status,
      'email': email,
      'address': address,
      'faceCollection': faceCollection,
      'type': type,
      'userTypeList': userTypeList,
      'position': position,
      'joinOrgDate': joinOrgDate,
      'hasPassword': hasPassword,
      'avatar': avatar,
      'isRealName': isRealName,
      'orgList': orgList,
      'roleList': roleList,
    };
  }
}
