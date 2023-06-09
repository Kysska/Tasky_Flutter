import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/presentation/addnote.dart';

import '../data/notedatabase.dart';
import '../vidgets/listnote.dart';

class NoteScreen extends StatefulWidget {
  final String login;
  const NoteScreen({Key? key, required this.login}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  _refreshPage(){
    Future.delayed(Duration(milliseconds: 50));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Note note = Note(id: "", title: "", desc: "", date: DateTime.now().toString(), isImportant: false);
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote(note: note, isEdit: false, login: widget.login,))).then((value) => {
            if(value!=null && value == true){
              _refreshPage()
            }
          });
        },

        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF93D7FF),
      ),
      body: ListNote(login: widget.login,),

    );
  }
}