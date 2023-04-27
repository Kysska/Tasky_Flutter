import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/userdatabase.dart';

import 'signup.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  String _login = "";
  String _password = "";

  _changeLogin(String text){
    setState(() {
      _login = text;
    });
  }

  _changePassword(String text){
    setState(() {
      _password = text;
    });
  }

  _addUser() async{
    DatabaseHelperUser.instance.add(User(login: _login, password: _password, avatar: ""));
  }

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      onChanged: _changeLogin,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Логин",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      onChanged: _changePassword,
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Пароль",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          // TODO: firebase connect: проверка на пользователя в серваке, если есть вход, если нет регистриция
          _addUser();
        },
        child: const Text("Войти",
          textAlign: TextAlign.center,),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Text(
                    "Добро пожаловать",
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
                TextButton( onPressed: () {
                  Navigator.pushReplacement(
                    context,MaterialPageRoute(builder: (context) => SignUpPage()),);
                }, child: Text("У вас ещё нет аккаунта? Зарегистрируйтесь"),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}