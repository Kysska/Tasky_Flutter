import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class User{
  late final int? id;
  late final String login;
  late final String password;
  late final String avatar;

  User({this.id, required this.login, required this.password, required this.avatar,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json['id'],
    login: json['login'],
    password: json['password'],
    avatar: json['avatar'],
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'login': login,
      'password': password,
      'avatar': avatar,
    };
  }

}

class DatabaseHelperUser{
  DatabaseHelperUser._privateConstructor();
  static final DatabaseHelperUser instance = DatabaseHelperUser._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'user.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user(
    id INTEGER PRIMARY KEY,
    login TEXT,
    password TEXT,
    avatar TEXT
    )
    ''');
  }

  getUser() async {
    int id = 1; //const на время
    final db = await database;
    var res =await  db.query("user", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromMap(res.first) : null ;
  }

  Future<List<User>> getUsers() async{
    Database db = await instance.database;
    var user = await db.query('user');
    List<User> userList = user.isNotEmpty
        ? user.map((c) => User.fromMap(c)).toList()
        : [];
    return userList;
  }

  Future<int> add(User user) async {
    Database db = await instance.database;
    return await db.insert('user', user.toMap() );
  }

  Future<int> checkCount() async{
    Database db = await instance.database;
    int count = Sqflite
        .firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM user')) ?? 0;
    return count;
  }



  Future<int> update(User user) async{
    Database db = await instance.database;
    return await db.update('user', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }
}

class UserFirebase{
  final firestore = FirebaseFirestore.instance;
  firestore.settings = Settings(persistenceEnabled: true);
  DocumentSnapshot userSnapshot = await firestore.collection('users').doc(deviceId).get();
}