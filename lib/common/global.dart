import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Global {
  //定义一个全局的用户 ws 通信的连接
  static IOWebSocketChannel channel;
}
