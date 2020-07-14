import 'package:fluro/fluro.dart';
import 'package:yay_collect/pages/home/HomePage.dart';
import '../pages/login/UserLogin.dart';
import '../pages/login/UserRegist.dart';
import '../pages/login/UserResetPass.dart';
import '../pages/login/UserResetPassTwo.dart';
import '../pages/citySelect/CitySelect.dart';
class Routes {
  static Router router;
  // static String userLoginPage = '/userLoginPage';
  static String userLoginPage = '/';
  static String userRegistPage = '/userRegist';
  static String userResetPassPage = '/userresetpass';
  static String userResetPassPageTwo = '/userresetpassTwo';
  static String searchPage = '/searchPage';
  static String citySelectPage = '/citySelectPage';
  // static String citySelectPage = '/';
  // static String homePage = '/';
  static String homePage = '/homePage';

  static void configureRoutes(Router router) {
//    router.define(page1,
//        handler: Handler(handlerFunc: (context, params) => Page1()));
//    router.define(page2, handler: Handler(handlerFunc: (context, params) {
//      var message = params['message']?.first; //取出传参
//      return Page2(message);
//    }));

    ///登陆页
    router.define(userLoginPage,
        handler: Handler(handlerFunc: (context, params) => UserLogin(null)));

    ///注册页
    router.define(userRegistPage, 
        handler: Handler(handlerFunc: (context, params) => UserRegist(router)));

    ///首页
    router.define(homePage, 
        handler: Handler(handlerFunc: (context, params) => HomePage(router)));

    ///重置密码
    router.define(userResetPassPage, 
        handler: Handler(handlerFunc: (context, params) => UserResetPass(router)));  

    ///重置密码【确认密码】
    router.define(userResetPassPageTwo, 
        handler: Handler(handlerFunc: (context, params) => UserResetPassTwo(router)));

    ///城市选择
    router.define(citySelectPage, 
        handler: Handler(handlerFunc: (context, params) => CitySelect(router)));

    Routes.router = router;
  }   
}
