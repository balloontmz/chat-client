import 'package:chat/utils/log_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCenterContentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListView(
        children: <Widget>[
          _buildRowItem('日程', iconD: Icons.perm_identity),
          _buildDivider(),
          _buildRowItem('邮箱', iconD: Icons.email),
          _buildDivider(),
          _buildRowItem('电话', iconD: Icons.phone_android),
          _buildDivider(),
          _buildRowItem('收藏', iconD: Icons.folder),
          _buildDivider(),
          _buildRowItem('钱包', iconD: Icons.monetization_on),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildRowItem(String title, {IconData iconD}) {
    return new GestureDetector(
      child: new Row(
        children: <Widget>[
          new IconButton(
            icon: new Icon(iconD ?? Icons.perm_device_information),
            onPressed: null,
          ),
          new Column(
            children: <Widget>[
              new Text(title),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return new Divider(
      height: 1.0,
      indent: 50.0,
      color: Colors.grey,
    );
  }
}
