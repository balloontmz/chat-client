import 'package:flutter/material.dart';

class PromptPage {
  showMessage(BuildContext context, String text) {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
            title: new Text("Alert"),
            content: new Text(text),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'))
            ]);
      },
    );
  }
}
