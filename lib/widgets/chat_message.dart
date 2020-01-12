import 'package:chat/utils/log_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String _name = "someone";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController, this.left = true});
  final String text;

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
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              )
            ],
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: new CircleAvatar(
            child: new Text(_name[0]),
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
          child: new CircleAvatar(child: new Text(_name[0])),
        ),
        new Flexible(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              )
            ],
          ),
        ),
      ],
    );
  }
}
