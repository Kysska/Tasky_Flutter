import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User{
  late final int? id;
  late final String login;
  late final String avatar;

  User({this.id, required this.login, required this.avatar,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json['id'],
    login: json['login'],
    avatar: json['avatar'],
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'login': login,
      'avatar': avatar,
    };
  }


}

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  set user(User? value) {
    _user = value;
    notifyListeners();
  }
}

 class SHUser{

   Future setUserLogin(String login) async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     preferences.setString('login', login);
   }

   Future<String?> getUserLogin() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     String? loginUser = preferences.getString('login');
     return loginUser;
   }
 }

 class UserFirebase{

   final firestore = FirebaseFirestore.instance;

   getUser(String login){
     return firestore.collection('user')
         .doc(login).get();
   }
  Future<bool> checkUserLogin(String login) async{
    var userSnapshot = await getUser(login);
    return userSnapshot.exists;
 }
  Future<void> setUserData(String login, String password) async{
    firestore.collection('user')
        .doc(login).set({'login': login, 'password': hashPassword(password), 'avatar': 'images/default_avatar'});
  }
  
  Future<bool> checkUserPassword(String login, String password) async{
    // var userSnapshot = await firestore.collection('user')
    //     .doc(login).get();
    var userSnapshot = await getUser(login);
    String passwordHash = userSnapshot['password'];
    return checkHashPassword(password, passwordHash );
  }

  Future<User> getUserData(String login) async {
    var docSnapshot = await getUser(login);
    var userSnapshot = docSnapshot.data()!;
    return User(login: userSnapshot['login'], avatar: userSnapshot['avatar']);
  }

  String hashPassword(String password) {
     var salt = BCrypt.gensalt();
     return BCrypt.hashpw(password, salt);
   }

   bool checkHashPassword(String password, String hash) {
     return BCrypt.checkpw(password, hash);
   }
 }

// class UserFirebase{
//
//   Future<User> getUser(String login) async{
//     final firestore = Firestore.instance;
//     var userSnapshot = firestore.collection('users').document(login).getCollection('info');
//     DocumentSnapshot snapshot = await userSnapshot.document(index).get()
//     return User(login: userSnapshot.data('login'), password: userSnapshot.data('password'), avatar: userSnapshot.data('avatar'))
//   }
//
//   Future<void> addUser(User user) async{
//     Firestore firestore = Firestore.instance;
//
//     firestore.collection('users').document(user.login).setData({
//       'login': user.login,
//       'password': user.password,
//       'avatar': user.avatar
//     });
//   }
//
// }