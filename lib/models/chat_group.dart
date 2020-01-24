import 'dart:convert';

import 'package:chat/utils/log_util.dart';

class ChatGroup {
  String name;
  String avatar;
  int id;

  ChatGroup({
    this.id,
    this.name,
    this.avatar,
  });

  ///反序列化
  factory ChatGroup.fromJson(Map<String, dynamic> json) {
    Log.i("此处打印 group 中不存在的值");
    Log.i(json['abc']);
    return ChatGroup(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
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
      };
}
