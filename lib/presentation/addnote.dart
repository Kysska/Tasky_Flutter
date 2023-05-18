import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';

import '../data/notedatabase.dart';

class AddNote extends StatefulWidget {
  final Note note;
  final bool isEdit;
  final String login;
  const AddNote({Key? key, required this.note, required this.isEdit, required this.login}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  // late QuillController _controller;
  String _title = "";
  String _desc = "";
  bool _isImportant = false;
  bool _isEdit = false;
  NoteFirebase mNoteFire = NoteFirebase();
  DatabaseHelperNote mNote = DatabaseHelperNote.instance;

  @override
  void initState() {
    super.initState();
    // var myJSON = jsonDecode(widget.note.desc);
    // _controller = QuillController(
    //     document: Document.fromJson(myJSON),
    //     selection: TextSelection.collapsed(offset: 0));
    _isEdit = widget.isEdit;
    _title = widget.note.title;
    _desc = widget.note.desc;
    _isImportant = widget.note.isImportant;
    // _controller = QuillController.basic();
  }


  _changeIsImportant(){
    setState(() {
      _isImportant = !_isImportant;
    });
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
    var id = DateTime.now().toString();
    await mNote.add( Note(id: id, title: _title, desc: _desc, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
    await mNoteFire.setDataNoteList(widget.login, Note( id: id, title: _title, desc: _desc, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
  }
  _updateNote() async{
    await mNote.update( Note(id: widget.note.id, title: _title, desc: _desc, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
    await mNoteFire.updateNote(widget.login, Note(id: widget.note.id, title: _title, desc: _desc, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
  }
  _deleteNote() async{
    await mNote.remove(widget.note.id);
    await mNoteFire.deleteNote(widget.login, widget.note.id);
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
            // final jsonStr = jsonEncode(_controller.document.toDelta().toJson());
            if(_isEdit) _updateNote();
            else _addNote();
            Navigator.pop(context, true);
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
      // bottomNavigationBar: Padding(
      //   padding: MediaQuery.of(context).viewInsets,
      //   child: QuillToolbar.basic(controller: _controller,
      //   showInlineCode: false,
      //     showFontFamily: false,
      //     showCodeBlock: false,
      //     showSearchButton: false,
      //     showLink: false,
      //     showColorButton: false,
      //     showBackgroundColorButton: false,
      //     showSubscript: false,
      //     showSuperscript: false,
      //     showClearFormat: false,
      //   ),
      // ),
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
            // Padding(
            //   padding: const EdgeInsets.all(4),
            //   child: QuillEditor.basic(
            //       controller: _controller,
            //       readOnly: false,
            //       locale: const Locale('ru'),
            //   ),
            // ),
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