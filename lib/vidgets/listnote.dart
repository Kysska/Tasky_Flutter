import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:tasky_flutter/data/notedatabase.dart';
import 'package:google_fonts/google_fonts.dart';

import '../presentation/addnote.dart';

class ListNote extends StatefulWidget {
  final String login;

  const ListNote({Key? key, required this.login}) : super(key: key);

  @override
  ListNoteState createState() => ListNoteState();
}

class ListNoteState extends State<ListNote> {
  String searchText = "";
  late List<Note>? notes;
  List<Note>? searchNotes = [];
  late List<Note>? fullNotes = [];
  DatabaseHelperNote mNote = DatabaseHelperNote.instance;
  late int countNote = 0;

  @override
  void initState() {
    super.initState();
    _getStatictics();
  }

  _getStatictics() async{
    countNote = await mNote.countTasks();
    setState(() {});
  }

  _runFilter(String text) {
    searchNotes?.clear();
    searchText = text;
    setState(() {
      searchNotes = fullNotes
          ?.where((element) =>
              element.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  _refreshPage() {
    Future.delayed(const Duration(milliseconds: 10));
    _getStatictics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x000000ff),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: false,
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Блокнот",
                  style: GoogleFonts.comfortaa(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Заметок:$countNote",
                  style: GoogleFonts.comfortaa(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xff6A7791),
                  ),
                ),
              ],
              /*
                  */
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
            child: SizedBox(
              width: 10,
              height: 40,
              child: Center(
                child: TextField(
                  onChanged: (text) {
                    _runFilter(text);
                  },
                  cursorColor: Colors.black,
                  style: GoogleFonts.comfortaa(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    iconColor: Colors.black,
                    hintText: 'Найди свою заметку',
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.black,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          FutureBuilder<List<Note>>(
            future: mNote.getNotes(),
            builder: (context, snapshot) {
              if (searchText.isEmpty) {
                notes = snapshot.data;
                fullNotes = snapshot.data;
              } else {
                notes = searchNotes;
              }
              if (notes == null) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.grey),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (notes!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                for (int i = 0; i < notes!.length; i += 2)
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddNote(
                                                      note: notes![i],
                                                      isEdit: true,
                                                      login: widget.login,
                                                    ))).then((value) => {
                                              if (value != null &&
                                                  value == true)
                                                {_refreshPage()}
                                            });
                                      },
                                      // => Get.to(() => DetailsScreen(id: note.id)),
                                      child: BaseContainer(note: notes![i])),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                for (int i = 1; i < notes!.length; i += 2)
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddNote(
                                                      note: notes![i],
                                                      isEdit: true,
                                                      login: widget.login,
                                                    ))).then((value) => {
                                              if (value != null &&
                                                  value == true)
                                                {_refreshPage()}
                                            });
                                      },
                                      // => Get.to(() => DetailsScreen(id: note.id)),
                                      child: BaseContainer(note: notes![i])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (notes!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 250),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ещё нет заметок, добавим?",
                          style: GoogleFonts.comfortaa(
                            color: const Color(0xff6A7791),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Text('No Data Found');
            },
          ),
        ]))
      ]),
    );
  }
}

class BaseContainer extends StatelessWidget {
  final Note note;

  const BaseContainer({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late QuillController controller;
    controller = QuillController(
      document: Document.fromJson(jsonDecode(note.desc)),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26.withOpacity(0.05),
                  offset: const Offset(0.0, 6.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.10)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 4,
              ),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  note.title.length >= 8 ? '${note.title.substring(0, 8)}..' : note.title,
                  style: const TextStyle(fontSize: 22),
                ),
                if (note.isImportant)
                  const Icon(
                    Icons.push_pin_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                if (note.isImportant == false)
                  const Icon(
                    Icons.push_pin_outlined,
                    color: Colors.black12,
                    size: 20,
                  ),
              ]),
              const SizedBox(height: 5),
              Text(
                note.date,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 15),
              QuillEditor(
                controller: controller,
                readOnly: true,
                enableInteractiveSelection: false,
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                scrollable: true,
                padding: EdgeInsets.zero,
                autoFocus: false,
                expands: false,
                maxHeight: 170,
              )
            ],
          ),
        ),
      ),
    );
  }
}
