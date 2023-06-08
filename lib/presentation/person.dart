
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tasky_flutter/data/emotionalDatabase.dart';
import 'package:tasky_flutter/data/habitdatabase.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';
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
  DatabaseHelperTask mTask = DatabaseHelperTask.instance;
  DatabaseHelperHabit mHabit = DatabaseHelperHabit.instance;
  DatabaseHelperMood mMood = DatabaseHelperMood.instance;
  late final emotionValues;
  late int activeTasks = 0;
  late int countTasks = 0;
  late int countHabit = 0;



  Future<void> _initImage() async {
    _imageUrl = widget.avatar;
  }

  Future _getMood() async{
    emotionValues = await mMood.getMood();
  }

  @override
  void initState() {
    super.initState();
    _initImage();
    _getMood();
    _getStatictics();
  }

  _getStatictics() async{
    countTasks = await mTask.countCompletedTasks();
    activeTasks = await mTask.countCompletedTasks();
    countHabit = await mHabit.countTasks();
    setState(() {});
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
    List<Color> gradientColors = [
      Colors.cyan,
      Colors.blue,
    ];
    return Scaffold(
      backgroundColor: Colors.white,

      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
         return Column(
              children: [
                GestureDetector(
                  onTap: (){
                     _imgFromGallery();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    child: _imageUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: _imageUrl,
                        placeholder: (context, url) => const CircularProgressIndicator(color: Colors.black, strokeWidth: 2.0,),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
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
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.login,
                      style: GoogleFonts.comfortaa(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Активных привычек:', style: GoogleFonts.comfortaa(fontSize: 12),),
                              Text(countHabit.toString(),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Выполненных задач:', style: GoogleFonts.comfortaa(fontSize: 12),),
                              Text(activeTasks.toString(),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Активных задач:', style: GoogleFonts.comfortaa(fontSize: 12),),
                              Text(countHabit.toString(),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),

                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Center(
                    child: Text(
                      'Диаграмма настроения',
                      style: GoogleFonts.comfortaa(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: mMood.getMood(),
                  builder: (BuildContext context, snapshot){
                    List<int> mood = (snapshot.data ?? []).map((item) => item as int).toList();
                    print(mood);
                    if (!snapshot.hasData) {
                      return Center(child: Text('Загрузка..'));
                    }
                    return Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                      width: double.infinity,
                      height: 290,
                      child: LineChart(
                        LineChartData(
                            minX: 0,
                            maxX: 6,
                            minY: 1,
                            maxY: 5,
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: const Color(0xff37434d)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 1,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.deepPurple,
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.black54,
                                strokeWidth: 1,
                              );
                            },
                          ),
                            lineBarsData: [
                          LineChartBarData(
                            spots: mood.asMap().entries.map((entry) {
                          final x = entry.key.toDouble();
                          final y = entry.value.toDouble();
                          return FlSpot(x, y);
                        }).toList(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: gradientColors,
                          ),
                          barWidth: 5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: gradientColors
                                  .map((color) => color.withOpacity(0.3))
                                  .toList(),
                            ),
                          ),),
                        ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),

                        ),
                      ),
                    );
                  },
                ),
              ],
            );}
      ),
    );
  }
  SideTitles get _bottomTitles {
    DateTime currentDate = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM');
    String formattedLastDay = formatter.format(currentDate);

    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        int intValue = value.toInt();
        if (intValue == 7) {
          return Text(formattedLastDay);
        } else if (intValue < 7) {
          DateTime day = currentDate.subtract(Duration(days: 6- intValue));
          return Text(formatter.format(day));
        }
        return Text('');
      },
    );
  }
}
