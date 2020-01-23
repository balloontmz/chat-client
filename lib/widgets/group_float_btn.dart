import 'package:chat/routers/routers.dart';
import 'package:chat/widgets/speeddial/speed_dial.dart';
import 'package:chat/widgets/speeddial/speed_dial_child.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupFloatBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _dialVisible = true;
    return SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      visible: _dialVisible,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            child: Icon(Icons.accessibility),
            backgroundColor: Colors.red,
            // label: 'First',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('FIRST CHILD')),
        SpeedDialChild(
          child: Icon(Icons.brush),
          backgroundColor: Colors.blue,
          // label: 'Second',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('SECOND CHILD'),
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          // label: 'Third',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Routers.push('/add-group', context);
          },
        ),
      ],
    );
  }
}
