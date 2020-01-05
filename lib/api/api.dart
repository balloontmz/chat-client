import 'package:chat/models/chat_group.dart';
import 'package:flutter/cupertino.dart';

import 'package:chat/utils/dio_util.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class Api {
  static const String DEV_BASE_URL = 'http://127.0.0.1:1323/';
  static const String BASE_URL = 'http://127.0.0.1:1323/';
  static const String STORAGE_URL = 'http://127.0.0.1:1323/';
  static const String DEV_STORAGE_URL = 'http://127.0.0.1:1323/';

  static const String CHAT_GROUP = 'group';

  static const String REFRESH_TOKEN = '';
  static const bool isTest = true;

  static Future<Map> getVersion() async {
    Map result = {'version': "", 'remark': "暂无更新", "url": ""};
    await DioUtil.instance.requestNetwork(Method.get, Api.DEV_BASE_URL,
        onSuccess: (response) {
      result = response.data;
      result["remark"] = result["remark"].toString().replaceAll("\\n", "\n");
    }, onError: (id, error) async {
      debugPrint(error);
    });

    return result;
  }

  // 聊天列表
  static Future getGroups() async {
    List<ChatGroup> resultList = new List();

    await DioUtil.instance.requestNetwork(Method.get, Api.CHAT_GROUP,
        onSuccess: (response) {
      for (int i = 0; i < response.data.length; i++) {
        try {
          ChatGroup cellData = new ChatGroup.fromJson(response.data[i]);

          resultList.add(cellData);
        } catch (e) {
          // No specified type, handles all
        }
      }
    }, onError: (id, msg) {});

    return resultList;
  }
}
