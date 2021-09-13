import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

const Color _bgColor = Color.fromRGBO(0, 0, 0, 0.4);
const Color _contentColor = Color.fromRGBO(255, 255, 255, 1);
const double _textFontSize = 12.0;
const double _radius = 6.0;
const double _imgWH = 30.0;
const int _time = 2;
enum _Orientation { horizontal, vertical }

class ToastUtils {
  //Toast提示
  static void yayShowFutterToast(text) {
    Fluttertoast.showToast(
        msg: text,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static Future showText(
    BuildContext context, {
    @required String msg,
    int closeTime = _time,
  }) {
    return _showToast(
        context: context, msg: msg, stopEvent: true, closeTime: closeTime);
  }

  static Future showSuccess(
    BuildContext context, {
    @required String msg,
    int closeTime = _time,
  }) {
    Widget img = Image.asset("assets/images/jqjq_cjcg.png", width: _imgWH);
    return _showToast(
        context: context,
        msg: msg,
        image: img,
        stopEvent: true,
        closeTime: closeTime);
  }

  static _HideCallback showLoadingText_iOS(
    BuildContext context, {
    String msg = "加载中...",
  }) {
    Widget img = Image.asset("assets/loading.gif", width: _imgWH);
    return _showJhToast(
        context: context,
        msg: msg,
        image: img,
        isLoading: false,
        stopEvent: true);
  }
}

Future _showToast(
    {@required BuildContext context,
    String msg,
    stopEvent = false,
    Widget image,
    int closeTime,
    _Orientation orientation = _Orientation.vertical}) {
  msg = msg;
  var hide = _showJhToast(
      context: context,
      msg: msg,
      isLoading: false,
      stopEvent: stopEvent,
      image: image,
      orientation: orientation);
  return Future.delayed(Duration(seconds: closeTime), () {
    hide();
  });
}

typedef _HideCallback = Future Function();

class JhToastWidget extends StatelessWidget {
  const JhToastWidget({
    Key key,
    @required this.msg,
    this.image,
    @required this.isLoading,
    @required this.stopEvent,
    @required this.orientation,
  }) : super(key: key);

  final bool stopEvent;
  final Widget image;
  final String msg;
  final bool isLoading;
  final _Orientation orientation;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: false);
    Widget topW;
    bool isHidden;
    if (this.isLoading == true) {
      isHidden = false;
      topW = CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(_contentColor),
      );
    } else {
      isHidden = image == null ? true : false;
      topW = image;
    }

    var widget = Material(
//        color: Colors.yellow,
        color: Colors.transparent,
        child: Align(
//            alignment: Alignment.center,
            alignment: Alignment(0.0, 0.5), //中间往上一点
            child: Container(
              margin: const EdgeInsets.all(50.0),
              padding:
                  EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.0.w),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(_radius),
              ),
              child: ClipRect(
                child: orientation == _Orientation.vertical
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Offstage(
                            offstage: isHidden,
                            child: Container(
                              width: 40.0.w,
                              height: 40.0.w,
                              margin: EdgeInsets.only(bottom: 8.0.w),
                              padding: EdgeInsets.all(4.0),
                              child: topW,
                            ),
                          ),
                          Text(msg,
                              style: TextStyle(
                                  fontSize: _textFontSize,
                                  color: _contentColor),
                              textAlign: TextAlign.center),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Offstage(
                            offstage: isHidden,
                            child: Container(
                              width: 36.0.w,
                              height: 36.0.w,
                              margin: EdgeInsets.only(right: 8.0.w),
                              padding: EdgeInsets.all(4.0),
                              child: topW,
                            ),
                          ),
                          Text(msg,
                              style: TextStyle(
                                  fontSize: _textFontSize,
                                  color: _contentColor),
                              textAlign: TextAlign.center),
                        ],
                      ),
              ),
            )));
    return IgnorePointer(
      ignoring: !stopEvent,
      child: widget,
    );
  }
}

int backButtonIndex = 2;

_HideCallback _showJhToast({
  @required BuildContext context,
  @required String msg,
  Widget image,
  @required bool isLoading,
  bool stopEvent = false,
  _Orientation orientation = _Orientation.vertical,
}) {
  Completer<VoidCallback> result = Completer<VoidCallback>();

  var backButtonName = 'funya$backButtonIndex';
  // BackButtonInterceptor.add((stopDefaultButtonEvent) {
  //   result.future.then((hide) {
  //     hide();
  //   });
  //   return true;
  // }, zIndex: backButtonIndex, name: backButtonName);
  backButtonIndex++;

  var overlay = OverlayEntry(
      maintainState: true,
      builder: (_) => WillPopScope(
            onWillPop: () async {
              var hide = await result.future;
              hide();
              return false;
            },
            child: JhToastWidget(
              image: image,
              msg: msg,
              stopEvent: stopEvent,
              isLoading: isLoading,
              orientation: orientation,
            ),
          ));
  result.complete(() {
    if (overlay == null) {
      return;
    }
    overlay.remove();
    overlay = null;
    BackButtonInterceptor.removeByName(backButtonName);
  });
  Overlay.of(context).insert(overlay);
  return () async {
    var hide = await result.future;
    hide();
  };
}
