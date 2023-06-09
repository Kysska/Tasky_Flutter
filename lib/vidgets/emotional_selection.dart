import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasky_flutter/data/emotionaldatabase.dart';

import '../data/notedatabase.dart';
import '../presentation/addnote.dart';

class EmotionSelection extends StatefulWidget {
  final String? login;

  EmotionSelection({required this.login});
  @override
  _EmotionSelectionState createState() => _EmotionSelectionState();
}

class _EmotionSelectionState extends State<EmotionSelection> {
  bool isEmotionVisible = false;
  int emotionalKapibara = 2;
  DatabaseHelperMood mMood = DatabaseHelperMood.instance;
  late DateTime _currentDateTime;
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  List<String> emotionalList = [
    'images/sad_emotions.png',
    'images/less_sad_emotions.png',
    'images/normal_emotions.png',
    'images/less_happy_emotions.png',
    'images/happy_emotions.png'
  ];

  @override
  void initState() {
    super.initState();
    _getEmotional();
    _currentDateTime = DateTime.now();
    insertMood();
  }

  void _precacheGifs(BuildContext context) async {
    for (var gifPath in emotionalList) {
      await precacheImage(AssetImage(gifPath), context);
    }
  }



  Future<void> insertMood() async{
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String? lastId = await mMood.getLastMoodId();
    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(const Duration(days: 7));
    if(lastId == null){
      for (int i = 7; i >= 0; i--) {
        DateTime previousDay = today.subtract(Duration(days: i));
        String formattedPreviousDay = formatter.format(previousDay);
        await mMood.add(formattedPreviousDay, 3);
      }
    }
    else{
      DateTime dateTime = formatter.parse(lastId);
      if(dateTime.isBefore(sevenDaysAgo)){
        for (int i = 7; i >= 0; i--) {
          DateTime previousDay = today.subtract(Duration(days: i));
          String formattedPreviousDay = formatter.format(previousDay);
          await mMood.add(formattedPreviousDay, 3);
        }
      }
      else if(dateTime.isAfter(sevenDaysAgo)){
        Duration difference = today.difference(dateTime);
        int numberOfDays = difference.inDays;
        if(numberOfDays == 0){
          return;
        }
        for (int i = numberOfDays; i >= 0; i--) {
          DateTime previousDay = today.subtract(Duration(days: i));
          String formattedPreviousDay = formatter.format(previousDay);
          await mMood.add(formattedPreviousDay, 3);
        }
      }
    }
  }


  Future _getEmotional() async{
    int? emotional = await mMood.getLastMood();
    if(emotional != null){
      emotionalKapibara = emotional - 1;
    }
    setState(() {});
  }

  void changeEmotionVisible() {
    setState(() {
      isEmotionVisible = !isEmotionVisible;
    });
  }

  String _getMonthName(now) {
    int currentMonth = now.month;
    List<String> monthNames = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];

    return monthNames[currentMonth - 1];
  }

  @override
  Widget build(BuildContext context) {
    _precacheGifs(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Note note = Note(id: "", title: "", desc: "", date: DateTime.now().toString(), isImportant: false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote(note: note, isEdit: false, login: widget.login!,)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0x88FFFFFF),
                  elevation: 0,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Запиши свои\nмысли          >',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.comfortaa(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
           SizedBox(
                    width: 80,
                    height: 50,
                    child: GestureDetector(
                      onTap: changeEmotionVisible,
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(emotionalList[emotionalKapibara]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              width: 120,
              height: 50,
              child: ElevatedButton(
                onPressed: changeEmotionVisible,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0x88FFFFFF),
                  elevation: 0,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Какой ты сегодня?',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.comfortaa(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Stack(
            children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1, left: 15),
                    child: Row(
                      children: [
                        Text(
                          "${_currentDateTime.day} ${_getMonthName(_currentDateTime)}",
                          style: GoogleFonts.comfortaa(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 15),
                    child: Text(
                      "${_currentDateTime.year}",
                      style: GoogleFonts.comfortaa(
                        color: const Color(0xFF747686),
                        fontSize: 18,
                      ),
                    ),
                  ),
              Visibility(
                visible: isEmotionVisible,
                child: SizedBox(
                  height: 80,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              Visibility(
                visible: isEmotionVisible,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, left: 10.0),
                  child: ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonPadding: const EdgeInsets.only(right: 2),
                    children: [
                      GestureDetector(
                        onTap: () async{
                          setState(() {
                            emotionalKapibara = 0;
                          });
                          await mMood.add(formattedDate, 1);
                        },
                        child: Container(
                          width: 72,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(emotionalList[0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          setState(() {
                            emotionalKapibara = 1;
                          });
                          await mMood.add(formattedDate, 2);
                        },
                        child: Container(
                          width: 72,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(emotionalList[1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          setState(() {
                            emotionalKapibara = 2;
                          });
                          await mMood.add(formattedDate, 3);
                        },
                        child: Container(
                          width: 72,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(emotionalList[2]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          setState(() {
                            emotionalKapibara = 3;
                          });
                          await mMood.add(formattedDate, 4);
                        },
                        child: Container(
                          width: 72,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(emotionalList[3]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          setState(() {
                            emotionalKapibara = 4;
                          });
                          await mMood.add(formattedDate, 5);
                        },
                        child: Container(
                          width: 72,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(emotionalList[4]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
