import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/userdatabase.dart';

class Person extends StatefulWidget{
  const Person({super.key});


  @override
  _PersonState createState() => _PersonState();

}
class _PersonState extends State<Person> {


  // Future<void> getUser() async{
  //  await user = DatabaseHelperUser.instance.getUser();
  // }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Center(
        child: Column(
          children: [
            Text("")
          ],
        ),
      ),

    );
  }

}