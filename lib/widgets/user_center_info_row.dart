import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _buildLeftColumn(),
        ),
        Expanded(
          flex: 1,
          child: _buildAvatar(),
        ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return new Column(
      children: <Widget>[
        new Text(
          '名字一栏',
          style: new TextStyle(fontSize: 25),
        ),
        new Text('编号一栏'),
      ],
    );
  }

  Widget _buildAvatar() {
    return new Container(
      alignment: const Alignment(0.0, -1.0),
      child: new IconButton(
        iconSize: 80,
        icon: new Icon(Icons.drafts),
        onPressed: null,
      ),
    );
  }
}
