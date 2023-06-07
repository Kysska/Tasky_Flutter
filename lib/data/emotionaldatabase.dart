import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Mood{
  late final int id;
  late final String date;
  late final int mood;

  Mood({required this.id, required this.mood, required this.date
  });

  factory Mood.fromMap(Map<String, dynamic> json) => Mood(
    id: json['id'],
    mood: json['mood'],
    date: json['date'],
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'mood': mood,
      'date': date
    };
  }
}
class DatabaseHelperMood{
  DatabaseHelperMood._privateConstructor();
  static final DatabaseHelperMood instance = DatabaseHelperMood._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'mood.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE mood(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    mood INT
    )
    ''');
  }


  Future<List<int>> getMood() async {
    Database db = await instance.database;
    var moods = await db.query(
      'mood',
      columns: ['mood'],
      orderBy: 'id DESC',
      limit: 7
    );
    List<int> moodList = moods.isNotEmpty
        ? moods.map((e) => e['mood'] as int).toList().reversed.toList()
        : [];
    return moodList;
  }

  Future<int?> getLastMood() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> moods = await db.query('mood', columns: ['mood'], orderBy: 'id ASC');
    List<int> moodList = moods.isNotEmpty
        ? moods.map((e) => e['mood'] as int).toList()
        : [];
    if(moodList.isEmpty) {
      return 3;
    } else {
      return moodList.last;
    }
  }

  Future<String?> getLastMoodId() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> moods = await db.query('mood', columns: ['date'], orderBy: 'id ASC');
    List<String> moodList = moods.isNotEmpty
        ? moods.map((e) => e['date'] as String).toList()
        : [];
    print(moodList);
    if(moodList.isEmpty) {
      return null;
    } else {
      return moodList.last;
    }
  }
  Future<int> add(String date, int mood) async {
    Database db = await database;

    List<Map<String, dynamic>> existingRows = await db.query(
      'mood',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (existingRows.isNotEmpty) {
      return await db.update(
        'mood',
        {'mood': mood},
        where: 'date = ?',
        whereArgs: [date],
      );
    }

    return await db.insert(
      'mood',
      {'date': date, 'mood': mood},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}