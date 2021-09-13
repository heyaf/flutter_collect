// import 'dart:html';
import 'dart:ui';
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:yay_collect/config/FontsConfig.dart';
import '../../config/HttpUrlServices.dart';
import '../../utils/ToastUtils.dart';

class UserResetPassTwo extends StatefulWidget {
  FluroRouter router;
  UserResetPassTwo(FluroRouter router, {Key key}) {
    this.router = router;
  }

  @override
  _UserResetPassTwoState createState() => _UserResetPassTwoState();
}

class _UserResetPassTwoState extends State<UserResetPassTwo> {
  Router router;

  ///手机号
  TextEditingController _passOneEditController;

  /// 验证码
  TextEditingController _passTwoEditController;

  final FocusNode _passOneFocusNode = FocusNode();
  final FocusNode _passTwoFocusNode = FocusNode();

//按钮开关变量
  String btnLogin = '';

  @override
  void initState() {
    super.initState();
    // _userNameEditController = TextEditingController();
    _passOneEditController = TextEditingController();
    _passTwoEditController = TextEditingController();

    // _userNameEditController.addListener(() => setState(() => {}));
    _passOneEditController.addListener(() => setState(() => {}));
    _passTwoEditController.addListener(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    final phoneMessage = ModalRoute.of(context).settings.arguments;
    print(phoneMessage);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return Material(
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Column(
        children: <Widget>[
          appbarUI(),
          phoneIntroduceText(),
          userPassTextFileUI(),
          buildLoginButton()
        ],
      ),
    );
  }

  Widget appbarUI() {
    // 状态栏高度
    // 状态栏高度
    // double statusBarHeight = MediaQuery.of(context).padding.top;
    double statusBarHeight = 0;
    double height = ScreenUtil().setHeight(statusBarHeight + 96);
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Stack(
        overflow: Overflow.visible, // 超出部分显示
        children: <Widget>[
          Positioned(
            left: 0,
            top: statusBarHeight,
            child: IconButton(
              icon: Image.asset('assets/images/zc_back.png'),
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ),
          Positioned(
              left: (width - 100) / 2.0,
              right: (width - 100) / 2.0,
              top: statusBarHeight + 10,
              child: Text(
                '重置密码',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(36),
                    fontFamily: FontsConfig.$YAYAliFont),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget phoneIntroduceText() {
    return Container(
        height: 40,
        width: MediaQuery.of(context).size.width - 30,
        margin: EdgeInsets.only(left: 5, top: 0),
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/xh.png',
              fit: BoxFit.cover,
              width: 5,
              height: 5,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '密码由6-20位英文字母、数字与特殊字符组成',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontsConfig.$YAYAliFont,
                  color: Color.fromRGBO(179, 179, 179, 1)),
              textAlign: TextAlign.left,
            ),
          ],
        ));
  }

  ///设置密码-两次
  Widget userPassTextFileUI() {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          userPassTextField(),
          makeSureuserPassTextField(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 12,
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
        ],
      ),
    );
  }

  ///输入密码
  Widget userPassTextField() {
    return Container(
      height: 48,
      decoration: UnderlineTabIndicator(
          borderSide:
              BorderSide(width: 0.5, color: Color.fromRGBO(237, 237, 237, 1)),
          insets: EdgeInsets.zero),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 15,
            right: 15,
            top: 10,
            height: 30,
            child: TextField(
              textAlign: TextAlign.left,
              controller: _passOneEditController,
              focusNode: _passOneFocusNode,
              decoration: InputDecoration(
                hintText: "请输入新密码",
                hintStyle: TextStyle(
                    fontFamily: FontsConfig.$YAYAliFont,
                    fontSize: ScreenUtil().setSp(28),
                    color: Color.fromRGBO(179, 179, 179, 1)),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontFamily: FontsConfig.$YAYAliFont),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter(RegExp(
                    "[a-zA-Z]|[!\"#\$%&'()*+,-./:;<=>?@^_`{|}~\\]|[0-9]")),
                LengthLimitingTextInputFormatter(20) //限制长度
              ],
              onChanged: (value) {
                setState(() {
                  checkLoginText();
                });
              },
            ),
          )
        ],
      ),
    );
  }

  ///输入密码
  Widget makeSureuserPassTextField() {
    return Container(
      height: 48,
      decoration: UnderlineTabIndicator(
          borderSide:
              BorderSide(width: 0.5, color: Color.fromRGBO(237, 237, 237, 1)),
          insets: EdgeInsets.zero),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 15,
            right: 15,
            top: 10,
            height: 30,
            child: TextField(
              textAlign: TextAlign.left,
              controller: _passTwoEditController,
              focusNode: _passTwoFocusNode,
              decoration: InputDecoration(
                hintText: "请再次确认密码",
                hintStyle: TextStyle(
                    fontFamily: FontsConfig.$YAYAliFont,
                    fontSize: ScreenUtil().setSp(28),
                    color: Color.fromRGBO(179, 179, 179, 1)),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontFamily: FontsConfig.$YAYAliFont),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter(RegExp(
                    "[a-zA-Z]|[!\"#\$%&'()*+,-./:;<=>?@^_`{|}~\\]|[0-9]")),
                LengthLimitingTextInputFormatter(20) //限制长度
              ],
              onChanged: (value) {
                setState(() {
                  checkLoginText();
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    //image图片
    String unselectImage = 'assets/images/login_button_bg.png';
    String canselectImage = 'assets/images/login_button.png';
    return Stack(
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {
            checkBtnClicked();
          },
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    btnLogin == '' ? '$canselectImage' : '$unselectImage',
                    fit: BoxFit.cover,
                    height: 40,
                    width: MediaQuery.of(context).size.width - 30,
                  ),
                ],
              ),
              Positioned(
                left: 0,
                top: 10,
                right: 0,
                height: ScreenUtil().setHeight(40),
                child: Text(
                  '完成',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: FontsConfig.$YAYAliFont,
                      fontSize: ScreenUtil().setSp(28)),
                ),
              ),
            ],
          ),
          fillColor: Colors.transparent,
          elevation: 0,
          disabledElevation: 0,
          highlightElevation: 0,
        ),
      ],
    );
  }

  //按钮是否可以点击
  void checkLoginText() {
    if (_passOneEditController.text.length == 0 ||
        _passTwoEditController.text.length == 0) {
      btnLogin = '';
    } else {
      btnLogin = '123';
    }
  }

  //完成按钮点击
  void checkBtnClicked() {
    if (_passOneEditController.text.length == 0 ||
        _passTwoEditController.text.length == 0) {
    } else if (_passOneEditController.text
            .compareTo(_passTwoEditController.text) !=
        0) {
      ToastUtils.showText(context, msg: '两次密码输入不一致，请重新输入');
    } else if (_passOneEditController.text.length < 6) {
      ToastUtils.showText(context, msg: '密码长度应在6-20位之间，请重新输入');
    } else {
      updateUserinfo();
    }
  }

// 更新用户信息
  void updateUserinfo() async {
    final phoneMessage = ModalRoute.of(context).settings.arguments;
    try {
      Response respose;
      var data = {
        'mobilePhoneNumber': phoneMessage,
        'password': _passOneEditController.text,
      };
      respose = await Dio().post(HttpUrlservices.updateUserInfo, data: data);
      Map<String, dynamic> news = jsonDecode(respose.data);
      print(news);
      String dataValue = news['response']['data'].toString();
      if (dataValue.contains('success')) {
        // var phoneData = {'Phone':_phoneNumEditController.text};
        ToastUtils.showSuccess(context, msg: '重置密码成功');
        FocusScope.of(context).requestFocus(FocusNode());

        Navigator.pushNamed(context, '/');
      } else {
        List<String> datalist = dataValue.split('&');
        ToastUtils.showText(context, msg: datalist[1]);
      }
    } catch (e) {
      print(e);
    }
  }
}
