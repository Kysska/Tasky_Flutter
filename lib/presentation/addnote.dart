import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/notedatabase.dart';

class AddNote extends StatefulWidget {
  final Note note;
  final bool isEdit;
  const AddNote({Key? key, required this.note, required this.isEdit}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String _title = "";
  String _desc = "";
  bool _isImportant = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.isEdit;
    _title = widget.note.name;
    _desc = widget.note.desc;
    _isImportant = widget.note.isImportant;
  }


  _changeIsImportant(){
    print(_isImportant);
    setState(() {
      _isImportant = !_isImportant;
    });
    print(_isImportant);
  }

  _changeTitle(String text){
      setState(() {
        _title = text;
      });
  }

  _changeDesc(String text){
      setState(() {
        _desc = text;
      });
  }

  _addNote() async{
    await DatabaseHelperNote.instance.add(Note(name: _title, desc: _desc, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
  }
  _updateNote() async{
    await DatabaseHelperNote.instance.update(Note(id: widget.note.id, name: _title, desc: _desc, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
  }
  _deleteNote() async{
    await DatabaseHelperNote.instance.remove(widget.note.id!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            print("1");
            if(_isEdit) _updateNote();
            else _addNote();
            Navigator.pop(context, true);
            print("2");
          }
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if(_isImportant)
          IconButton(
            onPressed: () {_changeIsImportant();},
            icon: const Icon(
              Icons.push_pin_outlined,
            ),
            color: Colors.black,
          ),
          if(_isImportant == false)
            IconButton(
              onPressed: () {_changeIsImportant();},
              icon: const Icon(
                Icons.push_pin_outlined,
              ),
              color: Colors.black12,
            ),
          IconButton(
            onPressed: () {
              _deleteNote();
              Navigator.pop(context, true);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.dashboard_outlined,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 100,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 2.0,
              blurRadius: 8.0,
            )
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              spreadRadius: 2.0,
                              blurRadius: 8.0,
                            )
                          ]),
                      padding: const EdgeInsets.all(10.0),
                      child: const Icon(
                        Icons.check,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              initialValue: _title ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                hintText: "Enter title",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),

              ),
              onChanged: _changeTitle,
            ),

            TextFormField(
              initialValue: _desc ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Enter description",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _changeDesc,
            ),
          ],
        ),
      ),
    );
  }

}