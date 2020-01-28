import 'package:chat/routers/routers.dart';
import 'package:chat/utils/log_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Expanded(
                flex: 8,
                child: new Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: new TextField(
                    controller: _controller,
                    onChanged: _keywordChanged,
                    decoration: InputDecoration(
                      labelText: '搜索',
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      // hintText: '请输入搜索内容',
                      prefixIcon: Icon(Icons.search),
                      // contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
              ),
              new Expanded(
                flex: 2,
                child: new FlatButton(
                  child: Text("取消"),
                  onPressed: () {
                    Routers.pop(context);
                  },
                ),
              ),
            ],
          ),
          _buildList(),
        ],
      ),
    );
  }

  void _keywordChanged(String keyword) {
    Log.i("关键词更改,当前关键词为: $keyword");
    setState(() {});
  }

  Widget _buildList() {
    if (_controller.text == null || _controller.text == '') {
      return new Container();
    }
    return new Container(
      child: new Column(
        children: <Widget>[
          new ListTile(
            onTap: () {
              Routers.push('/search-group', context, {
                'keyword': _controller.text,
              });
            }, //
            leading: new Icon(Icons.person),
            title: new Text('加入群聊'),
            trailing: new Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
