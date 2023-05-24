import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tasky_flutter/data/gamedatabase.dart';
import 'package:tasky_flutter/presentation/forum.dart';
import 'package:tasky_flutter/presentation/game.dart';
import 'package:tasky_flutter/presentation/home.dart';
import 'package:tasky_flutter/presentation/note.dart';
import 'package:tasky_flutter/presentation/person.dart';
import 'package:tasky_flutter/presentation/signin.dart';
import 'package:tasky_flutter/vidgets/options.dart';

import 'data/userdatabase.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(persistenceEnabled: true);
  String? login = await SHUser().getUserLogin();
  runApp(MaterialApp(home: login == null ? SignInPage(): Bar(login: login)));
}



class Bar extends StatefulWidget {
  final login;
  const Bar({super.key, this.login,});

  @override
  _BottomBarState createState() => _BottomBarState();
}


class _BottomBarState extends State<Bar> {
  int _selectedIndex = 0;
  List pages = [];
  int _kapikoinCount = 0;
  GameDatabase mGame = GameDatabase();


  @override initState(){
    super.initState();
    updateCoin();
    pages = [
      Home(login: widget.login),
      NoteScreen(login: widget.login,),
      Game(login: widget.login),
      Forum(login: widget.login,),
      Person(),
      Settings()
    ];
  }

  Future<void> updateCoin() async{
    _kapikoinCount = await mGame.getMoney();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onProfileIconPressed() {
    setState(() {
      _selectedIndex = 4;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'images/options.png',
                width: 30,
                height: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Container(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -145 * 3.1415927 / 180, // Поворот на 75 градусов
                    child: CircularPercentIndicator(
                      radius: 20,
                      lineWidth: 3.0,
                      percent: 0.91,
                      linearGradient: const LinearGradient(
                        colors: [
                          Color(0xFF9FDDFF),
                          Color(0xFF6688FF),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    onPressed: _onProfileIconPressed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: SettingsMenu(),
      body:
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.white]),
        ),
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar:
      BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "1"),
          BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: "2"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "3"),
          BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset_rounded), label: "4"),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new), label: "5"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),

    );
  }
}