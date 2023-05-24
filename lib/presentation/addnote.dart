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
  late QuillController _controller = QuillController.basic();
  String _title = "";
  bool _isImportant = false;
  bool _isEdit = false;
  NoteFirebase mNoteFire = NoteFirebase();
  DatabaseHelperNote mNote = DatabaseHelperNote.instance;
  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initQuill();
  }

  Future _initQuill() async{
    var myJSON = widget.note.desc;
    if (myJSON.isNotEmpty) {
      setState(() {
        _controller = QuillController(
          document: Document.fromJson(jsonDecode(myJSON)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
    _isEdit = widget.isEdit;
    _title = widget.note.title;
    _isImportant = widget.note.isImportant;
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


  _addNote(jsonStr) async{
    var id = DateTime.now().toString();
    await mNote.add( Note(id: id, title: _title, desc: jsonStr, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
    await mNoteFire.setDataNoteList(widget.login, Note( id: id, title: _title, desc: jsonStr, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
  }
  _updateNote(jsonStr) async{
    await mNote.update( Note(id: widget.note.id, title: _title, desc: jsonStr, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
    await mNoteFire.updateNote(widget.login, Note(id: widget.note.id, title: _title, desc: jsonStr, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
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
            final jsonStr = jsonEncode(_controller.document.toDelta().toJson());
            if(_isEdit) _updateNote(jsonStr);
            else _addNote(jsonStr);
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
          if(_isEdit)
          IconButton(
            onPressed: () {
              _deleteNote();
              Navigator.pop(context, true);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: QuillToolbar.basic(controller: _controller,
        showInlineCode: false,
          showFontFamily: false,
          showCodeBlock: false,
          showSearchButton: false,
          showLink: false,
          showColorButton: false,
          showBackgroundColorButton: false,
          showSubscript: false,
          showSuperscript: false,
          showClearFormat: false,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
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
              Padding(
                padding: const EdgeInsets.all(17),
                  child: QuillEditor(
                      controller: _controller,
                      readOnly: false,
                      locale: const Locale('ru'),
                    scrollController: ScrollController(),
                    scrollable: true,
                    autoFocus: false,
                    placeholder: 'Enter the shift note text here...',
                    expands: false,
                    padding: EdgeInsets.zero,
                    focusNode: _focusNode,
                  ),
              ),
              // TextFormField(
              //   initialValue: _desc ?? "",
              //   style: const TextStyle(fontSize: 16, color: Colors.black),
              //   decoration: const InputDecoration(
              //     hintText: "Enter description",
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide.none,
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide.none,
              //     ),
              //   ),
              //   onChanged: _changeDesc,
              // ),
            ],
          ),
        ),
      ),
    );
  }

}