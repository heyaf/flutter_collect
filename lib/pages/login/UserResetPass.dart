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
import 'dart:async';
import '../../config/HttpUrlServices.dart';
import '../../utils/ToastUtils.dart';

class UserResetPass extends StatefulWidget {
  Router router;
  UserResetPass(Router router,{Key key}){
    this.router = router;
    this.countdown=60;
  }
  /// 倒计时的秒数，默认60秒。
  int countdown;
  @override
  _UserResetPassState createState() => _UserResetPassState();
}

class _UserResetPassState extends State<UserResetPass> {
  Router router;
///用户姓名
  // TextEditingController _userNameEditController;
///手机号
  TextEditingController _phoneNumEditController;
  /// 验证码
  TextEditingController _phoneCodeEditController;

  final FocusNode _phoneNumFocusNode = FocusNode();
  final FocusNode _phoneCodeFocusNode = FocusNode();

  //image图片
  String a = 'assets/images/login_button_bg.png';
  String b = 'assets/images/login_button.png';
//按钮开关变量
  String btnLogin = '';
    ///获取的验证码
  String getedCode = '';
  ///获取验证码时候的电话
  String codePhone = '';

  bool _isAvailableGetVCode = true; //是否可以获取验证码，默认为`false`
  String _verifyStr = '获取验证码';
  /// 倒计时的计时器。
  Timer _timer;
  /// 当前倒计时的秒数。
  int _seconds;
  @override
  void initState() {
    super.initState();
    // _userNameEditController = TextEditingController();
    _phoneNumEditController = TextEditingController();
    _phoneCodeEditController = TextEditingController();

    // _userNameEditController.addListener(() => setState(() => {}));
    _phoneNumEditController.addListener(() => setState(() => {}));
    _phoneCodeEditController.addListener(() => setState(() => {}));

     _seconds = widget.countdown;  
  } 
    
  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context,width: 750,height: 1334,allowFontScaling: true);
    return Material(
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Column(
        children: <Widget>[
          appbarUI(),
          phoneIntroduceText(),
          phoneCodeUI(context),
        
          buildLoginButton()
        ],
      ),
    );

  }


    Widget appbarUI(){
          // 状态栏高度
    // 状态栏高度
    // double statusBarHeight = MediaQuery.of(context).padding.top;
      double statusBarHeight =0;
    double height = ScreenUtil().setHeight(statusBarHeight+96);
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
            top: statusBarHeight+10,
            child: Text('重置密码',style:TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(36),fontFamily: FontsConfig.$YAYAliFont),textAlign: TextAlign.center,)
            ),
        ],
      ),
    );
  }


  Widget phoneIntroduceText(){
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width-30,
      margin: EdgeInsets.only(left: 15,top: 10),
      color: Color.fromRGBO(245, 245, 245, 1),
      
      child: Text('目前仅支持中国大陆地区的手机号',style: TextStyle(fontSize: 14,fontFamily: FontsConfig.$YAYAliFont,color: Color.fromRGBO(179, 179, 179, 1)),textAlign: TextAlign.left,),
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
          borderSide: BorderSide(width: 0.5, color:Color.fromRGBO(237, 237, 237, 1)),
          insets: EdgeInsets.zero
      ),

      child: Stack(
        children: <Widget>[
          Positioned(
            left: 17,
            top: 14,
            width: 80,
            height: 14,
            child: Text('+86',style: TextStyle(
                  fontSize: 14,fontFamily: FontsConfig.$YAYAliFont,color: Colors.black),),
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

            left: 45,
            right: 15,
            top: 20,
            height: 20,

            child: TextField(
              
              textAlign: TextAlign.left,
              controller: _phoneNumEditController,
              focusNode: _phoneNumFocusNode,
              decoration: InputDecoration(
                hintText: "请输入手机号",
                hintStyle: TextStyle(fontFamily: FontsConfig.$YAYAliFont,fontSize: ScreenUtil().setSp(28),color: Color.fromRGBO(179, 179, 179, 1)),
                border: InputBorder.none,
                
              ),
              style: TextStyle(fontSize: ScreenUtil().setSp(28),fontFamily: FontsConfig.$YAYAliFont),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly, //只输入数字
                LengthLimitingTextInputFormatter(11)   //限制长度
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
///获取验证码
  Widget buildCodeTextField() {
    double width = MediaQuery.of(context).size.width;

    return Container(
        height: 48,
      decoration: UnderlineTabIndicator(
          borderSide: BorderSide(width: 0.5, color:Color.fromRGBO(237, 237, 237, 1)),
          insets: EdgeInsets.zero
      ),
        child: Stack(
          children: <Widget>[
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
                hintStyle: TextStyle(fontFamily: FontsConfig.$YAYAliFont,fontSize: ScreenUtil().setSp(28),color: Color.fromRGBO(179, 179, 179, 1)),
                border: InputBorder.none,
                
              ),
              style: TextStyle(fontSize: ScreenUtil().setSp(28),fontFamily: FontsConfig.$YAYAliFont),
                
                onChanged: (value) {
                  setState(() {
                    checkLoginText();
                  });
                },
              ),
            ),
            Positioned(
              // right: width-15,
              left: width-125,
              top: 10,
              // bottom: 10,
              child: Container(
                    width: 110,
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
                      onPressed: _seconds == widget.countdown ? () {
                        if(checkPhoneNumber()){
                            _startTimer();
                            gettestPhoneCode().then((data){
                            });  
                        }else{
                            ToastUtils.showText(context, msg:'请输入正确的手机号码');
                        } 
                      } : null,
                      child: Text(
                        '$_verifyStr',
                        maxLines: 1,
                        style: TextStyle(
                          
                          fontSize: 14,
                          fontFamily: FontsConfig.$YAYAliFont,
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
Widget buildLoginButton(){
      //image图片
    String unselectImage = 'assets/images/login_button_bg.png';
    String canselectImage = 'assets/images/login_button.png';
    return Stack(
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                nextBtnClicked();
              },
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(btnLogin==''?'$canselectImage':'$unselectImage',
                                    fit: BoxFit.cover,height: 40,width: MediaQuery.of(context).size.width-30,),
                ],
              ),
                Positioned(
                left: 0,
                top: 10,
                right: 0,
                height: ScreenUtil().setHeight(40),
                child: Text('下一步',
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontFamily: FontsConfig.$YAYAliFont,fontSize: ScreenUtil().setSp(28)),),

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
  //手机号的正则验证
  bool checkPhoneNumber(){
    RegExp exp = RegExp(
          r'^((13[0-9])|(14[57])|(15[0-9])|(16[6])|(17[0-8])|(18[0-9])|(19[89]))\d{8}$');
    bool matched = exp.hasMatch(_phoneNumEditController.text);
    return matched;
  }
    //登录按钮是否可以点击
  void checkLoginText(){
    if(_phoneNumEditController.text.length<11||_phoneCodeEditController.text.length==0){
      btnLogin = '';
    }else{
      btnLogin = '123';
    }
  }

  bool checkInput(){
    if(_phoneNumEditController.text.length == 0){

      Fluttertoast.showToast(
          msg: "请输入手机号",
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 14.0
      );

      return false;
    }else if(!checkPhoneNumber()){
          Fluttertoast.showToast(
          msg: "请正确输入手机号",
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 14.0
      );
      return false;

    }
    else if (_phoneCodeEditController.text.length == 0){
      Fluttertoast.showToast(
          msg: "请输入密码",
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 14.0
      );
      return false;
    }

    return true;
  }



     //发送验证码
   Future gettestPhoneCode() async{
     try {
       Response respose;
       var data = {'phoneNo':_phoneNumEditController.text
       };
       print(data);       
       respose = await Dio().get(HttpUrlservices.getPhoneCode,queryParameters: data);

      print(respose.data);
      Map<String, dynamic> news = jsonDecode(respose.data);
      print(news);
      String dataValue = news['response']['data'].toString();
      print('00'+dataValue);

      if(dataValue.contains('success')){
        List<String> datalist = dataValue.split('&');
        getedCode= datalist[2];
        codePhone = _phoneNumEditController.text.toString();
        print('获取的验证码'+getedCode);
      }
      return respose.data;

    } catch (e) {
      
      print(e);
    }
   }

     ///下一步按钮点击
  void nextBtnClicked(){
    if(_phoneCodeEditController.text.length==0||_phoneNumEditController.text.length==0){
    }else if(!checkPhoneNumber()){
        ToastUtils.showText(context, msg:'请输入正确的手机号码');
    }else if(getedCode.compareTo(_phoneCodeEditController.text.toString())!=0
          ||codePhone.compareTo(_phoneNumEditController.text.toString())!=0){
            print('验证码'+_phoneNumEditController.text.toString());
            ToastUtils.showText(context, msg:'验证码错误，请重新获取验证码');
    }else{
        makesurePhone();
    }
  }

  ///验证手机号
     void makesurePhone() async{
     try {
      Response respose;
       var data = {'mobilePhoneNumber':_phoneNumEditController.text,
                    'validationCode':getedCode,
       };       
       respose = await Dio().get(HttpUrlservices.sureUserPhone,queryParameters: data);
      Map<String, dynamic> news = jsonDecode(respose.data);
      print(news);
      String dataValue = news['response']['data'].toString();

      if(dataValue.contains('success')){
        // var phoneData = {'Phone':_phoneNumEditController.text};
          FocusScope.of(context).requestFocus(FocusNode());

          Navigator.pushNamed(context, '/userresetpassTwo',arguments: _phoneNumEditController.text);
      }else{
        List<String> datalist = dataValue.split('&');
        ToastUtils.showText(context, msg:datalist[1]);
      }
     } catch (e) {
       print(e);
     }
    }
}

