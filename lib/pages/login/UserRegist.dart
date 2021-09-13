// import 'dart:html';
import 'dart:ui';
// import 'package:flutter_baidu_map/flutter_baidu_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:yay_collect/config/FontsConfig.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:device_info/device_info.dart';
import '../../config/HttpUrlServices.dart';
import '../../utils/ToastUtils.dart';

class UserRegist extends StatefulWidget {
  FluroRouter router;
  UserRegist(FluroRouter router, {Key key}) {
    this.router = router;
    this.countdown = 60;
  }

  /// 倒计时的秒数，默认60秒。
  int countdown;

  @override
  _UserRegistState createState() => _UserRegistState();
}

class _UserRegistState extends State<UserRegist> {
  Router router;

  ///用户姓名
  // TextEditingController _userNameEditController;
  ///手机号
  TextEditingController _phoneNumEditController;

  /// 验证码
  TextEditingController _phoneCodeEditController;

  ///密码
  TextEditingController _passWordEditController;

  ///密码
  TextEditingController _passWordTwoEditController;

  // final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _phoneNumFocusNode = FocusNode();
  final FocusNode _phoneCodeFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordTwoFocusNode = FocusNode();

  ///MEID号码
  var meid;
  //按钮开关变量
  String btnLogin = '';

  bool _isAvailableGetVCode = true; //是否可以获取验证码，默认为`false`
  String _verifyStr = '获取验证码';

  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  ///获取的验证码
  String getedCode = '';

  ///获取验证码时候的电话
  String codePhone = '';

  static String log = "";

  @override
  void initState() {
    super.initState();
    // _userNameEditController = TextEditingController();
    _phoneNumEditController = TextEditingController();
    _phoneCodeEditController = TextEditingController();
    _passWordEditController = TextEditingController();
    _passWordTwoEditController = TextEditingController();

    // _userNameEditController.addListener(() => setState(() => {}));
    _phoneNumEditController.addListener(() => setState(() => {}));
    _phoneCodeEditController.addListener(() => setState(() => {}));
    _passWordEditController.addListener(() => setState(() => {}));
    _passWordTwoEditController.addListener(() => setState(() => {}));

    _seconds = widget.countdown;
    getDeviceInfo();
  }

//  static getLocation() async {
//    ///查看当前定位权限的状态
//    var status = await Permission.location.status;
//
//    ///定位权限未开启
//    if (status == PermissionStatus.permanentlyDenied) {
//      ///提示弹窗打开手机设置页面
//      ///openAppSettings();
//      return "error&定位权限未开启，请到设置中打开定位权限";
//    }
//
//    //还没有请求过权限（true：没有请求过权限，false:已经请求过权限）
//    if (!status.isUndetermined) {
//      await Permission.location.request().isGranted;
//    }
//
//    BaiduLocation location = await FlutterBaiduMap.getCurrentLocation();
//    print("==经度、纬度==>${location.latitude},${location.longitude}");
//    ToastUtils.yayShowFutterToast(
//        "==经度、纬度==>${location.latitude},${location.longitude}");
//    log = "${location.latitude},${location.longitude}";
////    return "${location.longitude}&${location.latitude}";
//  }

  @override
  Widget build(BuildContext context) {
//    getLocation();
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Material(
            color: Color.fromRGBO(245, 245, 245, 1),
            child: Column(
              children: <Widget>[
                appbarUI(),
                headerUI(),
                phoneCodeUI(context),
                userPassTextFileUI(),
                meidCodeUI(),
                buildLoginButton(),
              ],
            ),
          ),
        ));
  }

  Widget appbarUI() {
    // 状态栏高度
    // 状态栏高度
    // double statusBarHeight = MediaQuery.of(context).padding.top;
    double statusBarHeight = 0;
    double height = ScreenUtil().setHeight(statusBarHeight + 106);
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
                color: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent

                //  onPressed: () => ,

                ),
          ),
          Positioned(
              left: (width - 36) / 2.0,
              top: statusBarHeight + 10,
              child: Text(
                '注册',
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

  Widget headerUI() {
    double height = ScreenUtil().setHeight(240);
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Image.asset(
            'assets/images/txxx.png',
            fit: BoxFit.cover,
            width: width,
            height: ScreenUtil().setHeight(240),
          ),
          Positioned(
            top: ScreenUtil().setHeight(224),
            left: 0,
            child: Container(
              width: width,
              height: ScreenUtil().setHeight(13) * 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///手机号+验证码UI
  Widget phoneCodeUI(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          buildphoneNumTextField(),
          SizedBox(height: 0.0),
          buildCodeTextField(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 12,
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
        ],
      ),
    );
  }

//输入手机号
  Widget buildphoneNumTextField() {
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
            top: 11,
            width: 80,
            height: 18,
            child: Text(
              '手机号',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontsConfig.$YAYAliFont,
                  color: Colors.black),
            ),
          ),
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
            left: 120,
            right: 15,
            top: 10,
            height: 30,
            child: TextField(
              textAlign: TextAlign.right,
              controller: _phoneNumEditController,
              focusNode: _phoneNumFocusNode,
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

                  // ToastUtil.showSuccess(context, msg: '注册成功');
                });
              },
            ),
          )
        ],
      ),
    );
  }

  ///获取验证码
  Widget buildCodeTextField() {
    double width = MediaQuery.of(context).size.width;

    return Container(
        height: 48,
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

            Positioned(
              left: 15,
              right: 120,
              top: 20,
              height: 20,
              child: TextField(
                controller: _phoneCodeEditController,
                focusNode: _phoneCodeFocusNode,
                decoration: InputDecoration(
                  hintText: "请输入验证码",
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
                  LengthLimitingTextInputFormatter(6) //限制长度
                ],
                onChanged: (value) {
                  setState(() {
                    checkLoginText();
                  });
                },
              ),
            ),
            Positioned(
              // right: width-15,
              left: width - 115,
              top: 10,
              // bottom: 10,
              child: Container(
                  width: 100,
                  height: 28,
                  decoration: new BoxDecoration(
                    border: new Border.all(
                        color: _isAvailableGetVCode
                            ? Color(0xFF47CCA0)
                            : Color(0xFFCCCCCC),
                        width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: FlatButton(
                    // disabledColor: Color(0xFFCCCCCC),
                    onPressed: _seconds == widget.countdown
                        ? () {
                            if (checkPhoneNumber()) {
                              _startTimer();
                              print('1111');
                              gettestPhoneCode().then((data) {
                                // print('2222');
                                // Map<String, dynamic> map = jsonDecode(data);
                                // String dataValue = map['response']['dada'];
                                // print('222233'+dataValue);
                                // if(dataValue.contains('success')){
                                //   getedCode= dataValue.substring(dataValue.length-6,6);
                                //   codePhone = _phoneNumEditController.text.toString();
                                //   print('获取的验证码'+getedCode);
                                // }
                              });
                            } else {
                              ToastUtils.showText(context, msg: '请输入正确的手机号码');
                            }
                          }
                        : null,
                    child: Text(
                      '$_verifyStr',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: _isAvailableGetVCode
                            ? Color(0xFF47CCA0)
                            : Color(0xFFCCCCCC),
                      ),
                    ),
                  )),
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
            top: 11,
            width: 80,
            height: 18,
            child: Text(
              '设置密码',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontsConfig.$YAYAliFont,
                  color: Colors.black),
            ),
          ),
          Positioned(
            left: 120,
            right: 15,
            top: 10,
            height: 30,
            child: TextField(
              textAlign: TextAlign.right,
              controller: _passWordEditController,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                hintText: "请输入登录密码",
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
            top: 11,
            width: 80,
            height: 18,
            child: Text(
              '确认密码',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontsConfig.$YAYAliFont,
                  color: Colors.black),
            ),
          ),
          Positioned(
            left: 120,
            right: 15,
            top: 10,
            height: 30,
            child: TextField(
              textAlign: TextAlign.right,
              controller: _passWordTwoEditController,
              focusNode: _passwordTwoFocusNode,
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

  ///Meid号
  Widget meidCodeUI() {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0),
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Column(
        children: <Widget>[
          meidTextField(),
          meidIntoduce(),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
        ],
      ),
    );
  }

  ///MEID
  Widget meidTextField() {
    return Container(
        margin: EdgeInsets.only(left: 0, right: 0),
        color: Colors.white,
        height: 48,
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 48,
          child: Row(
            children: <Widget>[
              Text(
                '手机MEID号',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontsConfig.$YAYAliFont,
                    color: Color.fromRGBO(51, 51, 51, 1)),
              ),
              Expanded(child: Text('')),
              Text(
                '${meid}',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontsConfig.$YAYAliFont,
                    color: Color.fromRGBO(102, 102, 102, 1)),
              ),
            ],
          ),
        ));
  }

  Widget meidIntoduce() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      height: 30,
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/xh.png',
            fit: BoxFit.cover,
            width: 5,
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'MEID号为手机设备码与账号的关系',
              style: TextStyle(
                color: Color.fromRGBO(153, 153, 153, 1),
                fontSize: 12,
                fontFamily: FontsConfig.$YAYAliFont,
              ),
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
                height: ScreenUtil().setHeight(40),
                child: Text(
                  '提交信息',
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

  ///开始倒计时
  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      _isAvailableGetVCode = false;
      _verifyStr = '已发送(${_seconds}s)';
      if (_seconds == 0) {
        _verifyStr = '重新获取';
        _isAvailableGetVCode = true;
        _seconds = widget.countdown;
        _cancelTimer();
      }
      setState(() {});
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  ///获取设备MEID
  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    setState(() {
      this.meid = androidDeviceInfo.androidId;
    });
    // print('Running on ===> ${androidDeviceInfo.androidId}');
  }

  //手机号的正则验证
  bool checkPhoneNumber() {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[57])|(15[0-9])|(16[6])|(17[0-8])|(18[0-9])|(19[89]))\d{8}$');
    bool matched = exp.hasMatch(_phoneNumEditController.text);
    return matched;
  }

  //登录按钮是否可以点击
  void checkLoginText() {
    if (_phoneNumEditController.text.length < 11 ||
        _phoneCodeEditController.text.length == 0 ||
        _passWordEditController.text.length == 0 ||
        _passWordTwoEditController.text.length == 0) {
      btnLogin = '';
    } else {
      btnLogin = '123';
    }
  }

  //发送验证码
  Future gettestPhoneCode() async {
    try {
      Response respose;
      var data = {'phoneNo': _phoneNumEditController.text};
      respose =
          await Dio().get(HttpUrlservices.getPhoneCode, queryParameters: data);

      print(respose.data);
      Map<String, dynamic> news = jsonDecode(respose.data);
      print(news);
      String dataValue = news['response']['data'].toString();
      print('00' + dataValue);

      if (dataValue.contains('success')) {
        List<String> datalist = dataValue.split('&');
        getedCode = datalist[2];
        codePhone = _phoneNumEditController.text.toString();
        print('获取的验证码' + getedCode);
      }
      return respose.data;
    } catch (e) {
      print(e);
    }
  }

  ///注册按钮点击
  void registBtnClicked() async {
//    getLocation();
//    var status = await Permission.location.status;
//    ToastUtils.yayShowFutterToast("==经度、纬度==>${status}");
    if (_phoneNumEditController.text.length == 0 ||
        _phoneCodeEditController.text.length == 0 ||
        _passWordEditController.text.length == 0 ||
        _passWordTwoEditController.text.length == 0) {
    } else if (!checkPhoneNumber()) {
      ToastUtils.showText(context, msg: '请输入正确的手机号码');
    } else if (getedCode.compareTo(_phoneCodeEditController.text.toString()) !=
            0 ||
        codePhone.compareTo(_phoneNumEditController.text.toString()) != 0) {
      print('验证码' + _phoneNumEditController.text.toString());
      ToastUtils.showText(context, msg: '验证码错误，请重新获取验证码');
    } else if (_passWordEditController.text
            .compareTo(_passWordTwoEditController.text.toString()) !=
        0) {
      ToastUtils.showText(context, msg: '两次密码输入不一致，请重新输入');
    } else if (_passWordEditController.text.length < 6) {
      ToastUtils.showText(context, msg: '密码长度应在6-20位之间，请重新输入');
    } else {
      yayUserRegist();
    }
  }

  ///注册
  void yayUserRegist() async {
    try {
      Response respose;
      var data = {
        'mobilePhoneNumber': _phoneNumEditController.text,
        'password': _passWordEditController.text,
        'code': getedCode,
        'equipmentNumber': meid,
        'createTime': getNowTime()
      };
      respose = await Dio().post(HttpUrlservices.userRegistUrl, data: data);
      Map<String, dynamic> news = jsonDecode(respose.data);
      print(news);
      String dataValue = news['response']['data'].toString();

      if (dataValue.contains('success')) {
        ToastUtils.showSuccess(context, msg: '注册成功');
        Navigator.of(context).pop();
      } else {
        List<String> datalist = dataValue.split('&');
        ToastUtils.showText(context, msg: datalist[1]);
      }
    } catch (e) {
      print(e);
    }
  }

  ///获取当前时间
  String getNowTime() {
    //创建时间对象，获取当前时间
    DateTime now = new DateTime.now();
    print("当前时间：$now");
    List<String> datalist = now.toString().split('.');
    return datalist[0];
  }
}
