import 'dart:convert';

import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/sqlite_util.dart';
import 'package:sqflite/sqflite.dart';

class ChatMsg {
  static const TEXT = 1;
  static const IMG = 2;

  String msg;
  int id;
  int userID;
  int groupID;
  int type;

  ChatMsg({
    this.id,
    this.msg,
    this.userID,
    this.groupID,
  });

  ///反序列化
  factory ChatMsg.fromJson(Map<String, dynamic> json) {
    return ChatMsg(
      id: json['id'],
      userID: json['user_id'],
      groupID: json['group_id'],
      msg: json['msg'],
    );
  }

  // String toString() {
  //   return jsonEncode({
  //     this.id,
  //     this.name,
  //   });
  // }

  ///序列化
  Map<String, dynamic> toJson() => {
        'id': this.id,
      };

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'user_id': userID,
      'group_id': groupID,
      'msg': msg,
    };
    return map;
  }

  ChatMsg.fromMap(Map<String, dynamic> map) {
    ChatMsg.fromJson(map);
  }

  ///数据库操作
  Future<ChatMsg> insert(ChatMsg chatMsg) async {
    Database db = await SqliteUtil.instance.database;
    await db.insert('chat_msg', chatMsg.toMap());
    return chatMsg;
  }

  Future<ChatMsg> getMsg(int id) async {
    Database db = await SqliteUtil.instance.database;
    List<Map> maps = await db.query('chat_msg',
        columns: ['id', 'user_id', 'group_id', 'msg'],
        where: '$id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ChatMsg.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ChatMsg>> getMsgList(int id) async {
    Database db = await SqliteUtil.instance.database;
    List<Map> maps = await db.query(
      'chat_msg',
      columns: ['id', 'user_id', 'group_id', 'msg'],
    );
    if (maps.length > 0) {
      return maps.map((dynamic model) => ChatMsg.fromJson(model)).toList();
    }
    return null;
  }

  Future<int> delete(int id) async {
    Database db = await SqliteUtil.instance.database;
    return await db.delete('chat_msg', where: '$id = ?', whereArgs: [id]);
  }
}
