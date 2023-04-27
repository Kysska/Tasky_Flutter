import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Forum extends StatefulWidget{
  const Forum({super.key});


  @override
  _ForumState createState() => _ForumState();

}
class _ForumState extends State<Forum> {
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