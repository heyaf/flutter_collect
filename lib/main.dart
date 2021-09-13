import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:yay_collect/fragment_page.dart';
import 'package:yay_collect/pages/home/HomePage.dart';
import 'package:yay_collect/pages/login/UserLogin.dart';
import 'package:yay_collect/two_page.dart';
import 'one_page.dart';
import 'router/Routes.dart';

void main() {
  ///初始化并配置路由
  final router = new FluroRouter();
  Routes.configureRoutes(router);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 注册界面，onePage名称与PageRouter里名称对应
    FlutterBoost.singleton.registerPageBuilders({
      'onePage': (pageName, params, _) => OnePage(params),
    });
    FlutterBoost.singleton.registerPageBuilders({
      'twoPage': (pageName, params, _) => TwoPage(params),
    });
    FlutterBoost.singleton.registerPageBuilders({
      'userLogin': (pageName, params, _) => UserLogin(params),
    });
    FlutterBoost.singleton.registerPageBuilders({
      'fragmentPage': (pageName, params, _) => FragmentPage(params),
    });
    FlutterBoost.singleton.registerPageBuilders({
      'homePage': (pageName, params, _) => HomePage(null, param: params),
    });
    // 添加观察者，为了方便查看状态，可选设置
    FlutterBoost.singleton
        .addBoostNavigatorObserver(TestBoostNavigatorObserver());
  }

  @override
  Widget build(BuildContext context) {
    Map param;
    return MaterialApp(
      title: 'Flutter Boost example',
      // FlutterBoost初始化
      builder: FlutterBoost.init(postPush: _onRoutePushed),
      // RouteSettings
      onGenerateRoute: Routes.router.generator,
      //去除右上角debug标记
      debugShowCheckedModeBanner: false,
    );
  }

  void _onRoutePushed(
      String pageName, String uniqueId, Map params, Route route, Future _) {}
}

class TestBoostNavigatorObserver extends NavigatorObserver {
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print("flutterboost#didPush");
  }

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    print("flutterboost#didPop");
  }

  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print("flutterboost#didRemove");
  }

  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    print("flutterboost#didReplace");
  }
}
