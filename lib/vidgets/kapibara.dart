import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Kapibara extends StatefulWidget{
  const Kapibara({super.key});


  @override
  _KapibaraState createState() => _KapibaraState();

}
class _KapibaraState extends State<Kapibara> {

  late final List<String> gifList = [
    "images/Kapibara_1.gif",
    "images/Kapibara_2.gif"
  ];
  int _currentGifIndex = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 60), (timer) {
      setState(() {
        _currentGifIndex =
            (_currentGifIndex + 1) % gifList.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        gifList[_currentGifIndex],
      ),
    );
  }
}