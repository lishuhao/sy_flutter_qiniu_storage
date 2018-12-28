# sy_flutter_qiniu_storage

七牛云对象存储SDK，兼容iOS和Android
- 上传大文件
- 进度监听
- 取消上传

### 官方文档
- [iOS](https://developer.qiniu.com/kodo/sdk/1240/objc)
- [Android](https://developer.qiniu.com/kodo/sdk/1236/android)

### 使用方法

#### iOS集成
无需任何操作

#### Android集成
无需任何操作

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _process = 0.0;

  @override
  void initState() {
    super.initState();
  }

  _onUpload() async {
    String token = '从服务端获取的token';
    File file = await ImagePicker.pickVideo(source: ImageSource.camera);
    if (file == null) {
      return;
    }
    final syStorage = new SyFlutterQiniuStorage();
    //监听上传进度
    syStorage.onChanged().listen((dynamic percent) {
      double p = percent;
      setState(() {
        _process = p;
      });
      print(percent);
    });

    String key = DateTime.now().millisecondsSinceEpoch.toString() +
        '.' +
        file.path.split('.').last;
    //上传文件
    bool result = await syStorage.upload(file.path, token, key);
    print(result);//true 上传成功，false失败
  }

  //取消上传
  _onCancel() {
    SyFlutterQiniuStorage.cancelUpload();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('七牛云存储SDK demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              LinearProgressIndicator(
                value: _process,
              ),
              RaisedButton(
                child: Text('上传'),
                onPressed: _onUpload,
              ),
              RaisedButton(
                child: Text('取消上传'),
                onPressed: _onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

##
其它Flutter Plugin
- [sy_flutter_widgets](https://github.com/lishuhao/sy_flutter_widgets)
- [支付宝](https://github.com/lishuhao/sy_flutter_alipay)
- [微信支付](https://github.com/lishuhao/sy_flutter_wechat)