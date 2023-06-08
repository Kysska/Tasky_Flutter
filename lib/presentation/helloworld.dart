
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tasky_flutter/data/gamedatabase.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/userdatabase.dart';
import '../main.dart';
import '../vidgets/input_field.dart';

class Welcome extends StatefulWidget{
  final login;
  const Welcome({super.key, required this.login, });

  @override
  _WelcomeHome createState() => _WelcomeHome();
}
class _WelcomeHome extends State<Welcome>{
  final _titleController = TextEditingController();
  GameDatabase game = GameDatabase();
  GameFirebase fireGame = GameFirebase();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Image.asset('images/default_capibara.png',width: 250,
                    height: 250,)),
                  SizedBox(height: 10,),
                  Text("Добро Пожаловать в Tasky!",
                    style: GoogleFonts.comfortaa(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Познакомьтесь, это ваш виртуальный питомец. Он поможет вам контролировать свои задачи, а взамен позаботьтесь о нём. Ставьте личные цели и прокачивайте своего питомца.",
                    style: GoogleFonts.comfortaa(
                    ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                    child: TextField(
                      maxLength: 15,
                      controller: _titleController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Придумайте ему имя",
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          _validateData();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            backgroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: 120,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  'Начать',
                                  style:
                                  GoogleFonts.comfortaa(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                  textAlign: TextAlign.center,
                                )))),
                  )
                ]
            ),
          ),
        )

    );
  }
  _validateData(){
    String namePet = _titleController.text;
    if(namePet.isNotEmpty){
      var now = DateTime.now().millisecondsSinceEpoch;
      game.setLastHunger(now);
      game.setNamePet(namePet);
      game.setHpScale(3);
      game.setHungerScale(100);
      game.setAssetSkin('images/default_capibara.png');
      game.setMoney(500);
      //TODO
      fireGame.setGameState(widget.login, namePet);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Bar(login: widget.login,)));
    }
    else{
      final snackBar = SnackBar(
          content: const Text('Введите имя питомца')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  // _addToDB() async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  //   firestore.collection('users').doc(userID).set({
  //     'name': _titleController.text,
  //     'money': 500,
  //     'skin': "skins/cat02.png"
  //   });
  // }
}