import 'dart:io';

import 'package:chat/widgets/copy_image_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget Function(BuildContext) imageButtomSheetBuilder(
    BuildContext context, Function(File) cropImage) {
  return (BuildContext context) {
    return new Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new ListTile(
          // leading: new Icon(Icons.photo_camera),
          title: new Center(
            child: new Text("Camera"),
          ),

          onTap: () async {
            await getImage(cropImage);
            Navigator.pop(context);
          },
        ),
        new ListTile(
          // leading: new Icon(Icons.photo_library),
          title: new Center(
            child: new Text("Gallery"),
          ),
          onTap: () async {
            await chooseImage(cropImage);
            Navigator.pop(context);
          },
        ),
        new Divider(
          thickness: 3,
        ),
        new ListTile(
          // leading: new Icon(Icons.photo_library),
          title: new Center(
            child: new Text("Gallery"),
          ),
          onTap: () async {
            Navigator.pop(context);
          },
        ),
      ],
    );
  };
}

///拍摄照片
Future getImage(Function(File) cropImage) async {
  await ImagePicker.pickImage(source: ImageSource.camera)
      .then((image) => cropImage(image));
}

///从相册选取
Future chooseImage(Function(File) cropImage) async {
  await ImagePicker.pickImage(source: ImageSource.gallery)
      .then((image) => cropImage(image));
}
