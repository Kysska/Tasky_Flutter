import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EatInInventory{
  late String title;
  late String asset;
  late int money;
  late int count;

  EatInInventory({
    required this.title, required this.asset, required this.money, required this.count
  }) {
    money = int.parse(money.toString());
  }

  factory EatInInventory.fromMap(Map<String, dynamic> json) => EatInInventory(
    title: json['title'],
    asset: json['asset'],
    money: json['money'],
    count: json['count'],
  );

  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'asset': asset,
      'money': money,
      'count': count,
    };
  }
}


class ClothesInInventory{
  late String title;
  late String asset;
  late int money;

  ClothesInInventory({
    required this.title, required this.asset, required this.money
  }) {
    money = int.parse(money.toString());
  }

  factory ClothesInInventory.fromMap(Map<String, dynamic> json) => ClothesInInventory(
    title: json['title'],
    asset: json['asset'],
    money: json['money'],
  );

  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'asset': asset,
      'money': money,
    };
  }

}

class InventoryDatabase{
  InventoryDatabase._privateConstructor();
  static final InventoryDatabase instance = InventoryDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'foodInInventory.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE foodInInventory(
    title TEXT,
    money INT,
    asset TEXT,
    count INT
    )
    ''');
  }


  Future<List<EatInInventory>> getEatList() async{
    Database db = await instance.database;
    var foods = await db.query('foodInInventory');
    List<EatInInventory> foodsList = foods.isNotEmpty
        ? foods.map((c) => EatInInventory.fromMap(c)).toList()
        : [];
    return foodsList;
  }

  Stream<List<EatInInventory>> getEatListStream() async*{
    Database db = await instance.database;
    var foods = await db.query('foodInInventory');
    List<EatInInventory> foodsList = foods.isNotEmpty
        ? foods.map((c) => EatInInventory.fromMap(c)).toList()
        : [];
    yield foodsList;
  }

  Future<int> add(EatInInventory eat) async {
    Database db = await instance.database;
    return await db.insert('foodInInventory', eat.toMap() );
  }


  Future<void> updateCount(int count, String title) async{
    Database db = await instance.database;
    await db.rawUpdate('UPDATE foodInInventory SET count = ? WHERE title = ?', [count, title]);
  }

  Future<bool> checkIfExists(String title) async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT COUNT(*) FROM foodInInventory WHERE title = ?', [title]);
    int count = Sqflite.firstIntValue(result)!;
    if (count == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> getCount(String title) async{
    Database db = await instance.database;
    final maps = await db.query('foodInInventory', columns: ['count'], where: 'title = ?', whereArgs: [title] );
    return maps[0]['count'] as int;
  }

}


class InventoryClothesDatabase{
  InventoryClothesDatabase._privateConstructor();
  static final InventoryClothesDatabase instance = InventoryClothesDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'clothesInInventory.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE clothesInInventory(
    title TEXT,
    money INT,
    asset TEXT
    )
    ''');
  }


  Future<List<ClothesInInventory>> getEatList() async{
    Database db = await instance.database;
    var foods = await db.query('clothesInInventory');
    List<ClothesInInventory> foodsList = foods.isNotEmpty
        ? foods.map((c) => ClothesInInventory.fromMap(c)).toList()
        : [];
    return foodsList;
  }

  Stream<List<ClothesInInventory>> getEatListStream() async*{
    Database db = await instance.database;
    var foods = await db.query('clothesInInventory');
    List<ClothesInInventory> foodsList = foods.isNotEmpty
        ? foods.map((c) => ClothesInInventory.fromMap(c)).toList()
        : [];
    yield foodsList;
  }

  Future<int> add(ClothesInInventory eat) async {
    Database db = await instance.database;
    return await db.insert('clothesInInventory', eat.toMap() );
  }



  Future<bool> checkIfExists(String title) async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT COUNT(*) FROM clothesInInventory WHERE title = ?', [title]);
    int count = Sqflite.firstIntValue(result)!;
    if (count == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfExistsAsset(String asset) async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT COUNT(*) FROM clothesInInventory WHERE asset = ?', [asset]);
    int count = Sqflite.firstIntValue(result)!;
    if (count == 1) {
      return true;
    } else {
      return false;
    }
  }

}

class InventoryFirebase{
  final firestore = FirebaseFirestore.instance;

  getUserCollection(String login){
    var eatSnapshot = firestore.collection('user').doc(login).collection('eat');
    return eatSnapshot;
  }

  Future<List<EatInInventory>> getEatList(String login)async {
    var eatSnapshot = await firestore.collection('user').doc(login).collection('eat').get();
    List<EatInInventory> eatList =  eatSnapshot.docs
        .map((e) => EatInInventory.fromMap(e.data())).toList();
    return eatList;
  }

  // Stream<List<EatInInventory>> getEatListStream(String login) async* {
  //   var eatSnapshot = await firestore.collection('user').doc(login).collection('eat').get();
  //   List<EatInInventory> foodList =  eatSnapshot.docs
  //       .map((e) => EatInInventory.fromMap(e.data())).toList();
  //   print(foodList);
  //   yield foodList;
  // }

  Future<void> setDataEatList(String login, EatInInventory eat) async{
    var userSnapshot = getUserCollection(login);
    print('object');
    await userSnapshot.doc(eat.title)
        .set({'title': eat.title, 'asset': eat.asset, 'money': eat.money, 'count': 1});
  }

  Future<void> updateCountEat(String login, int count, String eatName) async{
    var userSnapshot = getUserCollection(login);
    await userSnapshot.doc(eatName)
        .update({'count': count});
  }

  // Future<bool> getCheckFood(String login, String eatName) async{
  //   var userSnapshot = getUserCollection(login);
  //   var doc = await userSnapshot.doc(eatName).get();
  //   return doc.exists ? true : false;
  // }
  //
  // Future<int> getCount(String login, String eatName) async{
  //   var userSnapshot = getUserCollection(login);
  //   return await userSnapshot.doc(eatName).data['count'];
  // }


}