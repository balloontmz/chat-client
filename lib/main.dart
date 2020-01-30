import 'dart:convert';

import 'package:chat/api/ws.dart';
import 'package:chat/common/global.dart';
import 'package:chat/events/events.dart';
import 'package:chat/models/chat_group.dart';
import 'package:chat/models/chat_msg.dart';
import 'package:chat/models/index.dart';
import 'package:chat/routers/routers.dart';
import 'package:chat/screens/ios/group_chat_list.dart';
import 'package:chat/screens/ios/home.dart';
import 'package:chat/utils/group_util.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/qiniu_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:chat/widgets/fancy_tab_bar.dart';
import 'package:chat/widgets/grid_page.dart';
import 'package:crypto/crypto.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:chat/screens/ios/sign_in.dart';
import 'package:chat/screens/ios/chat_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  // runApp(new GridPage());
  WidgetsFlutterBinding.ensureInitialized();
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // await (new QiniuUtil()).uploadImageTest();
  var token = await TokenUtil.getToken();
  var userName = await TokenUtil.getAccountName();
  var environment = await TokenUtil.getEnvironment();

  runApp(new TalkcasuallyApp(token, userName, environment));
}

class TalkcasuallyApp extends StatefulWidget {
  final String token;

  final String userName;

  final String environment;

  TalkcasuallyApp(this.token, this.userName, this.environment);

  @override
  _TalkcasuallyApp createState() =>
      _TalkcasuallyApp(this.token, this.userName, this.environment);
}

class _TalkcasuallyApp extends State<TalkcasuallyApp> {
  final String token;
  bool _hasLogin = false;
  int groupID = 0;
  final String userName;
  final String environment;
  // bool _isLoading = true;

  ///构造函数
  _TalkcasuallyApp(this.token, this.userName, this.environment) {
    //监听事件
    final eventBus = new EventBus(sync: true);
    ApplicationEvent.event = eventBus;
  }

  @override
  Widget build(BuildContext context) {
    ///MultiProvider 不知道用来干嘛的
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => Model(token, userName, environment)),
      ],
      child: Consumer<Model>(
        builder: (context, model, widget) {
          return RestartWidget(
            child: MaterialApp(
              theme: ThemeData(
                backgroundColor: Colors.white,
                canvasColor: Colors.white,
              ),
              // 监听路由跳转
              onGenerateRoute: (RouteSettings settings) {
                return Routers.run(settings);
              },
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                // backgroundColor: Colors.transparent,
                resizeToAvoidBottomPadding: false,
                body: loadPage(),
              ),
            ),
          );
        },
      ),
    );
  }

  loadPage() {
    if (groupID != 0) {
      var temp = groupID;
      groupID = 0;

      return ChatScreen(
        groupID: temp,
      );
    }
    return this._hasLogin ? HomePage() : SignIn();
  }

  ///初始化时判断用户是否登录状态
  @override
  void initState() {
    super.initState();
    this._hasLogin = this.widget.token.isNotEmpty;
    ApplicationEvent.event.on<UnAuthenticateEvent>().listen((event) {
      setState(() {
        this._hasLogin = false;
      });
    });

    ApplicationEvent.event.on<UserSignInEvent>().listen((event) {
      setState(() {
        this._hasLogin = true;
      });
    });

    ApplicationEvent.event.on<WSConnLosedEvent>().listen((event) {
      if (this._hasLogin = true) {
        //如果已登录,则创建一个连接
        //如果连接为空或者关闭码不为空,则创建一个连接
        //TODO: 如果服务端无响应,则 channel 是一个错误的对象但是 closeCode 为 null,网上有一定的解决办法,但是不根治
        if (Global.channel == null || Global.channel.closeCode != null) {
          Log.i("进入此处创建长连接");
          _createChannel();
        } else {
          //如果存在连接,则直接重建
          Log.i("进入此处是存在错误的,因为引发了 ws 关闭事件,conn 却是正常的");
          setState(() {});
        }
      }
    });

    _initNotification();

    ApplicationEvent.event.on<RecMsgFromServer>().listen((event) async {
      Log.i("app 接收来自服务器的消息 ${event.msg} 消息动作为: ${event.msg.type}, 内容为:" +
          event.msg.msg);
      _showNotification(event.msg.groupID, event.msg.type,
          content: event.msg.msg);
    });
  }

  ///显示消息通知
  Future _showNotification(int groupID, int action, {String content}) async {
    //安卓的通知配置，必填参数是渠道id, 名称, 和描述, 可选填通知的图标，重要度等等。
    Log.i("展示消息进入此处");
    ChatGroup group = (await GroupUtil.getGroupList()).firstWhere((g) {
      return g.id == groupID;
    });
    Log.i("拉取到的 group 为: $group");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'chatChannelID', 'chatChannelName', 'chatChannelDescription',
        importance: Importance.Max, priority: Priority.High);
    //IOS的通知配置
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    //显示通知，其中 0 代表通知的 id，用于区分通知。
    await flutterLocalNotificationsPlugin.show(
        0, group.name, action == 1 ? content : "[图片]", platformChannelSpecifics,
        payload: '{"group_id":$groupID}');
  }

  void _initNotification() {
    var initializationSettingsAndroid = AndroidInitializationSettings('soul');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      Log.i('notification payload: ' + payload);
    }

    ///TODO: 此处路由没用!!! 因为路由是在这里初始化的,在 state init 之后!!!而调用该函数会重新 init state !!!,所以采用 group id 进行进入状态的判断!!! 很粗糙,后期整合到一个字段中去???
    setState(() {
      groupID = jsonDecode(payload)['group_id'] as int;
      Log.i("设置第一个页面的状态,传入 groupid,需要进入聊天页面 $groupID");
    });

    // await Navigator.push(
    //   context,
    //   new MaterialPageRoute(
    //       builder: (context) =>
    //           new ChatScreen(groupID: jsonDecode(payload)["group_id"] as int)),
    // );
    // Routers.push(
    //     "/home", context, {"group_id": jsonDecode(payload)["group_id"]});
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // await showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  ///创建长���接并监听 -- 在初始化时和断开连接时
  void _createChannel() async {
    String token = await TokenUtil.getToken();

    Global.channel = new IOWebSocketChannel.connect(
      Ws.BASE_URL,
      headers: {"Authorization": token},
      pingInterval: Duration(seconds: 5),
    );

    //WebSocketChannelException 对服务端不正常连接的情况没有正确处理
    //[github 的 issue 没有关闭](https://github.com/dart-lang/web_socket_channel/issues/38)

    Global.channel.stream.listen((message) {
      try {
        Log.i("接收到来自服务器的消息" + message);
        var msgJson = jsonDecode(message as String);
        Log.i("进入此处代表序列化完成");

        ChatMsg msg = ChatMsg.fromJson(msgJson);
        ChatMsg.insert(msg); // 插入本地数据���

        ApplicationEvent.event.fire(RecMsgFromServer(msg)); // 分发信息
      } catch (e) {
        Log.i("监听消息过程出现错误,错误原因为:" + e.toString());
      }
    }, onError: (error) {
      Log.i("出现错误,为:" + error);
    });

    setState(() {});
  }
}

///此组件的作用不明确
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  static restartApp(BuildContext context) {
    final _RestartWidgetState state = context.findAncestorStateOfType();
    // context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);
