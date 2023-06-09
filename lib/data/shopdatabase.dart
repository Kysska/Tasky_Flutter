import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class ShopFirebase{

  final firestore = FirebaseFirestore.instance;

  Future<List<EatInShop>> getEatList()async {
    var eatSnapshot = await firestore.collection('eat').get();
    List<EatInShop> eatList =  eatSnapshot.docs
    .map((e) => EatInShop.fromMap(e.data())).toList();
        return eatList;
  }

  Future<List<EatInShop>> getMedicList()async {
    var medSnapshot = await firestore.collection('medicaments').get();
    List<EatInShop> medList =  medSnapshot.docs
        .map((e) => EatInShop.fromMap(e.data())).toList();
    return medList;
  }

  Future<List<ClothesInShop>> getClothesList()async {
    var eatSnapshot = await firestore.collection("clothers")
        .orderBy("isBuy", descending: true).get();
    List<ClothesInShop> eatList =  eatSnapshot.docs
        .map((e) => ClothesInShop.fromMap(e.data())).toList();
    return eatList;
  }

}


class EatInShop{
  late String title;
  late String asset;
  late int money;

  EatInShop({
    required this.title, required this.asset, required this.money,
}) {
    money = int.parse(money.toString());
  }

  factory EatInShop.fromMap(Map<String, dynamic> json) => EatInShop(
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

class ClothesInShop{
  late String title;
  late String asset;
  late int money;
  late bool isBuy;

  ClothesInShop({
    required this.title, required this.asset, required this.money, required this.isBuy
  }) {
    money = int.parse(money.toString());
  }

  factory ClothesInShop.fromMap(Map<String, dynamic> json) => ClothesInShop(
    title: json['title'],
    asset: json['asset'],
    money: json['money'],
    isBuy: json['isBuy'],
  );

  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'asset': asset,
      'money': money,
      'isBuy': isBuy,
    };
  }


}

