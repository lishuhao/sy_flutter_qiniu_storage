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
        'l9i6L16EqkGZa-9Nn4FQqofY9xMlfN9APObA1cI8:Mf77SjPSVYb_kCkVSPVM9ler9Po=:eyJmc2l6ZUxpbWl0IjoxMDAwMDAwMCwibWltZUxpbWl0IjoiaW1hZ2VcLyoiLCJmb3JjZVNhdmVLZXkiOnRydWUsInNhdmVLZXkiOiJlNmE4YmYzMzFlMDBhNWRlY2VkZjVlMGIxNGRhZWU1MC5wbmciLCJyZXR1cm5Cb2R5Ijoie1wiYmFzZV9uYW1lXCI6XCJlNmE4YmYzMzFlMDBhNWRlY2VkZjVlMGIxNGRhZWU1MFwiLFwiZmlsZW5hbWVcIjpcImU2YThiZjMzMWUwMGE1ZGVjZWRmNWUwYjE0ZGFlZTUwLnBuZ1wiLFwidXJsXCI6XCJodHRwczpcXFwvXFxcL2NlY2VtYWluLnh4d29sby5jb21cXFwvZTZhOGJmMzMxZTAwYTVkZWNlZGY1ZTBiMTRkYWVlNTAucG5nXCJ9Iiwic2NvcGUiOiJjZWNlIiwiZGVhZGxpbmUiOjMxODAyMjU5MzB9';
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
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
    var result = await syStorage.upload(file.path, token, key);
    print(result);
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
