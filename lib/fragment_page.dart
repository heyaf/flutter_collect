import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class FragmentPage extends StatefulWidget {
  final Map param;

  FragmentPage(this.param);

  @override
  State<StatefulWidget> createState() {
    return _FragmentPageState();
  }
}

class _FragmentPageState extends State<FragmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          "FlutterView",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ));
  }
}
