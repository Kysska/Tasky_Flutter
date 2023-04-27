import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget{
  const Game({super.key});


  @override
  _GameState createState() => _GameState();

}
class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => AddTask()));
        },

        child: Icon(
          Icons.add_box,
          color: Colors.white,

        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

}