import 'dart:convert';

import 'package:chat/models/chat_group.dart';
import 'package:chat/utils/log_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

const groupListKey = "grouplistid";

class GroupUtil {
  static void clear() async {
    //此函数会清除所有本地存储,慎用!!!
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // sp.clear();
  }

  ///获取聊天室列表
  static Future<List<ChatGroup>> getGroupList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var listString = sp.getString(groupListKey);
    if (listString != null) {
      List<dynamic> listJson = jsonDecode(listString);
      List<ChatGroup> listGroup =
          listJson.map((dynamic model) => ChatGroup.fromJson(model)).toList();

      return listGroup;
    }
    return null;
  }

  static Future setGroupList(List<ChatGroup> listGroup) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String listString = jsonEncode(listGroup);
    Log.i("序列化传入的聊天室对象数组" + listString);
    sp.setString(groupListKey, listString);
  }
}
