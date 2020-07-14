import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:yay_collect/two_page.dart';

class OnePage extends StatefulWidget {
  final Map param;

  OnePage(this.param);

  @override
  State<StatefulWidget> createState() {
    return _OnePageState();
  }

}

class _OnePageState extends State<OnePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OnePage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 如果接收到参数则显示，OneKey为传递map中的key
            Text(widget.param == null ? "未接收到参数" : widget.param["OneKey"]),
            RaisedButton(
                child: Text("FlutterOne跳转FlutterTwo"),
                onPressed: () {
                  // flutterone 跳转 fluttertwo
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new TwoPage({"TwoKey":"我是FlutterOne传过来的参数"}),
                    ),
                  );
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