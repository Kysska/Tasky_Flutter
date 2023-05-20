import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  const Bar({super.key, this.login});


  @override
  _BottomBarState createState() => _BottomBarState();

}


class _BottomBarState extends State<Bar> {
  int _selectedIndex = 0;
  List pages = [];

  @override void initState() {
    super.initState();
    pages = [
      Home(login: widget.login),
      NoteScreen(login: widget.login,),
      Game(login: widget.login),
      Forum(),
      Person(),
      Settings()
    ];
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
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onPressed: _onProfileIconPressed,
          ),
        ],
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            Column(
              children: [
                Icon(
                  Icons.attach_money,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(height: 2),
                Text(
                  '100',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'kapikoin',
                  style: TextStyle(
                    color: Color(0xFF747686),
                      fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: SettingsMenu(),
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