import 'dart:ui';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yay_collect/config/FontsConfig.dart';
import 'package:yay_collect/pages/home/HomePage.dart';
import 'package:yay_collect/router/CustomAnimationRouter.dart';
import 'package:yay_collect/utils/SharedPreferencesUtils.dart';
import '../../utils/ToastUtils.dart';
import 'package:device_info/device_info.dart';
import '../../config/HttpUrlServices.dart';

//登陆页面
class UserLogin extends StatefulWidget {
  final Map param;

  UserLogin(this.param);

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> with WidgetsBindingObserver {
  TextEditingController _pwdEditController;
  TextEditingController _userNameEditController;

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();

  //AMapLocation _loc;
  //按钮开关变量
  String btnLogin = '';

  // String userPhone;
  ///MEID号码
  var meid;
  @override
  void initState() {
    super.initState();

    _pwdEditController = TextEditingController();
    _userNameEditController = TextEditingController();

    _pwdEditController.addListener(() => setState(() => {}));
    _userNameEditController.addListener(() => setState(() => {}));

    getDeviceInfo();
    //初始化
    WidgetsBinding.instance.addObserver(this);
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTopWidget(context),

              // SizedBox(
              //   height: ScreenUtil().setHeight(270),
              // ),
              welcomeText(),
              SizedBox(
                height: 8,
              ),
              buildEditWidget(context),
              SizedBox(
                height: 10,
              ),
              registAndReplay(),
              SizedBox(
                height: 20,
              ),
              buildLoginButton(),
              //Text("定位成功:${_loc.formattedAddress}"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          //关闭键盘

        } else {
          //显示键盘
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //销毁
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  /// 头部
  Widget buildTopWidget(BuildContext context) {
    // 状态栏高度
    double statusBarHeight = MediaQuery.of(context).padding.top;

    double height = 140;
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
              top: 0,
              child: Container(
                width: width,
                height: 280,
                color: Colors.blue,
                child: Text('这是一个登录演示页'),
                alignment: Alignment.center,
              )),
          Positioned(
              left: (width - 36) / 2.0,
              top: statusBarHeight + 10,
              child: Text(
                '登录',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: FontsConfig.$YAYAliFont),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget welcomeText() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 145),
        height: 40,
        child: Column(
          children: <Widget>[
            Text('欢迎登录',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(36),
                    fontFamily: FontsConfig.$YAYAliFont,
                    fontWeight: FontWeight.w600)),
          ],
        ));
  }

  Widget buildEditWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          buildLoginNameTextField(),
          SizedBox(height: 20.0),
          buildPwdTextField(),
        ],
      ),
    );
  }

  Widget buildLoginNameTextField() {
    return Container(
      height: 40,
      decoration: UnderlineTabIndicator(
          borderSide:
              BorderSide(width: 0.5, color: Color.fromRGBO(237, 237, 237, 1)),
          insets: EdgeInsets.zero),
      child: Stack(
        children: <Widget>[
          // Positioned(
          //   left: 16,
          //   top: 11,
          //   width: 18,
          //   height: 18,
          //   child: Image.asset('images/login_user.png'),
          // ),
          // Positioned(
          //   left: 45,
          //   top: 10,
          //   bottom: 10,
          //   width: 1,
          //   child: Container(
          //     color: Colors.black,
          //   ),
          // ),
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            height: 30,
            child: TextField(
              controller: _userNameEditController,
              focusNode: _userNameFocusNode,
              decoration: InputDecoration(
                hintText: "请输入手机号",
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
                WhitelistingTextInputFormatter.digitsOnly, //只输入数字
                LengthLimitingTextInputFormatter(11) //限制长度
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

  Widget buildPwdTextField() {
    return Container(
        height: 40,
        decoration: UnderlineTabIndicator(
            borderSide:
                BorderSide(width: 0.5, color: Color.fromRGBO(237, 237, 237, 1)),
            insets: EdgeInsets.zero),
        child: Stack(
          children: <Widget>[
            // Positioned(
            //   left: 16,
            //   top: 11,
            //   width: 18,
            //   height: 18,
            //   child: Image.asset('images/login_pwd.png'),
            // ),
            // Positioned(
            //   left: 45,
            //   top: 10,
            //   bottom: 10,
            //   width: 1,
            //   child: Container(
            //     color: Colors.black,
            //   ),
            // ),
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              height: 30,
              child: TextField(
                controller: _pwdEditController,
                focusNode: _pwdFocusNode,
                decoration: InputDecoration(
                  hintText: "请输入密码",
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
                obscureText: true,

                /// 设置密码
                onChanged: (value) {
                  setState(() {
                    checkLoginText();
                  });
                },
              ),
            )
          ],
        ));
  }

  Widget registAndReplay() {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
      height: 20,
      child: Row(
        children: <Widget>[
          Text(
            '还没账号？',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: Color.fromRGBO(153, 153, 153, 1),
            ),
          ),
          GestureDetector(
              child: Text(
                '去注册',
                style: TextStyle(
                    // decoration: TextDecoration.underline,
                    fontSize: ScreenUtil().setSp(28),
                    color: Color.fromRGBO(0, 160, 233, 1)),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/userRegist');
                FocusScope.of(context).requestFocus(FocusNode());
              }),
          Expanded(
            child: Text(''), // 中间用Expanded控件
          ),
          GestureDetector(
              child: Text(
                '忘记密码',
                style: TextStyle(
                    // decoration: TextDecoration.underline,
                    fontSize: ScreenUtil().setSp(28),
                    color: Color.fromRGBO(0, 160, 233, 1)),
              ),
              onTap: () {
                print('测试');
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pushNamed(context, '/userresetpass');
              }),
        ],
      ),
    );
  }

  Widget imageBtn() {
    return Image.asset(
      'assets/images/login_button.png',
      fit: BoxFit.cover,
      height: 40,
      width: MediaQuery.of(context).size.width - 20,
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
            registBtnClicked();
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
                height: 20,
                child: Text(
                  '立即登录',
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
          fillColor: Colors.white,
          elevation: 0,
          disabledElevation: 0,
          highlightElevation: 0,
        ),
      ],
    );
  }

//手机号的正则验证
  bool checkPhoneNumber() {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[57])|(15[0-9])|(16[6])|(17[0-8])|(18[0-9])|(19[89]))\d{8}$');
    bool matched = exp.hasMatch(_userNameEditController.text);
    return matched;
  }

  //登录按钮是否可以点击
  void checkLoginText() {
    if (_userNameEditController.text.length < 11 ||
        _pwdEditController.text.length == 0) {
      btnLogin = '';
    } else {
      btnLogin = '123';
    }
  }

  ///立即登录按钮点击
  void registBtnClicked() {
    // ToastUtil.showSuccess(context, msg: '注册成功');
    if (_userNameEditController.text.length < 11 ||
        _pwdEditController.text.length == 0) {
      //跳转页面
      // Navigator.pushNamed(context, '/citySelectPage');
    } else if (!checkPhoneNumber()) {
      ToastUtils.showText(context, msg: '请输入正确的手机号码');
    } else if (_pwdEditController.text.length < 6) {
      // ToastUtils.showText('密码长度应在6-20位之间，请重新输入');
      ToastUtils.showText(context, msg: '密码长度应在6-20位之间，请重新输入');
    } else {
      userLogin();
    }
  }

  ///用户登录-发送登录请求
  void userLogin() async {
    try {
      Response respose;
      var param = {
        'mobilePhoneNumber': _userNameEditController.text,
        'password': _pwdEditController.text,
        'equipmentNumber': meid
      };

//    String paramStr = '?mobilePhoneNumber='+_userNameEditController.text+'&password='+_pwdEditController.text+'&equipmentNumber='+meid;
      respose =
          await Dio().get(HttpUrlservices.userLoginUrl, queryParameters: param);
      print('----------');
      print(respose.data);
      Map<String, dynamic> news = jsonDecode(respose.data);
      print(news);
      String dataValue = news['response']['data'].toString();

      if (!dataValue.contains('error')) {
        ToastUtils.showSuccess(context, msg: '登录成功');
        // Navigator.of(context).pop();
        String mobilePhoneNumber =
            news['response']['data']['mobilePhoneNumber'].toString();

        ///用户信息拼接字符串，格式为手机号+&+userID
        String userinfo =
            mobilePhoneNumber + '&' + news['response']['data']['id'].toString();

        ///以Map形式存储用户信息，key=UserInfo
        SharedPreferencesUtils.setString('userInfo', userinfo);

        ///跳转首页
        Navigator.of(context).push(CustomAnimationRouter(HomePage(null)));
      } else {
        List<String> datalist = dataValue.split('&');
        ToastUtils.showText(context, msg: datalist[1]);
      }
    } catch (e) {
      ToastUtils.showText(context, msg: e.toString());
      print('报错');
      print(e.toString());
    }
  }

  ///获取设备MEID
  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    setState(() {
      this.meid = androidDeviceInfo.androidId;
    });
    print('Running on ===> ${widget.param}');
  }

  ///获取已存储的手机号
  ///获取用户信息
  void getUserInfo() async {
    String userInfo = await SharedPreferencesUtils.getString("userInfo");
    String userPhone = userInfo.split('&')[0];

    if (userPhone.length == 4) {
      //字符串为null
    } else {
      setState(() {
        _userNameEditController.text = userPhone;
      });
    }
  }
}
