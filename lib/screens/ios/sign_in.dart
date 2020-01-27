import 'package:chat/api/api.dart';
import 'package:chat/events/events.dart';
import 'package:chat/models/token_info.dart';
import 'package:chat/routers/routers.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/token_util.dart';
import 'package:chat/utils/util.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  State createState() => new SignInState();
}

class SignInState extends State<SignIn> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          //控制子控件的透明度
          new Opacity(
            opacity: 0.3,
            child: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new ExactAssetImage('images/sign_in.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FlatButton(
                child: new Text("home",
                    style: new TextStyle(
                      color: const Color(0xff000000),
                    )),
                onPressed: () {
                  Routers.push('/home', context);
                },
              ),
              new FlatButton(
                child: new Text("group",
                    style: new TextStyle(
                      color: const Color(0xff000000),
                    )),
                onPressed: () {
                  Routers.push('/group', context);
                }, // 点击登录的事件
              ),
              new Center(
                child: new Image.asset(
                  'images/108.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
              //账号密码框
              new Container(
                width: MediaQuery.of(context).size.width * 0.96,
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new TextField(
                        controller: _usernameController,
                        decoration: new InputDecoration(
                          hintText: 'Username',
                          icon: new Icon(
                            Icons.account_circle,
                          ),
                        ),
                      ),
                      new TextField(
                        controller: _passwordController,
                        obscureText: true,
                        // keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          hintText: 'Password',
                          icon: new Icon(
                            Icons.lock_outline,
                          ),
                        ),
                      ),
                    ]),
              ),
              new FlatButton(
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                  child: new Center(
                      child: new Text("Sign In",
                          style: new TextStyle(
                            color: const Color(0xff000000),
                          ))),
                ),
                onPressed: _onPressLogin,
              ),
              //登录按钮下方文字
              new Center(
                  child: new FlatButton(
                child: new Text(
                  "Don't have an account ?  Sign Up",
                  style: new TextStyle(
                    color: const Color(0xff000000),
                  ),
                ),
                onPressed: _openSignUp,
              ))
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _onPressLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    Log.i("异步登录进入此处");
    Log.i(username);
    Log.i(password);

    if (username.isEmpty) {
      Util.showSnackBar(context, "请输入账号", null);
      return false;
    }
    if (password.isEmpty) {
      Util.showSnackBar(context, "请输入密码", null);
      return false;
    }

    // setState(() {
    //   this.isLoading = true;
    // });

    // var environment = await TokenUtil.getEnvironment();

    await Api.login({
      "username": username,
      "password": password,
    }, (result) {
      // setState(() {
      //   this.isLoading = false;
      // });
      if (result is TokenInfo) {
        // Util.showToast(context, "登录成功", _scaffoldKey);

        if (true) {
          TokenUtil.saveAccountName(username);
          TokenUtil.savePassword(password);
          TokenUtil.saveAvatar(result.avatar);
        } else {
          TokenUtil.saveAccountName("");
          TokenUtil.savePassword("");
          TokenUtil.saveAvatar("");
        }
        TokenUtil.saveRemember(true);

        if (ApplicationEvent.event != null) {
          ApplicationEvent.event.fire(UserSignInEvent(result));
        }

        Routers.redirect("/group", context); // 登录成功转到 group 页面
      }
      return true;
    }, (error) {
      // setState(() {
      //   this.isLoading = false;
      // });
      if (ApplicationEvent.event != null)
        ApplicationEvent.event.fire(UserSignInFailEvent());
      Util.showSnackBar(context, error, null);
    });

    return false;
  }

  void _openSignUp() {
    setState(() {
      Routers.push('/register', context);
    });
  }
}
