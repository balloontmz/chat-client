import 'dart:convert';

import 'package:chat/utils/log_util.dart';

class ChatMsg {
  String msg;
  int id;
  int userID;
  int groupID;

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
}
