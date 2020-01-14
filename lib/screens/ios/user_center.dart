import 'package:chat/widgets/fancy_tab_bar.dart';
import 'package:chat/widgets/search_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCenter extends StatefulWidget {
  @override
  State createState() => new _UserCenter();
}

class _UserCenter extends State<UserCenter> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new SearchBox(),
        _buildHeader(),
        new Divider(
          // height: 10,
          thickness: 3,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    Widget header = new Container(
      // color: Colors.red,
      // margin: const EdgeInsets.all(0),
      // padding: const EdgeInsets.all(10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButtonColumn(Colors.grey, Icons.wrap_text, "第一"),
          _buildButtonColumn(Colors.grey, Icons.work, "第二"),
          _buildButtonColumn(Colors.grey, Icons.desktop_windows, "第三"),
          _buildButtonColumn(Colors.grey, Icons.device_unknown, "第四"),
        ],
      ),
    );
    return header;
  }

  Widget _buildButtonColumn(Color color, IconData icon, String label) {
    Widget col = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: 60,
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 2,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
    return new Container(
      // color: Colors.blue,
      child: col,
    );
  }
}
