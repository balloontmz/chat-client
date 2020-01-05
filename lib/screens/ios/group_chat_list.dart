import 'package:flutter/material.dart';

import 'package:chat/api/api.dart';
import 'package:chat/models/chat_group.dart';

class GroupChatList extends StatefulWidget {
  @override
  State createState() => new _GroupChatListState();
}

class _GroupChatListState extends State<GroupChatList> {
  String name = "null";
  String phone = "null";
  String email = "null";

  List<ChatGroup> groups;
  List<Text> items = new List();

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
      body: new Column(
        children: items,
      ),
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
    loadData();
  }

  void loadData() async {
    groups = await Api.getGroups();
    groups.forEach((item) {
      items.add(new Text(item.name == '' ? '名字为空' : item.name));
    });

    setState(() {
      items = items;
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
