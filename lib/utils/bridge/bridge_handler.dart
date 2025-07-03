import 'dart:convert';

/// Bridge处理器接口
abstract class BridgeHandler {
  void call(dynamic data, Function(String) callback);
}

/// Bridge消息数据模型
class BridgeMessage {
  final String handlerName;
  final dynamic data; // 改为dynamic类型，支持String和Map
  final String? callbackId;

  BridgeMessage({
    required this.handlerName,
    required this.data,
    this.callbackId,
  });

  factory BridgeMessage.fromJson(Map<String, dynamic> json) {
    return BridgeMessage(
      handlerName: json['handlerName'] ?? '',
      data: json['data'], // 直接使用，不做类型转换
      callbackId: json['callbackId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'handlerName': handlerName,
      'data': data,
      if (callbackId != null) 'callbackId': callbackId,
    };
  }
}

/// Bridge响应数据模型
class BridgeResponse {
  final String status;
  final String msg;
  final dynamic data;

  BridgeResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory BridgeResponse.success({String msg = '成功', dynamic data}) {
    return BridgeResponse(
      status: 'success',
      msg: msg,
      data: data,
    );
  }

  factory BridgeResponse.error({String msg = '失败', dynamic data}) {
    return BridgeResponse(
      status: 'error',
      msg: msg,
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
