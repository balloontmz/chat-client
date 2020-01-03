import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:flutter/material.dart';

class GroupChatList extends StatefulWidget {
  @override
  State createState() => new _GroupChatListState();
}

class _GroupChatListState extends State<GroupChatList> {
  String name = "null";
  String phone = "null";
  String email = "null";

  @override
  Widget build(BuildContext context) {
    Drawer drawer = new Drawer(
        child: new ListView(
      children: <Widget>[
        new DrawerHeader(
            child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: new CircleAvatar(
                    child: new Text(name),
                  ),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      name,
                      textScaleFactor: 1.2,
                    ),
                    new Text(phone)
                  ],
                )
              ],
            ),
            _drawerOption(new Icon(Icons.account_circle), "个人资料"),
            _drawerOption(new Icon(Icons.settings), "应用设置"),
          ],
        ))
      ],
    ));
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("chat"),
      ),
      body: new Text("聊天列表"),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        child: new Icon(Icons.add),
      ),
      drawer: drawer,
    );
  }

  @override
  void initState() {
    super.initState();
    TokenUtil.getToken().then((result) {
      if (result == '') {
        Log.d("进入此处,获取 result");
        name = result;
      } else {
        Log.d("进入此处,获取 result并且不为空");
      }
    });
  }

  Widget _drawerOption(Icon icon, String name) {
    return new Container(
      padding: const EdgeInsets.only(top: 22.0),
      child: new Row(
        children: <Widget>[
          new Container(
              padding: const EdgeInsets.only(right: 28.0), child: icon),
          new Text(name)
        ],
      ),
    );
  }
}
