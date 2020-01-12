import 'dart:async';

import 'package:chat/common/global.dart';
import 'package:chat/events/events.dart';
import 'package:chat/routers/routers.dart';
import 'package:chat/utils/group_util.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:chat/widgets/fancy_tab_bar.dart';
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

  StreamSubscription msgSubscription;
  List<ChatGroup> groups;
  List<ChatGroup> items = new List();

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
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
                  Routers.push(
                    "/home",
                    context,
                    {"group_id": items[index].id},
                  );
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
    );
  }

  @override
  void initState() {
    super.initState();
    loadData(fresh: false);
  }

  void loadData({bool fresh}) async {
    //TODO: 此处应该拉接口跟远程数据进行比对,如相等不重新拉取数据
    //不需要刷新数据时,先尝试从缓存中拉取
    var data = await GroupUtil.getGroupList();
    if (!fresh && data != null && this.mounted) {
      Log.i("进入此处代表采用缓存的聊天室列表");
      Log.i("$data");
      this.items = data;
    } else {
      items = new List(); // 首先置空

      groups = await Api.getGroups();
      groups.forEach((item) {
        Log.i("进入此处代表处理了结果");
        items.add(item);
      });
      if (Global.channel == null || Global.channel.closeCode != null) {
        if (ApplicationEvent.event != null) {
          //触发事件
          ApplicationEvent.event.fire(WSConnLosedEvent());
        }
      }
    }

    if (this.mounted) {
      // 只有组件没被销毁的情况下才更新状态
      await GroupUtil.setGroupList(items); // 将拉取到的数据进行缓存.
      setState(() {
        items = items;
      });
      this.msgSubscription =
          ApplicationEvent.event.on<RecMsgFromServer>().listen((event) {
        Log.i("列表接收来自服务器的消息" + event.msg.msg);
      });
    }
  }

  Future<void> _onFresh() async {
    loadData(fresh: true);
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

  @override
  void dispose() {
    Log.i("离开时销毁对象");
    if (this.msgSubscription != null) {
      this.msgSubscription.cancel(); // 离开页面时取消
    }
    super.dispose();
  }
}
