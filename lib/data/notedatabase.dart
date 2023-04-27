import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Note{
  late final int? id;
  late final String name;
  late final String desc;
  late final String date;
  late final bool isImportant;

  Note({this.id, required this.name, required this.desc, required this.date, required this.isImportant
  });

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json['id'],
    name: json['name'],
    desc: json['desc'],
    date: json['date'],
    isImportant: _boolFromJson(json['isImportant']),
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
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
    id INTEGER PRIMARY KEY,
    name TEXT,
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

  Future<int> remove(int id) async{
    Database db = await instance.database;
    return await db.delete('note', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async{
    Database db = await instance.database;
    return await db.update('note', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}