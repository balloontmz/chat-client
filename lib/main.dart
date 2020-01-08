import 'package:chat/api/ws.dart';
import 'package:chat/common/global.dart';
import 'package:chat/events/events.dart';
import 'package:chat/models/chat_group.dart';
import 'package:chat/models/index.dart';
import 'package:chat/routers/routers.dart';
import 'package:chat/screens/ios/group_chat_list.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:chat/screens/ios/sign_in.dart';
import 'package:chat/screens/ios/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return this._hasLogin ? GroupChatList() : SignIn();
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
  }

  ///创建长连接并监听 -- 在初始化时和断开连接时
  void _createChannel() async {
    String token = await TokenUtil.getToken();

    Global.channel = new IOWebSocketChannel.connect(
      Ws.BASE_URL,
      headers: {"Authorization": token},
      pingInterval: Duration(seconds: 5),
    );

    //WebSocketChannelException 对于服务端不正常连接的情况没有正确处理
    //[github 的 issue 没有关闭](https://github.com/dart-lang/web_socket_channel/issues/38)

    Global.channel.stream.listen((message) {
      Log.i("接收到来自服务器的消息" + message);
      ApplicationEvent.event.fire(RecMsgFromServer(message)); // 分发信息
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
