import 'dart:convert';

import 'package:chat/models/chat_group.dart';
import 'package:chat/models/token_info.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:flutter/cupertino.dart';

import 'package:chat/utils/dio_util.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class Api {
  static const String DEV_BASE_URL = 'http://localhost:1323/';
  static const String BASE_URL = 'http://localhost:1323/';
  static const String STORAGE_URL = 'http://localhost:1323/';
  static const String DEV_STORAGE_URL = 'http://localhost:1323/';

  static const String LOGIN = 'user/login';

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

          // Log.i("尝试序列化 group");
          // Log.i(jsonEncode(cellData.toJson()));

          resultList.add(cellData);
        } catch (e) {
          // No specified type, handles all
          Log.i("拉取 group list 进入此处发生错误");
          Log.i(e.toString());
        }
      }
    }, onError: (id, msg) {});

    return resultList;
  }

  static login(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.post, Api.LOGIN,
        params: params, onSuccess: (response) {
      if (response.ret == 1) {
        TokenInfo tokenInfo = TokenInfo.fromJson(response.data);
        TokenUtil.saveToken(tokenInfo.tokenType + ' ' + tokenInfo.accessToken);
        TokenUtil.saveUserName(tokenInfo.username);
        TokenUtil.saveUserId(tokenInfo.userid);
        onSuccess(tokenInfo);
        return true;
      } else {
        onFail(response.message);
      }
      return false;
    }, onError: (int code, String msg) {
      onFail(msg);
    });
  }
}
