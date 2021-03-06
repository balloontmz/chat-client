import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/qiniu_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.text,
      this.animationController,
      this.left = true,
      this.action = 1,
      this.name = "someone"});
  final String text;
  final int action;
  final String name;

  ///变量存储动画控制器
  final AnimationController animationController;

  bool left;

  @override
  Widget build(BuildContext context) {
    if (this.left == false) {
      Log.i("当前消息为用户自己的消息");
    }
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: this.left ? _buildOtherStyle(context) : _buildMyStyle(context),
      ),
    );
  }

  Widget _buildMyStyle(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Flexible(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(name, style: Theme.of(context).textTheme.subhead),
              _buildContent(context),
            ],
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: new CircleAvatar(
            child: new Text(name != '' ? name[0] : 'D'),
            backgroundColor: Color(0xFF8c77ec),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherStyle(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: new CircleAvatar(child: new Text(name != '' ? name[0] : 'D')),
        ),
        new Flexible(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(name, style: Theme.of(context).textTheme.subhead),
              _buildContent(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (this.action == 2) {
      return new Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: new Image.network(
          QiniuUtil.getImageFullPath(text),
          width: 250.0,
        ),
      );
    }
    return new Container(
      // width: ScreenUtil.screenWidth * 0.6,
      width: 250,
      margin: const EdgeInsets.only(top: 5.0),
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: new Text(text),
    );
  }
}
