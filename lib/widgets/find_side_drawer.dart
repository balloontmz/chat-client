import 'dart:io';

import 'package:chat/routers/routers.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/qiniu_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:chat/widgets/copy_image_route.dart';
import 'package:chat/widgets/image_buttom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FindSideDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _FindSideDrawerState();
  }
}

class _FindSideDrawerState extends State<FindSideDrawer> {
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
                        flex: 6,
                        child: new Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 12.0),
                          child: new Text(
                            '功能介绍',
                            style: new TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 2,
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
          _textRender(),
        ],
      ),
    );
  }

  Widget _textRender() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(20.0, 22.0, 20.0, 0.0),
      child: new Container(
        color: Colors.grey[200],
        child: new Text("""
    发现页拉取的是聊天室列表.根据热门程度对聊天室进行排序,并为每个聊天室近期的聊天记录中出现的关键词根据频次生成云图进行展示
        """),
      ),
    );
  }
}
