import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';


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
    mNoteFire.setDataNoteList(widget.login, Note( id: id, title: _title, desc: jsonStr, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
  }
  _updateNote(jsonStr) async{
    await mNote.update( Note(id: widget.note.id, title: _title, desc: jsonStr, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
    mNoteFire.updateNote(widget.login, Note(id: widget.note.id, title: _title, desc: jsonStr, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), isImportant: _isImportant));
  }
  _deleteNote() async{
    await mNote.remove(widget.note.id);
    mNoteFire.deleteNote(widget.login, widget.note.id);
  }

  final CustomStyle = GoogleFonts.comfortaa(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
              color: Colors.black45,
            ),
          if(_isEdit)
          IconButton(
            onPressed: () {
              _deleteNote();
              Navigator.pop(context, true);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.black45,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: TextFormField(
                      initialValue: _title ?? "",
                      style: GoogleFonts.comfortaa(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: "Введите заголовок",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black
                            )
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black
                            )
                        ),

                      ),
                      onChanged: _changeTitle,
                    ),
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
                        placeholder: 'Запишите всю важную для вас информацию...',
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      final jsonStr =
                          jsonEncode(_controller.document.toDelta().toJson());
                      if (_isEdit)
                        _updateNote(jsonStr);
                      else
                        _addNote(jsonStr);
                      Navigator.pop(context, true);
                    },
                    backgroundColor: const Color(0xFF93D7FF),
                    elevation: 0,
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 5),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: const Color(0xFF6A7791),
                    elevation: 0,
                    child: Transform.rotate(
                      angle: 45 * 3.1415926535 / 180,
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}