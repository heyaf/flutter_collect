//权限请求的工具类
// import 'package:flutter_baidu_map/flutter_baidu_map.dart';
import 'package:permission_handler/permission_handler.dart';

// class LocationInfo {
//   ///获取地理位置信息
//   static Future<String> getLocation() async {
//     ///查看当前定位权限的状态
//     var status = await Permission.location.status;

//     ///定位权限未开启
//     if (status == PermissionStatus.permanentlyDenied) {
//       ///提示弹窗打开手机设置页面
//       ///openAppSettings();
//       return "error&定位权限未开启，请到设置中打开定位权限";
//     }

//     //还没有请求过权限（true：没有请求过权限，false:已经请求过权限）
//     if (status.isUndetermined) {
//       await Permission.location.request().isGranted;
//     }

//     BaiduLocation location = await FlutterBaiduMap.getCurrentLocation();
//     print("==经度、纬度==>${location.latitude},${location.longitude}");
//     return "${location.longitude}&${location.latitude}";
//   }
// }
