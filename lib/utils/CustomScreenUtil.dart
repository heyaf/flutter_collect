import 'package:flutter_screenutil/flutter_screenutil.dart';

//屏幕适配工具类
class CustomScreenUtil {
  //初始化屏幕适配
  static init(context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
  }

  //设置高度
  static setHeight(double height) {
    return ScreenUtil().setHeight(height);
  }

  //设置宽度
  static setWidth(double width) {
    return ScreenUtil().setWidth(width);
  }

  //设置字体 allowFontScalingSelf是false不跟随系统改变字体大小
  static setFontSize(double fontSize) {
    return ScreenUtil().setSp(fontSize, allowFontScalingSelf: false);
  }

  ///获取当前设备宽度
  static getCurrentScreenWidthDp() {
    return ScreenUtil.screenWidthDp;
  }

  ///获取当前设备高度
  static getCurrentScreenHeightDp() {
    return ScreenUtil.screenHeightDp;
  }
}
