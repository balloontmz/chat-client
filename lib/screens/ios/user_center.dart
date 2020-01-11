import 'package:chat/widgets/fancy_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCenter extends StatefulWidget {
  @override
  State createState() => new _UserCenter();
}

class _UserCenter extends State<UserCenter> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("个人中心"),
      ),
      bottomNavigationBar: FancyTabBar(), // 此导航栏
      body: new Text("这是个人中心"),
    );
  }
}
