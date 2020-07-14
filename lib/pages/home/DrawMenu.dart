import 'package:fluro/src/router.dart';
import 'package:flutter/material.dart';
import 'package:yay_collect/config/FontsConfig.dart';
import 'package:yay_collect/pages/login/UserLogin.dart';
import 'package:yay_collect/utils/CustomScreenUtil.dart';
import 'package:yay_collect/utils/SharedPreferencesUtils.dart';

import '../../utils/ToastUtils.dart';

class DrawMenu extends StatefulWidget {
  Router router;
  String userData;
  DrawMenu(Router router, {Key key}) {
    this.router = router;
  }

  @override
  _DrawMenuState createState() => _DrawMenuState();
}

class _DrawMenuState extends State<DrawMenu> {
  String userInfo;
  _DrawMenuState();

  ///获取用户信息
  void getUserInfo() async {
    String userInfo = await SharedPreferencesUtils.getString("userInfo");
    setState(() {
      this.userInfo = userInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: CustomScreenUtil.setHeight(120),
              margin: EdgeInsets.only(top: CustomScreenUtil.setWidth(10)),
              child: Row(
                children: <Widget>[
                  ///头像
                  Container(
                    width: CustomScreenUtil.setWidth(50),
                    height: CustomScreenUtil.setWidth(50),
                    margin: EdgeInsets.only(
                      left: CustomScreenUtil.setWidth(20),
                    ),
                    child: Image.asset(
                      'assets/images/tx.png',
                      fit: BoxFit.cover,
                      width: CustomScreenUtil.setWidth(150),
                      height: CustomScreenUtil.setWidth(150),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.blue,
                    ),
                  ),

                  ///登陆状态,如果已登录就显示手机号，未登录就显示未登录
                  Container(
                    margin:
                        EdgeInsets.only(left: CustomScreenUtil.setWidth(14)),
                    child: Text(userInfo.split('&')[0],
                        style: TextStyle(
                            fontFamily: FontsConfig.$YAYAliFont,
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontSize: CustomScreenUtil.setFontSize(16),
                            fontWeight: FontWeight.w700)),
                  ),

                  ///身份信息显示【目前只有采集员身份】
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment(1, 0),
                          child: Image.asset('assets/images/bs_bg.png'),
                        ),
                        Align(
                          alignment: Alignment(0.5, 0),
                          child: Text('采集员',
                              style: TextStyle(
                                  fontSize: CustomScreenUtil.setFontSize(12),
                                  color: Colors.white,
                                  fontFamily: FontsConfig.$YAYAliFont)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(height: 1, color: Color.fromRGBO(245, 245, 245, 1)),
            //修改密码点击事件
            GestureDetector(
              child: Container(
                height: CustomScreenUtil.setHeight(50),
                margin: EdgeInsets.only(left: 21, top: 21),
                color: Color.fromRGBO(245, 245, 245, 0),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/grzx_xgmm.png',
                        fit: BoxFit.fill,
                        width: CustomScreenUtil.setWidth(14),
                        height: CustomScreenUtil.setHeight(18)),
                    Container(
                      child: Text(
                        '修改密码',
                        style: TextStyle(
                            fontSize: CustomScreenUtil.setFontSize(14),
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontFamily: FontsConfig.$YAYAliFont),
                      ),
                      margin: EdgeInsets.only(left: 12),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(
                          right: CustomScreenUtil.setWidth(20),
                        ),
                        alignment: Alignment.centerRight,
                        child: Image.asset('assets/images/jqxz_jt.png',
                            fit: BoxFit.cover,
                            width: CustomScreenUtil.setWidth(6),
                            height: CustomScreenUtil.setHeight(12)),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/userresetpass');
              },
            )
          ],
        ),
        GestureDetector(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0.0, 0.96),
                child: Image.asset(
                  'assets/images/login_button_bg.png',
                  fit: BoxFit.fill,
                  width: CustomScreenUtil.setWidth(240),
                  height: CustomScreenUtil.setHeight(45),
                ),
              ),
              Align(
                  alignment: Alignment(0, 0.93),
                  child: Text(
                    '退出登录',
                    style: TextStyle(
                        fontSize: CustomScreenUtil.setFontSize(14),
                        color: Colors.white,
                        fontFamily: FontsConfig.$YAYAliFont),
                  )),
            ],
          ),
          onTap: () {
            //返回根路由
            ToastUtils.showSuccess(context, msg: '退出成功');
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => UserLogin(null)),
                //除当前外的所有路由都置为null
                (route) => route == null);
          },
        )
      ],
    ));
  }
}
