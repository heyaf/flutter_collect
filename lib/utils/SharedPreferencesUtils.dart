import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future setString(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  // 获取String类型的数据
  static Future<String> getString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get(key).toString();
  }

  // 保存int类型的数据
  static void setInt(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(key, value);
  }

  // 获取int类型的数据
  static Future getInt(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  // 保存bool类型的数据
  static void setBool(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(key, value);
  }

  // 获取bool类型的数据
  static Future getBool(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(key);
  }

  // 移除指定Key
  static void remove(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  //清除数据
  static void clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
