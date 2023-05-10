import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/notedatabase.dart';

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
  late List<Note>? searchNotes = [];
  late List<Note>? fullNotes = [];


  _runFilter(String text){
    print(text);
    searchNotes?.clear();
    setState(() {
      searchNotes = fullNotes?.where((element) =>
          element.title.toLowerCase().contains(text.toLowerCase())).toList();
      print(searchNotes);
    });
  }

  _refreshPage(){
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              bottom: AppBar(
                title: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                  child: Center(
                    child: TextField(
                      onChanged: (text){
                        _runFilter(text);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search for something',
                        prefixIcon: Icon(Icons.search),),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([ FutureBuilder<List<Note>>(
                  future: DatabaseHelperNote.instance.getNotes(),
                  builder: (context, snapshot) {
                    if(searchNotes!.isEmpty){
                      notes = snapshot.data;
                      fullNotes = snapshot.data;
                    }
                    else{
                      notes = searchNotes;
                    }
                    if (notes == null) {
                      return const Center(
                        child: SizedBox(
                          height: 200,
                          child: CircularProgressIndicator(color: Colors.grey),
                        ),
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
                                            onTap:
                                                () {
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddNote(note: notes![i], isEdit: true, login: widget.login,))).then((
                                                  value) =>
                                              {
                                                if(value!=null && value == true){
                                                  _refreshPage()
                                                }
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
                                            onTap:
                                                () {
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddNote(note: notes![i], isEdit: true, login: widget.login,))).then((
                                                  value) =>
                                              {
                                                if(value!=null && value == true){
                                                  _refreshPage()
                                                }
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No notes",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20),
                            Text("Tap the Add button to create a note",
                                style:
                                TextStyle(color: Colors.grey.shade500, fontSize: 17)),
                          ],
                        ),
                      );
                    }
                    return const Text('No Data Found');
                  },
                ),]
                )
            )
          ]
      ),
    );
  }
}

class BaseContainer extends StatelessWidget {
  final Note note;

  const BaseContainer({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final time = DateFormat.Hm().format(note.createdTime);
    // final dateTime = DateFormat('yMMMd').format(note.date.toString() as DateTime);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.55,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
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
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[ Text(
                    note.title,
                    style: TextStyle(fontSize: 22),
                  ),
                    if (note.isImportant)
                      const Icon(
                        Icons.push_pin_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    if(note.isImportant == false)
                      const Icon(
                        Icons.push_pin_outlined,
                        color: Colors.black12,
                        size: 20,
                      ),
                  ]
              ),
              const SizedBox(height: 5),
              Text(
                note.date,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 15),
              Text(
                note.desc,
                style: TextStyle(fontSize: 16)
                    .copyWith(overflow: TextOverflow.fade),
              ),
            ],
          ),
        ),
      ),
    );
  }
}