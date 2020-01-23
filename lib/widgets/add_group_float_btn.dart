import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddGroupFloatBtn extends StatelessWidget {
  File imageFile;
  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text("Camera"),
                    onTap: () async {
                      imageFile = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text("Gallery"),
                    onTap: () async {
                      imageFile = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      },
      foregroundColor: Colors.white,
      child: Text('点我'),
    );
  }
}
