import 'package:chat/models/chat_msg.dart';
import 'package:chat/models/token_info.dart';
import 'package:event_bus/event_bus.dart';

///ApplicationEvent event bus 支持多订阅 -- 可以设置多个监听者!!!
class ApplicationEvent {
  static EventBus event;
}

class UnAuthenticateEvent {
  UnAuthenticateEvent();
}

class UserSignInEvent {
  TokenInfo token;
  UserSignInEvent(this.token);
}

class UserSignInFailEvent {
  UserSignInFailEvent();
}

//ws 连接断开事件
class WSConnLosedEvent {
  WSConnLosedEvent();
}

class RecMsgFromServer {
  ChatMsg msg;
  RecMsgFromServer(this.msg);
}
