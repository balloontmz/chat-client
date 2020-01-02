import 'package:chat/widgets/prompt_page.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State createState() => new SignUpState();
}

class SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  PromptPage promptPage = new PromptPage();

  String _correctUsername = "";
  String _correctPassword = "";

  Future _handleSubmitted() async {
    if (_usernameController.text == '' || _passwordController.text == '') {
      await promptPage.showMessage(
          context, "Username or password cannot be empty!");
      return;
    } else if (_correctUsername.isNotEmpty || _correctPassword.isNotEmpty) {
      await promptPage.showMessage(
          context, "Username or password format is incorrect!");
      return;
    }
    _userLogUp(_usernameController.text, _passwordController.text,
        email: _emailController.text, phone: _phoneController.text);
  }

  ///注册函数
  void _userLogUp(String username, String password,
      {String email, String phone}) {}

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
                  image: new ExactAssetImage('images/sign_up.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          //注册按钮
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new BackButton(),
              new Text("  Sign Up",
                  textScaleFactor: 2.0,
                  style: new TextStyle(
                    color: const Color(0xff000000),
                  )),
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
                        errorText:
                            (_correctUsername == "") ? null : _correctUsername,
                      ),
                      onChanged: (String value) {
                        setState(() {
                          if (value.isEmpty) {
                            _correctUsername = "Username cannot be empty";
                          } else if (value.trim().length < 3) {
                            _correctUsername =
                                "Username length is less than 3 bits";
                          } else {
                            _correctUsername = "";
                          }
                        });
                      },
                    ),
                    //密码
                    new TextField(
                      controller: _passwordController,
                      obscureText: true,
                      // keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        hintText: 'Password',
                        errorText:
                            (_correctPassword == "") ? null : _correctPassword,
                        icon: new Icon(
                          Icons.lock_outline,
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          if (value.isEmpty) {
                            _correctPassword = "Password cannot be empty";
                          } else if (value.trim().length < 6) {
                            _correctPassword =
                                "Password length is less than 6 bits";
                          } else {
                            _correctPassword = "";
                          }
                        });
                      },
                    ),
                    new TextField(
                      controller: _emailController,
                      decoration: new InputDecoration(
                        hintText: 'E-mail',
                        icon: new Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                    new TextField(
                      controller: _phoneController,
                      decoration: new InputDecoration(
                        hintText: 'Phone',
                        icon: new Icon(
                          Icons.phone,
                        ),
                      ),
                    ),
                    //登录
                    new FlatButton(
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          color: Theme.of(context).accentColor,
                        ),
                        child: new Center(
                            child: new Text("Join",
                                style: new TextStyle(
                                  color: const Color(0xff000000),
                                ))),
                      ),
                      onPressed: () {
                        _handleSubmitted();
                      },
                    ),
                    //返回上一级
                    new Center(
                      child: new FlatButton(
                        child: new Text("Already have an account ?  Sign In",
                            style: new TextStyle(
                              color: const Color(0xff000000),
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
