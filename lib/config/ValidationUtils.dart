import 'package:common_utils/common_utils.dart';

///验证相关的工具类
class ValidationUtils{

  //验证手机号码是否有效
  static bool phoeNumIsTrue(String phone){
    return RegexUtil.isMobileExact(phone);
  }
}