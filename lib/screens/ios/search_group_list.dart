import 'package:chat/api/api.dart';
import 'package:chat/models/chat_group.dart';
import 'package:chat/routers/routers.dart';
import 'package:chat/utils/log_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchGroupList extends StatefulWidget {
  final String keyword;

  SearchGroupList({key, this.keyword}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _SearhGroupListState();
  }
}

class _SearhGroupListState extends State<SearchGroupList> {
  List<ChatGroup> items;

  @override
  Widget build(BuildContext context) {
    Log.i('进入群组页,当前组件的关键词为: ${widget.keyword}');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('搜索群组列表'),
      ),
      body: items != null
          ? new ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: items[index].avatar == ''
                      ? new Text('None')
                      : new Image.network(items[index].avatar),
                  title: new Text(items[index].name),
                  subtitle: new Text('小标题'),
                  trailing: new Icon(Icons.arrow_right),
                  onTap: _joinGroup(items[index].id),
                );
              },
            )
          : new Text('没有数据'),
      //   children: <Widget>[
      //     new ListTile(
      //       leading: new Text('头部'),
      //       title: new Text('群组名'),
      //       subtitle: new Text('小标题'),
      //       trailing: Text('尾部'),
      //       onTap: () {},
      //     ),
      //   ],
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    //初始化情况下
    _loadData();
  }

  void _loadData() async {
    items = new List(); // 首先置空

    var groups = await Api.getNotJoinGroups();

    groups.forEach((item) {
      Log.i("进入此处代表处理了结果,聊天室 name 为:${item.name}");
      items.add(item);
    });
    setState(() {});
  }

  Function _joinGroup(int gID) {
    Log.i('创建搜索群组列表');
    return () async {
      await Api.addUser2Group(gID);
      Routers.push('/group', context);
    };
  }
}
