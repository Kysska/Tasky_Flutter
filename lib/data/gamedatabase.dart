import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_flutter/data/userdatabase.dart';

class GameDatabase{

  Future setHungerScale(hungerScale) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('hungerScale', hungerScale);
  }

  Future setAssetSkin(assetSkin) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('assetSkin', assetSkin);
  }

  Future setAssetRoom(assetRoom) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('assetRoom', assetRoom);
  }

  Future setNamePet(String namePet) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('namePet', namePet);
  }

  Future setMoney(int money) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('money', money);
  }

  Future getHungerScale() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getInt('hungerScale');
  }

  Future getAssetSkin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString('assetSkin');
  }

  Future getAssetRoom() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString('assetRoom');
  }

  Future getNamePet() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString('namePet');
  }

  Future getMoney() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getInt('money');
  }
}

class GameFirebase{

  final firestore = FirebaseFirestore.instance;

  Future setGameState(String login, String namePet) async{
  firestore.collection('user')
      .doc(login).set({'namePet': namePet, 'money': 500, 'assetSkin': 'images/default_capibara.png'});
  //TODO комната
}

}