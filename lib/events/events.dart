import 'package:event_bus/event_bus.dart';

class ApplicationEvent {
  static EventBus event;
}

class UnAuthenticateEvent {
  UnAuthenticateEvent();
}

class UserSignInEvent {
  UserSignInEvent();
}
