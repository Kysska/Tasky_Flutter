
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Person extends StatefulWidget{
  const Person({super.key});


  @override
  _PersonState createState() => _PersonState();

}
class _PersonState extends State<Person> {

  late File _image = File('');
  late String _imagePath;
  var _imageUrl;

  Future<void> _initImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() {
        _imagePath = imagePath;
        _image = File(imagePath);
      });
    }
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

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('imagePath', _imagePath);
      uploadProfileImage();
    }
  }

  uploadProfileImage() async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('profileImage/$_imagePath');
    UploadTask uploadTask = reference.putFile(_image);
    TaskSnapshot snapshot = await uploadTask;
    _imageUrl = await snapshot.ref.getDownloadURL();
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
                child: _image != null && _image.path.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _image,
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
