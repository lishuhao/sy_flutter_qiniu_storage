import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

typedef onData = void Function(dynamic event);

class SyFlutterQiniuStorage {
  static const MethodChannel _channel =
      const MethodChannel('sy_flutter_qiniu_storage');
  static const EventChannel _eventChannel =
      const EventChannel('sy_flutter_qiniu_storage_event');

  Stream _onChanged;

  Stream onChanged() {
    if (_onChanged == null) {
      _onChanged = _eventChannel.receiveBroadcastStream();
    }
    return _onChanged;
  }

  ///上传
  ///
  /// key 保存到七牛的文件名
  Future<UploadResult> upload(String filepath, String token, String key) async {
    var res = await _channel.invokeMethod('upload',
        <String, String>{"filepath": filepath, "token": token, "key": key});

    return UploadResult.fromJson(json.decode(res));
  }

  /// 取消上传
  static cancelUpload() {
    _channel.invokeMethod('cancelUpload');
  }
}

//上传结果
class UploadResult {
  //是否成功
  bool success;

  //错误信息
  String error;

  //客户端指定的key
  String key;

  //上传成功后，自定义七牛云最终返回給上传端的数据
  //七牛上传策略 https://developer.qiniu.com/kodo/manual/1206/put-policy
  Map<String, dynamic> result;

  UploadResult.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    error = json['error'] ?? '';
    key = json['key'] ?? '';
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'key': key,
      'error': error,
      'result': result,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
