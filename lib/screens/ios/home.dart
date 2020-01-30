import 'package:chat/routers/routers.dart';
import 'package:chat/screens/ios/group_chat_list.dart';
import 'package:chat/screens/ios/find.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:chat/widgets/fancy_tab_bar.dart';
import 'package:chat/widgets/find_side_drawer.dart';
import 'package:chat/widgets/group_float_btn.dart';
import 'package:chat/widgets/group_side_drawer.dart';
import 'package:chat/widgets/normal_app_bar.dart';
import 'package:chat/widgets/normal_tab_bar.dart';
import 'package:chat/widgets/user_center_app_bar.dart';
import 'package:chat/widgets/user_center_content_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int page = 0; // 默认在中间

  static const HOME = 0;
  static const FIND = 1;
  static const CENTER = 2;

  @override
  Widget build(BuildContext context) {
    Log.i("进入主页");
    Widget drawer; // 抽屉属于最上层渲染,放在此处,根据不同的页面渲染不同的内容
    Widget child;
    PreferredSizeWidget appBar;
    Widget floatBtn;
    switch (this.page) {
      case HOME:
        Log.i("进入此处聊天室列表");
        drawer = new GroupSideDrawer();
        child = new GroupChatList();
        appBar = new NormalAppbar(
          title: "聊天列表",
          leadingWidget: Builder(
            builder: (context) => IconButton(
              icon: new Icon(
                Icons.subject,
                color: Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        );
        floatBtn = new GroupFloatBtn();
        break;
      case FIND:
        drawer = new FindSideDrawer();
        child = new FindPage();
        appBar = new NormalAppbar(
          title: "发现",
          leadingWidget: Builder(
            builder: (context) => IconButton(
              icon: new Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        );
        break;
      case CENTER:
        drawer = new Drawer();
        child = new UserCenterContentList();
        appBar = new UserCenterAppbar(
          title: '个人中心',
          // leadingWidget: new Text('前置'),
          trailingWidget: new Text('后置'),
          navigationBarBackgroundColor: Color(0xFF8c77ec),
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
      // backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: HomeBottomNavigationBar(_switchBottom), // 此导航栏
      body: child,
      floatingActionButton: floatBtn,
    );
  }

  ///点击导航栏的切换动作
  void _switchBottom(int action) {
    setState(() {
      this.page = action;
    });
  }

  PreferredSizeWidget _buildUserCenterAppBar() {
    AppBar bar = new AppBar(
      backgroundColor: Color(0xFF8c77ec),
      title: new Text("个人中心"),
    );
    return bar;
  }
}
