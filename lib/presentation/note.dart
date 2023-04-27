import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/presentation/addnote.dart';

import '../data/notedatabase.dart';
import '../vidgets/listnote.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  _refreshPage(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Note note = Note(name: "", desc: "", date: DateTime.now().toString(), isImportant: false);
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote(note: note, isEdit: false,))).then((value) => {
            if(value!=null && value == true){
              _refreshPage()
            }
          });
        },

        child: Icon(
          Icons.add_box,
          color: Colors.white,

        ),
        backgroundColor: Colors.blue,
      ),
      body: ListNote(),

    );
  }
}