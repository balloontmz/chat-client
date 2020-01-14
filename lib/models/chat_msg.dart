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
  int type = 1;

  ChatMsg({
    this.id,
    this.msg,
    this.userID,
    this.groupID,
    this.type = 1,
  });

  ///反序列化
  factory ChatMsg.fromJson(Map<String, dynamic> json) {
    return ChatMsg(
      id: json['id'],
      userID: json['user_id'],
      groupID: json['group_id'],
      msg: json['msg'],
      type: json['type'] != null ? json['type'] : 1,
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
      'type': type,
    };
    return map;
  }

  ChatMsg.fromMap(Map<String, dynamic> map) {
    Log.i("传入的 map 为: $map");
    id = map['id'];
    userID = map['user_id'];
    groupID = map['group_id'];
    msg = map['msg'];
    type = map['type'] != null ? map['type'] : 1;
  }

  ///数据库操作
  static Future<ChatMsg> insert(ChatMsg chatMsg) async {
    Database db = await SqliteUtil.instance.database;
    ChatMsg msg = await getMsg(chatMsg.id);
    if (msg == null) {
      Log.i("进入此处代表接收到本地数据库不存在的数据,插入");
      await db.insert('chat_msg', chatMsg.toMap());
    }
    return chatMsg;
  }

  static void batchInsert(List<ChatMsg> chatMsgs) async {
    Database db = await SqliteUtil.instance.database;
    Batch batch = db.batch();
    Log.i("将一批之前不存在的数据插入数据库 ${chatMsgs}");
    chatMsgs.forEach((msg) {
      batch.insert('chat_msg', msg.toMap());
    });
    batch.commit();
    return;
  }

  static Future<ChatMsg> getMsg(int id) async {
    Database db = await SqliteUtil.instance.database;
    List<Map> maps = await db.query('chat_msg',
        columns: ['id', 'user_id', 'group_id', 'msg'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ChatMsg.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<ChatMsg>> getMsgList() async {
    Database db = await SqliteUtil.instance.database;
    List<Map> maps = await db.query(
      'chat_msg',
      columns: ['id', 'user_id', 'group_id', 'msg'],
    );
    if (maps.length > 0) {
      return maps.map((dynamic model) => ChatMsg.fromMap(model)).toList();
    }
    return null;
  }

  ///这里直接查所有的,然后需要有后台直接删除已被移除的聊天组的消息!!!
  static Future<List<int>> getMsgListUseGroupIDs(List<int> groupIDs) async {
    Database db = await SqliteUtil.instance.database;
    List<Map> maps = await db.query(
      'chat_msg',
      columns: ['id', 'group_id'],
      // where: 'group_id in (?)',
      // whereArgs: [groupIDs],
    );
    Log.i("查询出来的消息列表为: $maps");
    if (maps.length > 0) {
      return maps.map((dynamic model) => model['id'] as int).toList();
    }
    return null;
  }

  static Future<int> delete(int id) async {
    Database db = await SqliteUtil.instance.database;
    return await db.delete('chat_msg', where: '$id = ?', whereArgs: [id]);
  }
}
