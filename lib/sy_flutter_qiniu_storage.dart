import 'dart:async';

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
  Future<bool> upload(String filepath, String token, String key) async {
    var res = await _channel.invokeMethod('upload',
        <String, String>{"filepath": filepath, "token": token, "key": key});
    return res;
  }

  /// 取消上传
  static cancelUpload() {
    _channel.invokeMethod('cancelUpload');
  }
}
