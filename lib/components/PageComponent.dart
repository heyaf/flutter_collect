import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../utils/CustomScreenUtil.dart';
import '../config/FontsConfig.dart';

///返回按钮组件
class PageComponent {
  BuildContext _context;

  PageComponent(BuildContext context) {
    CustomScreenUtil.init(context);
    this._context = context;
  }

  //移除所有路由
  void removeAllRouter(BuildContext context, Widget widgetPage) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widgetPage),
        //除当前外的所有路由都置为null
        (route) => route == null);
  }

  ///返回按钮(参数1context上下文，参数2图片宽，参数3图片高，参数4图片路径,参数5动画类型)
  Widget returnIcon(FluroRouter router) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.fromLTRB(8, 56, 0, 0),
        child: Image.asset('assets/images/dylb_NaviBar_return.png',
            fit: BoxFit.cover,
            height: CustomScreenUtil.setWidth(32),
            width: CustomScreenUtil.setWidth(32)),
      ),
      onTap: () {
        router.pop(_context);
      },
    );
  }

  //页面标题文字组件
  Widget pageTitleText(BuildContext context, String titleText) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.fromLTRB(
          CustomScreenUtil.setWidth(26), CustomScreenUtil.setHeight(21), 0, 0),
      color: Colors.white,
      child: Text(
        '${titleText}',
        style: TextStyle(
          fontFamily: FontsConfig.$YAYAliFont,
          fontSize: CustomScreenUtil.setFontSize(28),
          color: Color.fromRGBO(51, 51, 51, 1),
          decoration: TextDecoration.none,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
