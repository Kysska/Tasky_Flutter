import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Habit{
  late final String id;
  late final String title;
  late final String desc;
  late final String date; //TODO продолжительность
  late final List<String> isCompleted;

  Habit({required this.id, required this.title,
    required this.desc, required this.date, required this.isCompleted
  });

  factory Habit.fromMap(Map<String, dynamic> json) => Habit(
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

class HabitFirebase{
  final firestore = FirebaseFirestore.instance;

  getUserCollection(String login){
    var habitSnapshot = firestore.collection('user').doc(login).collection('habit');
    return habitSnapshot;
  }

  Future<List<Habit>> getHabitList(String login)async {
    var habitSnapshot = await firestore.collection('user').doc(login).collection('habit').get();
    List<Habit> habitList = habitSnapshot.docs.map((doc) {
      Habit habit = Habit.fromMap(doc.data());
      return habit;
    }).toList();
    return habitList;
  }

  Future<void> setDataHabitList(String login, Habit habit) async{
    var userSnapshot = getUserCollection(login);
    await userSnapshot
        .add({'title': habit.title, 'desc': habit.desc, 'date': habit.date, 'isImportant': habit.isCompleted});
  }

  Future<void> updateCountHabit(String login, Habit habit) async{
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(habit.id)
        .update({'title': habit.title, 'desc': habit.desc, 'date': habit.date, 'isImportant': habit.isCompleted});
  }

  Future<void> deleteHabit(String login, String habitId) async {
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(habitId)
        .delete();
  }

}
class DatabaseHelperHabit{
  DatabaseHelperHabit._privateConstructor();
  static final DatabaseHelperHabit instance = DatabaseHelperHabit._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'habit.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE habit(
    id TEXT,
    title TEXT
    desc TEXT,
    date DATETIME,
    isCompleted BOOL
    )
    '''); //TODO isCompleted is List
  }



  Future<List<Habit>> getHabit() async{
    Database db = await instance.database;
    var habits = await db.query('habit');
    List<Habit> habitList = habits.isNotEmpty
        ? habits.map((c) => Habit.fromMap(c)).toList()
        : [];
    return habitList;
  }

  Future<int> add(Habit habit) async {
    Database db = await instance.database;
    return await db.insert('habit', habit.toMap() );
  }

  Future<int> remove(String id) async{
    Database db = await instance.database;
    return await db.delete('habit', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Habit habit) async{
    Database db = await instance.database;
    return await db.update('habit', habit.toMap(), where: 'id = ?', whereArgs: [habit.id]);
  }
}