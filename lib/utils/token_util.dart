import 'package:shared_preferences/shared_preferences.dart';

const tokenSpKey = "token";
const serverSpKey = "server";
const rememberSpKey = "remember";
const passwordSpKey = "passwd";
const accountNameSpKey = "loginid";
const userNameSpKey = "username";
const avatarSpKey = "avatar";
const userIdKey = "userId";
const jpushKey = "jpushId";

class TokenUtil {
  static void clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }

  static Future getEnvironment() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var res = sp.getString(serverSpKey);
    if (res == "" || res == null) return "dev"; // 默认为开发环境
    return res;
  }

  static Future saveJpushId(String tag) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(jpushKey, tag);
  }

  static Future getJpushId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var res = sp.getString(jpushKey);
    if (res == "" || res == null) return "";
    return res;
  }

  static Future setEnvironment(String tag) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(serverSpKey, tag);
  }

  static getRefreshToken() async {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    return "";
  }

  static getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(tokenSpKey) ?? '';
  }

  static Future saveToken(String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(tokenSpKey, token);
  }

  static clearToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(tokenSpKey, null);
  }

  static Future<bool> getRememberAccount() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(rememberSpKey) ?? false;
  }

  static Future saveRemember(bool v) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(rememberSpKey, v);
  }

  static Future<String> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userNameSpKey);
  }

  static Future saveUserName(String username) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(userNameSpKey, username);
  }

  static Future<String> getAccountName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(accountNameSpKey) ?? '';
  }

  static Future saveAccountName(String accountName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(accountNameSpKey, accountName);
  }

  static Future savePassword(String pwd) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(passwordSpKey, pwd);
  }

  static Future getPassword() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(passwordSpKey) ?? '';
  }

  static clearUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(userNameSpKey, null);
  }

  static Future getAvatar() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(avatarSpKey);
  }

  static Future saveAvatar(String avatarUrl) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(avatarSpKey, avatarUrl);
  }

  static clearAvatar() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(avatarSpKey, null);
  }

  static Future getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(userIdKey);
  }

  static Future saveUserId(int id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(userIdKey, id);
  }

  static clearsaveUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(userIdKey, 0);
  }
}
