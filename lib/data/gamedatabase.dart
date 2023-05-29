
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameDatabase{

  Future setHpScale(hungerScale) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('hpScale', hungerScale);
  }

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

  Future<int?> getHpScale() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('hpScale');
  }

  Future<int?> getHungerScale() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('hungerScale');
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
    return preferences.getInt('money');
  }

  Future<int?> getLastHunger() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('lastHunger');
  }

  Future setLastHunger(int lastHunger) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt('lastHunger', lastHunger);
  }
}

class GameFirebase{

  final firestore = FirebaseFirestore.instance;

  Future setGameState(String login, String namePet) async{
  firestore.collection('user')
      .doc(login).update({'namePet': namePet, 'money': 500, 'assetSkin': 'images/default_capibara.png'});
  //TODO комната
}

}