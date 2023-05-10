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
  // late final List<ImageProvider> gifProviders;

  @override
  void initState() {
    super.initState();

    // gifProviders = gifList.map((gif) => AssetImage(gif)).toList();
    //
    // for (final provider in gifProviders) {
    //   precacheImage(provider, context);
    // }

    Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _currentGifIndex =
            (_currentGifIndex + 1) % gifList.length;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Image.asset(
          gifList[_currentGifIndex],
        );
  }
}