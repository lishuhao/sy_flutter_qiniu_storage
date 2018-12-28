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
    //String token = '从服务端获取的token';
    String token =
        'qd68lK_H3V2K8TTOCamgSCAwy2r6BddZKvYu3SGO:-YNVoHhTjc6wSlxLluh_hFBA2gA=:eyJzY29wZSI6InN5LWJ1Y2tldCIsImRlYWRsaW5lIjoxNTQ1OTkzNTAzLCJwZXJzaXN0ZW50T3BzIjoidmZyYW1lL2pwZy9vZmZzZXQvNy93LzQ4MC9oLzM2MHxzYXZlYXMvYzNrdFluVmphMlYwT2pFeU16UXpMbXB3Wnc9PSJ9';
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
    print(result); //true 上传成功，false失败
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
