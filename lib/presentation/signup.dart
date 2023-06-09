import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tasky_flutter/data/userdatabase.dart';
import 'package:tasky_flutter/presentation/helloworld.dart';
import 'package:tasky_flutter/presentation/signin.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String _login = "";
  String _password = "";
  UserFirebase userFirebase = UserFirebase();
  late ProgressDialog _progressDialog;

  @override
  initState(){
    super.initState();
    _progressDialog = ProgressDialog(context);
    _progressDialog.style(
      message: 'Загрузка...',
    );
  }

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
     SHUser().setUserLogin(_login);
  }


  Future<bool> _validateData() async{
    if(_login.isNotEmpty && _password.isNotEmpty){
      if(await userFirebase.checkUserLogin(_login)){
        Future.delayed(Duration(seconds: 1)).then((value) {
          _progressDialog.hide().whenComplete(() {
            print(_progressDialog.isShowing());
          });
        });
        const snackBar = SnackBar(
            content: Text('Логин уже занят. Попробуй другой.')
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
      else{
        userFirebase.setUserData(_login, _password);
        return true;
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
      ),
    );
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
            await _addUser();
            Future.delayed(Duration(seconds: 3)).then((value) {
              _progressDialog.hide().whenComplete(() {
                print(_progressDialog.isShowing());
              });
            });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Welcome(login: _login,)));
          }
        },
        child: Text(
          "Зарегистрироваться",
          style: GoogleFonts.comfortaa(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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
                    context,MaterialPageRoute(builder: (context) => SignInPage(key: null,)),);
                }, child: Text("У вас уже есть аккаунт? Войдите",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comfortaa(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}