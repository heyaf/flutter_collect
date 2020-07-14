import 'package:date_format/date_format.dart';

class DateUtils{

    //A时间和B时间相差多少天
    static int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
    if (ignoreTime) {
      int v = a.millisecondsSinceEpoch ~/ 86400000 -
          b.millisecondsSinceEpoch ~/ 86400000;
      if (v < 0) return -v;
      return v;
    } else {
      int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
      if (v < 0) v = -v;
      return v ~/ 86400000;
    }
  }

  //时间转换，将时间转换为想要的格式。例如：[yyyy,'-',mm,'-',dd]
  static String everyTimeYearMonthDay(DateTime currentTime, var format){
    return formatDate(currentTime, format);
  }
}