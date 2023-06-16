import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_flutter/data/gamedatabase.dart';
import 'package:tasky_flutter/presentation/forum.dart';
import 'package:tasky_flutter/presentation/game.dart';
import 'package:tasky_flutter/presentation/home.dart';
import 'package:tasky_flutter/presentation/note.dart';
import 'package:tasky_flutter/presentation/person.dart';
import 'package:tasky_flutter/presentation/signin.dart';

import 'data/userdatabase.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(persistenceEnabled: true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  String? login = await SHUser().getUserLogin();
  String namePet = await GameDatabase().getNamePet() ?? "aaa";
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'habit',
          channelName: 'Proto Coders Point',
          channelDescription: 'Notification example',
          defaultColor: Color(0XFF9050DD),
          ledColor: Colors.white,
          enableLights: true,
          enableVibration: false,
          playSound: false,
          vibrationPattern: Int64List(0),
        )
      ]);
  runApp(MaterialApp(home: login == null ? SignInPage(): Bar(login: login, namePet: namePet,)));
}



class Bar extends StatefulWidget {
  final login;
  final namePet;
  const Bar({super.key, this.login, this.namePet,});

  @override
  _BottomBarState createState() => _BottomBarState();
}


class _BottomBarState extends State<Bar> {
  int _selectedIndex = 0;
  List pages = [];
  int _kapikoinCount = 0;
  String assetGame = "стандартный";
  late final String _userAvatar = "images/avatar.jpg";
  GameDatabase mGame = GameDatabase();
  UserFirebase mUser = UserFirebase();


  @override initState(){
    super.initState();
    updateCoin();
    pages = [
      Home(login: widget.login),
      NoteScreen(login: widget.login,),
      Game(login: widget.login, namePet: widget.namePet),
      Forum(login: widget.login,),
      Person(login: widget.login, avatar: _userAvatar),
    ];

  }

  Future<void> updateCoin() async{
    SharedPreferences.getInstance().then((prefs) {
      Stream<int> valueStream = Stream.periodic(const Duration(seconds: 1), (_) {
        return prefs.getInt('money') ?? 0;
      });
      valueStream.listen((value) {
        setState(() {
          _kapikoinCount = value;
        });
      });
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
              radius: 20,
                child: ClipOval(
                  child: Image.asset(_userAvatar),
              ),
            ),
          ),
        ],



        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            Column(
              children: [
                const Icon(
                  Icons.attach_money,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  _kapikoinCount.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'kapikoin',
                  style: TextStyle(
                    color: Color(0xFF747686),
                      fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: const Color(0xFF111010),
            padding: const EdgeInsets.all(16),
            onTabChange: _onItemTapped,
            tabs: const[
              GButton(icon: Icons.home_filled),
              GButton(icon: Icons.book_rounded),
              GButton(icon: Icons.videogame_asset_rounded),
              GButton(icon: Icons.people),
              GButton(icon: Icons.accessibility_new),
            ],
          ),
        ),
      ),
    );
  }
}