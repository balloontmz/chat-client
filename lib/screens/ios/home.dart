import 'package:chat/routers/routers.dart';
import 'package:chat/screens/ios/group_chat_list.dart';
import 'package:chat/screens/ios/user_center.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:chat/widgets/fancy_tab_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  String name = "null";
  String phone = "null";
  String email = "null";
  int page = 2; // 默认在中间

  static const HOME = 1;
  static const CENTER = 2;
  static const MORE = 3;

  @override
  Widget build(BuildContext context) {
    Log.i("进入主页");
    Drawer drawer; // 抽屉属于最上层渲染,放在此处,根据不同的页面渲染不同的内容
    Widget child;
    AppBar appBar;
    switch (this.page) {
      case HOME:
        Log.i("进入此处聊天室列表");
        drawer = _groupDrawer();
        child = new GroupChatList();
        appBar = new AppBar(
          backgroundColor: Color(0xFF8c77ec),
          title: new Text("chat"),
        );
        break;
      case CENTER:
        drawer = new Drawer();
        child = new UserCenter();
        appBar = new AppBar(
          backgroundColor: Color(0xFF8c77ec),
          title: new Text("个人中心"),
        );
        break;
      default:
        drawer = new Drawer();
        child = new Text("设施默认值");
        appBar = new AppBar(
          backgroundColor: Color(0xFF8c77ec),
          title: new Text("默认值"),
        );
    }

    return new Scaffold(
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: FancyTabBar(_switchBottom), // 此导航栏
      body: child,
    );
  }

  ///点击导航栏的切换动作
  void _switchBottom(int action) {
    setState(() {
      this.page = action;
    });
  }

  ///构建聊天室列表抽屉
  Drawer _groupDrawer() {
    return new Drawer(
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
