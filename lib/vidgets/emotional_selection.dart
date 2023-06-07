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
  bool isFunctionCalled = false;

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
    if (!isFunctionCalled) {
      insertMood();
      isFunctionCalled = true;
    }
  }


  Future<void> insertMood() async{
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String? lastId = await mMood.getLastMoodId();
    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(Duration(days: 7));
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
    return Column(
      children: [
        Row(
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
                  backgroundColor: Color(0x88FFFFFF),
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
            FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 10)),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    width: 90,
                    height: 50,
                    child: GestureDetector(
                      onTap: changeEmotionVisible,
                      child: emotionalKapibara != null ? Container(
                        width: 75,
                        height: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(emotionalList[emotionalKapibara]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ) : Container(),
                    ),
                  );
                } else {
                  return const SizedBox(
                    width: 90,
                    height: 50,
                  );
                }
              },
            ),
            SizedBox(
              width: 120,
              height: 50,
              child: ElevatedButton(
                onPressed: changeEmotionVisible,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0x88FFFFFF),
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
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
                            // ToDo Обработчик нажатия на кнопку календаря
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
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      "${_currentDateTime.year}",
                      style: GoogleFonts.comfortaa(
                        color: Color(0xFF747686),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isEmotionVisible,
                child: SizedBox(
                  height: 80,
                  child: Container(
                    color: Colors.black.withOpacity(0.7), // Фоновый цвет подложки
                  ),
                ),
              ),
              Visibility(
                visible: isEmotionVisible,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, left: 10.0),
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    buttonPadding: EdgeInsets.only(right: 2),
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
                              image: AssetImage('images/sad_emotions.png'),
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
                              image: AssetImage('images/less_sad_emotions.png'),
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
                              image: AssetImage('images/normal_emotions.png'),
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
                              image: AssetImage('images/less_happy_emotions.png'),
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
                              image: AssetImage('images/happy_emotions.png'),
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
