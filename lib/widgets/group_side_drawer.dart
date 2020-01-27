import 'package:chat/routers/routers.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class GroupSideDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _GroupSideDrawerState();
  }
}

class _GroupSideDrawerState extends State<GroupSideDrawer> {
  String name = "null";
  String phone = "null";
  String avatar;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    name = await TokenUtil.getUserName();
    avatar = await TokenUtil.getAvatar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 1, //20.0,
      child: _groupDrawer(context),
    );
  }

  ///构建聊天室列表抽屉
  Drawer _groupDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            height: 100,
            child: new DrawerHeader(
              // margin: const EdgeInsets.only(bottom: 200.0),
              // padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    // main
                    children: <Widget>[
                      new Expanded(
                        flex: 2,
                        child: new Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: this.avatar != null
                              ? new CircleAvatar(
                                  // backgroundColor: Color(0xFF8c77ec),
                                  backgroundImage: NetworkImage(this.avatar),
                                  // child: new Image.network(this.avatar),
                                )
                              : new CircleAvatar(
                                  backgroundColor: Color(0xFF8c77ec),
                                  child: new Text('T'),
                                ),
                        ),
                      ),
                      new Expanded(
                        flex: 2,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              name,
                              textScaleFactor: 1.2,
                            ),
                            new Text(phone)
                          ],
                        ),
                      ),
                      new Expanded(
                        flex: 6,
                        child: new IconButton(
                          color: Color(0xFF8c77ec),
                          icon: Icon(Icons.chevron_right),
                          iconSize: 25,
                          alignment: Alignment.centerRight,
                          // padding: EdgeInsets.only(right: 0),
                          onPressed: () => Routers.pop(context),
                          // onPressed: null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _drawerOption(new Icon(Icons.account_circle), "个人资料"),
          // _drawerOption(new Icon(Icons.settings), "应用设置"),
          _drawerLogout(new Icon(Icons.arrow_back), "注销", context),
        ],
      ),
    );
  }

  Widget _drawerOption(Icon icon, String name) {
    return new Container(
      padding: const EdgeInsets.fromLTRB(10.0, 22.0, 0.0, 0.0),
      child: new Row(
        children: <Widget>[
          new Container(
              padding: const EdgeInsets.only(right: 28.0), child: icon),
          new Text(name)
        ],
      ),
    );
  }

  Widget _drawerLogout(Icon icon, String name, BuildContext context) {
    return new InkWell(
      onTap: () async {
        Log.i("注销进入此处");
        await TokenUtil.clearToken();
        Routers.push('/login', context);
      },
      child: new Container(
        padding: const EdgeInsets.fromLTRB(10.0, 22.0, 0.0, 22.0),
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
