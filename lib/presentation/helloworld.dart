
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tasky_flutter/data/gamedatabase.dart';

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
                  Center(child: Image.asset('images/default_capibara.png',width: 200,
                    height: 200,)),
                  SizedBox(height: 8,),
                  Text("Добро Пожаловать в Tasky!"),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text("Познакомьтесь, это ваш виртуальный питомец. Он поможет вам контролировать свои задачи, а взамен позаботьтесь о нём. Ставьте личные цели и прокачивайте своего питомца."),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: MyInputField(title: "Придумайте ему имя:", hint: "", controller: _titleController,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          _validateData();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: 120,
                                height: 40,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Начать',
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
      game.setNamePet(namePet);
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