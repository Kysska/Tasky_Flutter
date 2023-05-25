
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky_flutter/data/userdatabase.dart';

class Person extends StatefulWidget{
  final String login;
  final String avatar;
  const Person({super.key, required this.login, required this.avatar});


  @override
  _PersonState createState() => _PersonState();

}
class _PersonState extends State<Person> {

  late File _image = File('');
  late String _imagePath;
  var _imageUrl;
  UserFirebase mUser = UserFirebase();

  Future<void> _initImage() async {
    _imageUrl = widget.avatar;
  }

  @override
  void initState() {
    super.initState();
    _initImage();
  }

  Future<void> _imgFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _imagePath = image.path;
      });
      uploadProfileImage();
    }
  }

  uploadProfileImage() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('images').child(uniqueFileName);
    UploadTask uploadTask = reference.putFile(_image);
    TaskSnapshot snapshot = await uploadTask;
    _imageUrl = await snapshot.ref.getDownloadURL();
    mUser.setUserAvatar(widget.login, _imageUrl);
    print(_imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                 _imgFromGallery();
              },
              child: CircleAvatar(
                backgroundColor: Color(0xffFDCF09),
                radius: 50,
                child: _imageUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    _imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }

}
