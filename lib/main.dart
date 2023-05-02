import 'package:flutter/material.dart';
import 'package:tasky_flutter/presentation/forum.dart';
import 'package:tasky_flutter/presentation/game.dart';
import 'package:tasky_flutter/presentation/home.dart';
import 'package:tasky_flutter/presentation/note.dart';
import 'package:tasky_flutter/presentation/person.dart';
import 'package:tasky_flutter/presentation/signup.dart';

import 'data/userdatabase.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  int result = await DatabaseHelperUser.instance.checkCount();
  if(result > 0){
    runApp(const MaterialApp(home: Bar()));
  }
  else {
    runApp(MaterialApp(home: SignUpPage()));
  }
}

class Bar extends StatefulWidget {
  const Bar({super.key});


  @override
  _BottomBarState createState() => _BottomBarState();

}

class _BottomBarState extends State<Bar> {
  int _selectedIndex = 0;
  List pages = [
    Home(),
    NoteScreen(),
    Game(),
    Forum(),
    Person()
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tasky"),
        ),
        body:
        Container(
          decoration: BoxDecoration(
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