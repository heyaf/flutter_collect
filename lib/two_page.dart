import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class TwoPage extends StatefulWidget {
  final Map param;

  TwoPage(this.param);

  @override
  State<StatefulWidget> createState() {
    return _TwoPageState();
  }
}

class _TwoPageState extends State<TwoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TwoPage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 如果接收到参数则显示，OneKey为传递map中的key
            Text(widget.param == null ? "未接收到参数" : widget.param["TwoKey"]),
            RaisedButton(
                child: Text("FlutterTwo跳转Android地图"),
                onPressed: () {
                  // url://nativePage为PageRouter界面定义的，flutter调起Android界面
                  FlutterBoost.singleton.open("url://nativePage",
                      urlParams: {"native": "我是FlutterTwo参数"});
                }),
            RaisedButton(
                child: Text("关闭当前界面"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ),
      ),
    );
  }
}