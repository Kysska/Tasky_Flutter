import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Task{
  late final int? id;
  late final String name;
  late final String desc;
  late final DateTime date;
  late final String icon;
  late final String color;
  late final bool isCompleted;

  Task({this.id, required this.name,
    // required this.desc, required this.date, required this.icon, required this.color, required this.isCompleted
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json['id'],
      name: json['name'],
      // desc: json['desc'],
      // date: json['date'],
      // icon: json['icon'],
      // color: json['color'],
      // isCompleted: json['isCompleted']
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      // 'desc': desc,
      // 'date': date,
      // 'icon': icon,
      // 'color': color,
      // 'isCompleted': isCompleted,
    };
  }
}

class DatabaseHelperTask{
  DatabaseHelperTask._privateConstructor();
  static final DatabaseHelperTask instance = DatabaseHelperTask._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'task.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE task(
    id INTEGER PRIMARY KEY,
    name TEXT
    )
    ''');
  }
  // desc TEXT,
  // date DATETIME,
  // icon TEXT,
  // color TEXT,
  // isCompleted BOOL



  Future<List<Task>> getTasks() async{
    Database db = await instance.database;
    var tasks = await db.query('task');
    List<Task> taskList = tasks.isNotEmpty
    ? tasks.map((c) => Task.fromMap(c)).toList()
        : [];
    return taskList;
  }

  Future<int> add(Task task) async {
    Database db = await instance.database;
    return await db.insert('task', task.toMap() );
  }

  Future<int> remove(int id) async{
    Database db = await instance.database;
    return await db.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async{
    Database db = await instance.database;
    return await db.update('task', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }
}