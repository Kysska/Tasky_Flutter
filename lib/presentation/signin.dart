import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tasky_flutter/data/gamedatabase.dart';
import 'package:tasky_flutter/data/userdatabase.dart';

import '../main.dart';
import 'signup.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  String _login = "";
  String _password = "";
  UserFirebase userFirebase = UserFirebase();
  GameDatabase gameDatabase = GameDatabase();
  late final User userData;
  late ProgressDialog _progressDialog;

  _changeLogin(String text){
    setState(() {
      _login = text;
    });
  }

  @override
  initState(){
    super.initState();
    _progressDialog = ProgressDialog(context);
    _progressDialog.style(
      message: 'Загрузка...',
    );
  }

  _changePassword(String text){
    setState(() {
      _password = text;
    });
  }

  Future<bool> _validateData() async{
    if(_login.isNotEmpty && _password.isNotEmpty){
      if(await userFirebase.checkUserLogin(_login)){
        if(await userFirebase.checkUserPassword(_login, _password)){ //TODO исправить
          userData = await userFirebase.getUserData(_login);
          return true;
        }
        else{
          Future.delayed(Duration(seconds: 1)).then((value) {
            _progressDialog.hide().whenComplete(() {
              print(_progressDialog.isShowing());
            });
          });
          const snackBar = SnackBar(
              content: Text('Неверный пароль')
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
      }
      else{
        Future.delayed(Duration(seconds: 1)).then((value) {
          _progressDialog.hide().whenComplete(() {
            print(_progressDialog.isShowing());
          });
        });
        const snackBar = SnackBar(
            content: Text('Неверный логин')
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    }
    else{
      const snackBar = SnackBar(
          content: Text('Логин или пароль имеет неправильный формат')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      maxLength: 15,
      onChanged: _changeLogin,
      obscureText: false,
      style: GoogleFonts.comfortaa(

      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Логин",

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.black), // Черный цвет рамки
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide:
              BorderSide(color: Colors.black), // Черный цвет рамки при фокусе
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
              color: Colors.black), // Черный цвет рамки в обычном состоянии
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide:
              BorderSide(color: Colors.black), // Черный цвет рамки при ошибке
        ),
      ),
    );
    final passwordField = TextField(
      maxLength: 15,
      onChanged: _changePassword,
      obscureText: true,
      style: GoogleFonts.comfortaa(

      ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Пароль",

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.black), // Черный цвет рамки
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide:
                BorderSide(color: Colors.black), // Черный цвет рамки при фокусе
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
                color: Colors.black), // Черный цвет рамки в обычном состоянии
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide:
                BorderSide(color: Colors.black), // Черный цвет рамки при ошибке
          ),
        ));
    final loginButton = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black87,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          _progressDialog.show();
         if(await _validateData()){
           //TODO взять имя питомца
           var now = DateTime.now().millisecondsSinceEpoch;
           gameDatabase.setLastHunger(now);
           gameDatabase.setHpScale(3);
           gameDatabase.setHungerScale(100);
           gameDatabase.setAssetSkin('стандартный');
           _progressDialog.hide();
           Navigator.pushReplacement(
               context, MaterialPageRoute(builder: (context) => Bar(login: _login,)));
         }
        },
        child: Text(
          "Войти",
          style:
              GoogleFonts.comfortaa(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
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
                  height: 50.0,
                  child: Text(
                    "Добро пожаловать",
                    style: GoogleFonts.comfortaa(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                emailField,
                SizedBox(height: 20.0),
                passwordField,
                SizedBox(
                  height: 20.0,
                ),
                loginButton,
                SizedBox(
                  height: 20.0,
                ),
                TextButton( onPressed: () {
                  Navigator.pushReplacement(
                    context,MaterialPageRoute(builder: (context) => SignUpPage()),);
                }, child: Text(
                    "У вас ещё нет аккаунта?\nЗарегистрируйтесь!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comfortaa(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}