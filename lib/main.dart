import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:chat/screens/ios/chat_screen.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(new TalkcasuallyApp());
}

class TalkcasuallyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'chat',
      theme: debugDefaultTargetPlatformOverride == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(
        channel: new IOWebSocketChannel.connect('ws://localhost:1323/ws'),
      ),
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
