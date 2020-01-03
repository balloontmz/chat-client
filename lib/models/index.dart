import 'package:flutter/material.dart';

class Model with ChangeNotifier {
  Model(this._token, this._userName, this._environment);

  String _token; // 用户token的值来区分是否登录(null?token)

  String _userName;

  String _environment;

  String get token => _token;

  String get userName => _userName;

  String get environment => _environment;

  bool get inProudction => _environment == "production";

  void setToken(token) {
    _token = token;
    notifyListeners();
  }

  void setUserName(name) {
    _userName = name;
    notifyListeners();
  }

  void setEnvironment(v) {
    _environment = v;
    notifyListeners();
  }

  void setUserNameToken(name, token) {
    _token = token;
    _userName = name;
    notifyListeners();
  }
}
