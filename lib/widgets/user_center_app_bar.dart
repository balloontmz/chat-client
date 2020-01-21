import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 这是一个可以指定SafeArea区域背景色的AppBar
/// PreferredSizeWidget提供指定高度的方法
/// 如果没有约束其高度，则会使用PreferredSizeWidget指定的高度

class UserCenterAppbar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度
  Color navigationBarBackgroundColor; //设置导航栏背景的颜色
  Widget leadingWidget;
  Widget trailingWidget;
  String title;
  UserCenterAppbar({
    @required this.trailingWidget,
    @required this.title,
    this.contentHeight = 150,
    this.navigationBarBackgroundColor = Colors.white,
    this.leadingWidget,
  }) : super();

  @override
  State<StatefulWidget> createState() {
    return new _UserCenterAppbarState();
  }

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

/// 这里没有直接用SafeArea，而是用Container包装了一层
/// 因为直接用SafeArea，会把顶部的statusBar区域留出空白
/// 外层Container会填充SafeArea，指定外层Container背景色也会覆盖原来SafeArea的颜色
///     var statusheight = MediaQuery.of(context).padding.top;  获取状态栏高度

class _UserCenterAppbarState extends State<UserCenterAppbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: widget.navigationBarBackgroundColor,
      child: new SafeArea(
        top: true,
        child: new Container(
          decoration: new UnderlineTabIndicator(
            borderSide: BorderSide(width: 1.0, color: Color(0xFFeeeeee)),
          ),
          height: widget.contentHeight,
          child: new Column(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 12),
                width: double.infinity,
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // Positioned(
                    //   left: 0,
                    //   child: new Container(
                    //     padding: const EdgeInsets.only(left: 5),
                    //     child: widget.leadingWidget,
                    //   ),
                    // ),
                    new Container(
                      child: new Text(widget.title,
                          style:
                              new TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    Positioned(
                      right: 0,
                      child: new Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: widget.trailingWidget,
                      ),
                    ),
                  ],
                ),
              ),
              new Text('test'),
            ],
          ),
        ),
      ),
    );
  }
}
