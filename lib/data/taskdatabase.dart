import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task{
  late final String id;
  late final String title;
  late final String desc;
  late final String date;
  late final bool isCompleted;

  Task({required this.id, required this.title,
    required this.desc, required this.date, required this.isCompleted
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json['id'],
      title: json['title'],
      desc: json['desc'],
      date: json['date'],
      isCompleted: json['isCompleted']
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'isCompleted': isCompleted,
    };
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
    await userSnapshot
        .add({'title': task.title, 'desc': task.desc, 'date': task.date, 'isImportant': task.isCompleted});
  }

  Future<void> updateCountTask(String login, Task task) async{
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(task.id)
        .update({'title': task.title, 'desc': task.desc, 'date': task.date, 'isImportant': task.isCompleted});
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
    title TEXT
    desc TEXT,
    date DATETIME,
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
}