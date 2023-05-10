import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Note{
  late final String id;
  late final String title;
  late final String desc;
  late final String date;
  late final bool isImportant;

  Note({required this.id, required this.title, required this.desc, required this.date, required this.isImportant
  });

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    desc: json['desc'],
    date: json['date'],
    isImportant: _boolFromJson(json['isImportant']),
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'isImportant': _boolToJson(isImportant)
    };
  }

  static int _boolToJson(bool value) {
    if (value == true) {
      return 1;
    } else {
      return 0;
    }
  }

  static bool _boolFromJson(int value) {
    if (value == 1) {
      return true;
    } else {
      return false;
    }
  }
}

class DatabaseHelperNote{
  DatabaseHelperNote._privateConstructor();
  static final DatabaseHelperNote instance = DatabaseHelperNote._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE note(
    id TEXT,
    title TEXT,
    desc TEXT,
    date TEXT,
    isImportant INT
    )
    ''');
  }


  Future<List<Note>> getNotes() async{
    Database db = await instance.database;
    var notes = await db.query('note', orderBy: "isImportant DESC, date DESC");
    List<Note> noteList = notes.isNotEmpty
        ? notes.map((c) => Note.fromMap(c)).toList()
        : [];
    return noteList;
  }

  Future<int> add(Note note) async {
    Database db = await instance.database;
    return await db.insert('note', note.toMap() );
  }

  Future<int> remove(String id) async{
    Database db = await instance.database;
    return await db.delete('note', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async{
    Database db = await instance.database;
    return await db.update('note', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}

class NoteFirebase{
  final firestore = FirebaseFirestore.instance;

  getUserCollection(String login){
    var noteSnapshot = firestore.collection('user').doc(login).collection('note');
    return noteSnapshot;
  }

  Future<List<Note>> getNoteList(String login)async {
    var noteSnapshot = await firestore.collection('user').doc(login).collection('note').get();
    if (noteSnapshot.docs.isEmpty) {
      return [];
    }
    List<Note> noteList = noteSnapshot.docs.map((doc) {
      Note note = Note.fromMap(doc.data());
      return note;
    }).toList();
    return noteList;
  }

  Future<void> setDataNoteList(String login, Note note) async{
    print("setData");
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(note.id)
        .set({'id': note.id, 'title': note.title, 'desc': note.desc, 'date': note.date, 'isImportant': note.isImportant});
  }

  Future<void> updateNote(String login, Note note) async{
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(note.id)
        .update({'id': note.id, 'title': note.title, 'desc': note.desc, 'date': note.date, 'isImportant': note.isImportant});
  }

  Future<void> deleteNote(String login, String noteId) async {
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(noteId)
        .delete();
  }
}
