import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class Game{
  final hungerScale;
  final assetSkin;
  final assetRoom;

  Game({this.hungerScale, this.assetSkin, this.assetRoom});

  Future setHungerScale() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('hungerScale', hungerScale);
  }

  Future setAssetSkin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('assetSkin', assetSkin);
  }

  Future setAssetRoom() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('assetRoom', assetRoom);
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
}