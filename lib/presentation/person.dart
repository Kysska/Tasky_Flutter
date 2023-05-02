
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Person extends StatefulWidget{
  const Person({super.key});


  @override
  _PersonState createState() => _PersonState();

}
class _PersonState extends State<Person> {

  late File _image;

  _imgFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final image = await  picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = File(image!.path);
    });
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
                child: _image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
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
