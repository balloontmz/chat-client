import 'package:flutter/material.dart';

class Util {
  static String getTimeDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    if (nowTime.isAfter(compareTime)) {
      if (nowTime.year == compareTime.year) {
        if (nowTime.month == compareTime.month) {
          if (nowTime.day == compareTime.day) {
            if (nowTime.hour == compareTime.hour) {
              if (nowTime.minute == compareTime.minute) {
                return '片刻之间';
              }
              return (nowTime.minute - compareTime.minute).toString() + '分钟前';
            }
            return (nowTime.hour - compareTime.hour).toString() + '小时前';
          }
          return (nowTime.day - compareTime.day).toString() + '天前';
        }
        return (nowTime.month - compareTime.month).toString() + '月前';
      }
      return (nowTime.year - compareTime.year).toString() + '年前';
    }
    return 'time error';
  }

  // 数组分组
  static List listToSort({List toSort, int chunk}) {
    var newList = [];
    for (var i = 0; i < toSort.length; i += chunk) {
      var end = i + chunk > toSort.length ? toSort.length : i + chunk;
      newList.add(toSort.sublist(i, end));
    }
    return newList;
  }

  static void showSnackBar(BuildContext context, String msg,
      [GlobalKey<ScaffoldState> _scaffoldKey]) {
    if (_scaffoldKey != null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("$msg")),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("$msg")),
      );
    }
  }
}
