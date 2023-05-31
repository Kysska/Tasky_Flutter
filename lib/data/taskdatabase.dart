import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task{
  late final String id;
  late final String title;
  late final String date;
  final String time;
  final String tag;
  late final bool isCompleted;
  final List<String> daysOfWeek;

  Task ( {required this.id, required this.title,
    required this.date, required this.isCompleted, required this.time, required this.tag, required this.daysOfWeek
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    date: json['date'],
    time: json['time'],
    tag: json['tag'],
    isCompleted: _boolFromJson(json['isCompleted']),
    daysOfWeek: json['daysOfWeek']?.split(','),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'tag': tag,
      'isCompleted': _boolToJson(isCompleted),
      'daysOfWeek': daysOfWeek.join(','),
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

class TaskFirebase{
  final firestore = FirebaseFirestore.instance;

  getUserCollection(String login){
    var taskSnapshot = firestore.collection('user').doc(login).collection('task');
    return taskSnapshot;
  }

  Future<List<Task>> getTaskList(String login)async {
    var taskSnapshot = await firestore.collection('user').doc(login).collection('task').get();
    List<Task> taskList = taskSnapshot.docs.map((doc) {
      Task task = Task.fromMap(doc.data());
      return task;
    }).toList();
    return taskList;
  }

  Future<void> setDataTaskList(String login, Task task) async{
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(task.id)
        .set(task.toMap());
  }

  Future<void> updateTask(String login, Task task) async{
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String login, String taskId) async {
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(taskId)
        .delete();
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
    id TEXT,
    title TEXT,
    date TEXT,
    time TEXT,
    tag TEXT,
    daysOfWeek TEXT,
    isCompleted BOOL
    )
    ''');
  }



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

  Future<int> remove(String id) async{
    Database db = await instance.database;
    return await db.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async{
    Database db = await instance.database;
    return await db.update('task', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> updateCompleted(String title, int isCompleted) async{
    Database db = await instance.database;
    await db.rawUpdate('UPDATE task SET isCompleted = ? WHERE title = ?', [isCompleted, title]);
  }
}