import 'package:cloud_firestore/cloud_firestore.dart';

class ShopDatabase{

  final firestore = FirebaseFirestore.instance;

  Future<List<Eat>> getEatList()async {
    var eatSnapshot = await firestore.collection('eat').get();
    List<Eat> eatList =  eatSnapshot.docs
    .map((e) => Eat.fromMap(e.data())).toList();
        return eatList;
  }


}

class Eat{
  late String name;
  late String asset;
  late int money;

  Eat({
    required this.name, required this.asset, required this.money
}) {
    money = int.parse(money.toString());
  }

  factory Eat.fromMap(Map<String, dynamic> json) => Eat(
    name: json['name'],
    asset: json['asset'],
    money: json['money'],
  );

  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'asset': asset,
      'money': money,
    };
  }
}