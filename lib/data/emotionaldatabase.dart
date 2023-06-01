import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Mood{
  late final String id;
  late final int mood;

  Mood({required this.id, required this.mood,
  });

  factory Mood.fromMap(Map<String, dynamic> json) => Mood(
    id: json['id'],
    mood: json['mood'],
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'mood': mood,
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
    id TEXT,
    mood INT
    )
    ''');
  }


  Future<List<String>> getMood() async {
    Database db = await instance.database;
    var moods = await db.query('mood');
    List<String> moodList = moods.isNotEmpty
        ? moods.map((e) => e['id']).toList().cast<String>()
        : [];
    return moodList;
  }

  Future<Map<String, dynamic>> getLastMood() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> moods = await db.query('mood', orderBy: 'id DESC', limit: 1);
    return moods.isNotEmpty ? moods.first : {};
  }

  Future<int> add(String id, int mood) async {
    Database db = await database;
    return await db.insert(
      'mood',
      {'id': id, 'mood': mood},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}