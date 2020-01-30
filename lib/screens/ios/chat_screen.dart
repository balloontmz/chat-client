import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat/common/global.dart';
import 'package:chat/events/events.dart';
import 'package:chat/models/chat_msg.dart';
import 'package:chat/models/token_info.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/qiniu_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final num groupID;
  ChatScreen({key, this.groupID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];

  final TextEditingController _textController = new TextEditingController();

  StreamSubscription msgSubscription;

  String msgK;

  bool _isComposing = false;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadWs(); // 加载 ws 相关
  }

  void _loadWs() async {
    // String token = await TokenUtil.getToken();
    // // token = token.substring(7);
    // // &token=${token}
    if (Global.channel == null || Global.channel.closeCode != null) {
      if (ApplicationEvent.event != null) {
        //触发事件
        ApplicationEvent.event.fire(WSConnLosedEvent());
      }
    }

    int userID = await TokenUtil.getUserId();
    //进入时首先从本地数据库拉取数据
    List<ChatMsg> msgs = await ChatMsg.getMsgList();
    Log.i("从数据库拉取到的消息列表为: $msgs");
    if (msgs != null) {
      msgs.forEach((item) {
        Log.i("进入每次迭代");
        setState(() {
          _appendMessages(item, userID);
        });
      });
    }

    this.msgSubscription =
        ApplicationEvent.event.on<RecMsgFromServer>().listen((event) async {
      Log.i("聊天室接收来自服务器的消息 ${event.msg} 消息动作为: ${event.msg.type}, 内容为:" +
          event.msg.msg);

      Log.i("获取到的用户 id 为: $userID");

      setState(() {
        _appendMessages(event.msg, userID);
      });
    });
    this.loading = false;
  }

  void _appendMessages(ChatMsg msg, int userID) {
    Log.i("当前消息聊天组 id 为: ${msg.groupID}, 当前使用者 id 为: ${widget.groupID}");
    if (msg.groupID == widget.groupID) {
      ChatMessage message;
      Log.i("当前消息用户 id 为: ${msg.userID}, 当前使用者 id 为: ${userID}");
      if (msg.userID == userID) {
        message = new ChatMessage(
          text: msg.msg,
          animationController: new AnimationController(
            duration: new Duration(microseconds: 700),
            vsync: this,
          ),
          action: msg.type,
          left: false,
          name: msg.userName,
        );
      } else {
        message = new ChatMessage(
          text: msg.msg,
          animationController: new AnimationController(
            duration: new Duration(microseconds: 700),
            vsync: this,
          ),
          action: msg.type,
          name: msg.userName,
        );
      }

      _messages.insert(0, message);
      message.animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // widget.channel.stream.listen((snapshot) {
    //   if (snapshot) {
    //     setState(() {
    //       _messages.insert(
    //         0,
    //         new ChatMessage(
    //           text: snapshot,
    //           animationController: new AnimationController(
    //             duration: new Duration(microseconds: 700),
    //             vsync: this,
    //           ),
    //         ),
    //       );
    //     });
    //   }
    // });
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xff4357C8),
        title: new Text('chat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Container(
        color: Colors.grey[100],
        child: new Column(
          children: <Widget>[
            _loadingStream(),
            new Divider(
              height: 1.0,
            ),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }

  Widget _loadingStream() {
    if (this.loading) {
      return new Flexible(
        child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        ),
      );
    }
    return new Flexible(
      child: new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => _messages[index],
        itemCount: _messages.length,
      ),
    );
    // return new StreamBuilder(
    //   stream: Global.channel.stream,
    //   builder: (context, snapshot) {
    //     // return new Padding(
    //     //   padding: const EdgeInsets.symmetric(vertical: 24.0),
    //     //   child: new Text(snapshot.hasData ? '${snapshot.data}' : ''),
    //     // );
    //     // Log.i("这里总该进入吧");
    //     if (snapshot.hasData && msgK != snapshot.data) {
    //       // Log.i("进入此处代表有消息");
    //       msgK = snapshot.data;
    //       ChatMessage message = new ChatMessage(
    //         text: snapshot.data,
    //         animationController: new AnimationController(
    //           duration: new Duration(microseconds: 700),
    //           vsync: this,
    //         ),
    //       );
    //       _messages.insert(0, message);
    //       message.animationController.forward();
    //     } else if (snapshot.hasError) {
    //       Log.i("连接失败,原因为:" + snapshot.toString()); //连接失败打印日志
    //       if (ApplicationEvent.event != null) {
    //         //触发事件
    //         ApplicationEvent.event.fire(WSConnLosedEvent());
    //       }
    //     } else {
    //       Log.i("进入此处多半是因为重复接收,消息为:" + snapshot.toString());
    //     }
    //     return new Flexible(
    //       child: new ListView.builder(
    //         padding: new EdgeInsets.all(8.0),
    //         reverse: true,
    //         itemBuilder: (_, int index) => _messages[index],
    //         itemCount: _messages.length,
    //       ),
    //     );
    //   },
    // );
  }

  void _handleSubmitted(String text, {int action = 1}) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    // ChatMessage message = new ChatMessage(
    //   text: text,
    //   animationController: new AnimationController(
    //     duration: new Duration(microseconds: 700),
    //     vsync: this,
    //   ),
    // );
    // setState(() {
    //   _messages.insert(0, message);
    // });

    String msg = jsonEncode({
      "action": action,
      "data": {
        "group_id": widget.groupID,
        "msg": text,
      },
    });

    if (Global.channel == null || Global.channel.closeCode != null) {
      ApplicationEvent.event.fire(WSConnLosedEvent());
    } else {
      Global.channel.sink.add(msg);
    }

    // message.animationController.forward();
  }

  //自定义一个发送消息的组件,属性为容器
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor), // 设置主题色
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            //摄像机按钮
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.photo_camera),
                onPressed: () async {
                  File imageFile = await ImagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (imageFile != null) {
                    String res = await (new QiniuUtil()).uploadImage(
                      await imageFile.readAsBytes(),
                    );
                    Log.i("上传图片的返回结果为: ${res}");
                    _handleSubmitted(res, action: 2);
                  }
                },
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(hintText: '发送消息'),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    this.msgSubscription.cancel(); // 离开页面时取消订阅
    // Global.channel.sink.close(); // 此处不关闭长连接 -- 长连接应该考��在关闭 app 之时
    super.dispose();
  }
}
