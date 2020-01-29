import 'dart:convert';

import 'package:chat/models/chat_msg.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/sqlite_util.dart';
import 'package:sqflite/sqflite.dart';

class ChatGroup {
  String name;
  String avatar;
  int id;
  ChatMsg preview;

  ChatGroup({
    this.id,
    this.name,
    this.avatar,
    this.preview,
  });

  ///反序列化
  factory ChatGroup.fromJson(Map<String, dynamic> json) {
    Log.i("此处打印 group 中不存在的值");
    Log.i(json['abc']);
    return ChatGroup(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      preview:
          json['preview'] != null ? ChatMsg.fromJson(json['preview']) : null,
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
        'name': this.name,
        'avatar': this.avatar,
        'preview': this.preview,
      };

  Future<ChatMsg> getFirstMsg() async {
    Database db = await SqliteUtil.instance.database;
    List<Map> maps = await db.query(
      'chat_msg',
      columns: ['id', 'user_id', 'group_id', 'msg', 'type'],
      where: 'group_id = ?',
      whereArgs: [this.id],
      orderBy: 'id desc',
      limit: 1,
    );
    if (maps.length > 0) {
      return ChatMsg.fromMap(maps.first);
    }
    return null;
  }
}
