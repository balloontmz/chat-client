import 'package:chat/models/token_info.dart';
import 'package:event_bus/event_bus.dart';

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
