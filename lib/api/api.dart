import 'dart:convert';

import 'package:chat/models/chat_group.dart';
import 'package:chat/models/chat_msg.dart';
import 'package:chat/models/token_info.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:chat/utils/dio_util.dart';

typedef OnSuccess<T>(T data);

typedef OnFail(String message);

class Api {
  static const String DEV_BASE_URL = 'http://47.100.124.234:1323/';
  static const String BASE_URL = 'http://47.100.124.234:1323/';
  static const String STORAGE_URL = 'http://47.100.124.234:1323/';
  static const String DEV_STORAGE_URL = 'http://47.100.124.234:1323/';

  static const String LOGIN = 'user/login';
  static const String REGISTER = 'user/register';

  static const String QINIU = 'upload';

  static const String CHAT_GROUP = 'group';
  static const String FIND_LIST = 'group/find-list';
  static const String ADD_USER2CHAT_GROUP = 'group/add-user';
  static const String NOT_JOIN_CHAT_GROUP = 'group/not-join';
  static const String CHAT_MSG = 'msg';

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
  static Future<List<ChatGroup>> getGroups() async {
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

  // 未加入聊天列表
  static Future<List<ChatGroup>> getNotJoinGroups() async {
    List<ChatGroup> resultList = new List();

    await DioUtil.instance.requestNetwork(Method.get, Api.NOT_JOIN_CHAT_GROUP,
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

  static Future<dynamic> getFindList(args) async {
    var result;
    await DioUtil.instance.requestNetwork(
      Method.get,
      Api.FIND_LIST,
      queryParameters: args,
      onSuccess: (response) {
        result = response.data;
      },
      onError: (id, msg) {
        Log.i("请求出错,错误原因为: $msg");
      },
    );
    Log.i("返回的结果为: $result");

    return result;
  }

  // 将用户添加进群组
  static Future addUser2Group(int gID) async {
    Log.i('用户添加群组');
    await DioUtil.instance.requestNetwork(Method.post, Api.ADD_USER2CHAT_GROUP,
        queryParameters: {"group_id": gID}, onSuccess: (response) {
      Log.i('添加成功');
    }, onError: (id, msg) {
      Log.i('添加失败');
    });

    return;
  }

  // 聊天消息列表
  static Future<List<ChatMsg>> getMsgs(args) async {
    List<ChatMsg> resultList = new List();

    Log.i("拉取聊天消息列表传入的参数为: $args");

    await DioUtil.instance.requestNetwork(
      Method.get,
      Api.CHAT_MSG,
      onSuccess: (response) {
        for (int i = 0; i < response.data.length; i++) {
          try {
            ChatMsg cellData = new ChatMsg.fromJson(response.data[i]);

            // Log.i("尝试序列化 group");
            // Log.i(jsonEncode(cellData.toJson()));

            resultList.add(cellData);
          } catch (e) {
            // No specified type, handles all
            Log.i("拉取 group list 进入此处发生错误");
            Log.i(e.toString());
          }
        }
      },
      onError: (id, msg) {},
      queryParameters: args,
    );

    return resultList;
  }

  static Future<String> getQiNiuToken() async {
    String result;
    await DioUtil.instance.requestNetwork(
      Method.get,
      Api.QINIU,
      onSuccess: (response) {
        result = response.data;
      },
      onError: (id, msg) {
        Log.i("请求出错,错误原因为: $msg");
      },
    );

    return result;
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

  static register(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await DioUtil.instance.requestNetwork(Method.post, Api.REGISTER,
        params: params, onSuccess: (response) {
      if (response.ret == 1) {
        onSuccess(response);
        return true;
      } else {
        onFail(response.message);
      }
      return false;
    }, onError: (int code, String msg) {
      onFail(msg);
    });
  }

  static Future createGroup(args) async {
    var result;
    await DioUtil.instance.requestNetwork(
      Method.post,
      Api.CHAT_GROUP,
      params: args,
      onSuccess: (response) {
        result = response.data;
      },
      onError: (id, msg) {
        Log.i("请求出错,错误原因为: $msg");
      },
    );

    return;
  }
}
