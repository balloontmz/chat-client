import 'package:chat/screens/ios/chat_screen.dart';
import 'package:chat/screens/ios/group_chat_list.dart';
import 'package:chat/screens/ios/sign_in.dart';
import 'package:chat/screens/ios/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class Routers {
  //路由声明
  static Map<String, Function> routes = {
    '/login': (context) => SignIn(),
    '/register': (context) => SignUp(),
    '/home': (context) => ChatScreen(
          channel: new IOWebSocketChannel.connect(
              'ws://localhost:1323/ws'), //192.168.0.165
        ),
    '/group': (context) => GroupChatList(),
  };

  static String currentRouteName = "";

  static run(RouteSettings settings) {
    final Function pageContentBuilder = Routers.routes[settings.name];

    if (pageContentBuilder != null) {
      currentRouteName = settings.name;
      if (settings.arguments != null) {
        // 传参路由
        return new MaterialPageRoute(
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
      } else {
        // 无参数路由
        return new MaterialPageRoute(
            builder: (context) => pageContentBuilder(context));
      }
    } else {
      // 404页
      return new MaterialPageRoute(builder: (context) => new Container());
    }
  }

  /// 组件跳转
  static link(Widget child, String routeName, BuildContext context,
      [Map parmas]) {
    return GestureDetector(
      onTap: () {
        if (parmas != null) {
          Navigator.pushNamed(context, routeName, arguments: parmas);
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: child,
    );
  }

  /// 方法跳转
  static push(String routeName, BuildContext context, [Map parmas]) {
    if (parmas != null) {
      return Navigator.pushNamed(context, routeName, arguments: parmas);
    } else {
      return Navigator.pushNamed(
        context,
        routeName,
      );
    }
  }

  /// 方法跳转,无返回
  static redirect(String routeName, BuildContext context, [Map parmas]) {
    if (parmas != null) {
      return Navigator.pushReplacementNamed(context, routeName,
          arguments: parmas);
    } else {
      Navigator.pushReplacementNamed(context, routeName); //pushReplacementNamed
    }
  }

  ///model弹出
  static Future<Map> popup(String routeName, BuildContext context,
      [Map parmas]) {
    return Navigator.push(
        context,
        MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            final Function pageContentBuilder = Routers.routes[routeName];

            return pageContentBuilder(
              context,
              arguments: parmas,
            );
          },
          fullscreenDialog: true,
        ));
  }

  static pop(BuildContext context, [Map params]) {
    return Navigator.pop(context, params);
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }
}