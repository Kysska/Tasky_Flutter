import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_flutter/data/gamedatabase.dart';
import 'package:tasky_flutter/presentation/forum.dart';
import 'package:tasky_flutter/presentation/game.dart';
import 'package:tasky_flutter/presentation/home.dart';
import 'package:tasky_flutter/presentation/note.dart';
import 'package:tasky_flutter/presentation/person.dart';
import 'package:tasky_flutter/presentation/signin.dart';
import 'package:tasky_flutter/vidgets/options.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
  late String _userAvatar = "https://firebasestorage.googleapis.com/v0/b/tasky-3f0ce.appspot.com/o/images%2F1684981544841?alt=media&token=ab9e8659-70a7-420e-bb94-178563a9d5e4";
  GameDatabase mGame = GameDatabase();
  UserFirebase mUser = UserFirebase();


  @override initState(){
    super.initState();
    updateCoin();
    getAvatar();
    pages = [
      Home(login: widget.login),
      NoteScreen(login: widget.login,),
      Game(login: widget.login),
      Forum(login: widget.login,),
      Person(login: widget.login, avatar: _userAvatar),
      Settings()
    ];

  }

  Future<void> updateCoin() async{
    SharedPreferences.getInstance().then((prefs) {
      Stream<int> valueStream = Stream.periodic(Duration(seconds: 1), (_) {
        return prefs.getInt('money') ?? 0;
      });
      valueStream.listen((value) {
        setState(() {
          _kapikoinCount = value;
        });
      });
    });
    // _kapikoinCount = await mGame.getMoney();
  }

  Future<void> getAvatar() async{
    _userAvatar = await mUser.getUserAvatar(widget.login);
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
        toolbarHeight: 80,
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
                      percent: 0.7,
                      linearGradient: LinearGradient(
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
                  InkWell(
                    onTap: () {
                      _onProfileIconPressed;
                    },
                    child: Image.network(
                      _userAvatar,  // Путь к изображению
                      width: 50,  // Ширина изображения
                      height: 50, // Высота изображения
                    ),
                  )
                ],
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
                SizedBox(height: 2),
                Text(
                  _kapikoinCount.toString(),
                  style: TextStyle(
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
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xFF111010),
            padding: EdgeInsets.all(16),
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
        /*
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset_rounded),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF6688FF),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    */
    );
  }
}