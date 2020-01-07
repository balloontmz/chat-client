import 'package:chat/routers/routers.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
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
  List<ChatGroup> items = new List();

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
                // _drawerOption(new Icon(Icons.settings), "应用设置"),
                _drawerLogout(new Icon(Icons.arrow_back), "注销")
              ],
            ),
          )
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("chat"),
      ),
      body: new RefreshIndicator(
        onRefresh: _onFresh,
        child: new ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return new Column(
              children: <Widget>[
                new Divider(
                  height: 1.0,
                ),
                new ListTile(
                  onTap: () {
                    Log.i("点击了 tile,准备进入聊天详情");
                    Routers.push("/home", context);
                  }, //
                  leading: new Image.asset(
                    "images/avatar1.jpg",
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                  ),
                  title: new Text(
                      items[index].name == '' ? '没有名字' : items[index].name),
                  subtitle: new Text("你高考考了满分你知道吗？"),
                  trailing: new Text("9:00"),
                ),
              ],
            );
          },
        ),
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
      Log.i("进入此处代表处理了结果");
      items.add(item);
    });

    if (this.mounted) {
      // 只有组件没被销毁的情况下才更新状态
      setState(() {
        items = items;
      });
    }
  }

  Future<void> _onFresh() async {
    loadData();
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

  Widget _drawerLogout(Icon icon, String name) {
    return new InkWell(
      onTap: () async {
        Log.i("注销进入此处");
        await TokenUtil.clearToken();
        Routers.push('/login', context);
      },
      child: new Container(
        padding: const EdgeInsets.only(top: 22.0),
        child: new Row(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.only(right: 28.0), child: icon),
            new Text(name)
          ],
        ),
      ),
    );
  }
}
