import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionSelection extends StatefulWidget {
  @override
  _EmotionSelectionState createState() => _EmotionSelectionState();
}

class _EmotionSelectionState extends State<EmotionSelection> {
  bool isEmotionVisible = false;
  String emotionalKapibara = 'images/less_sad_emotions.png';
  late DateTime _currentDateTime;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
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
                  // ToDo: переход на создание новой записи блокнота
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
            SizedBox(
              width: 90,
              height: 50,
              child: GestureDetector(
                onTap: changeEmotionVisible,
                child: Container(
                  width: 75,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(emotionalKapibara),
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
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Stack(
            children: [
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
                        onTap: () {
                          setState(() {
                            emotionalKapibara = 'images/sad_emotions.png';
                          });
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
                        onTap: () {
                          setState(() {
                            emotionalKapibara = 'images/less_sad_emotions.png';
                          });
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
                        onTap: () {
                          setState(() {
                            emotionalKapibara = 'images/normal_emotions.png';
                          });
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
                        onTap: () {
                          setState(() {
                            emotionalKapibara = 'images/less_happy_emotions.png';
                          });
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
                        onTap: () {
                          setState(() {
                            emotionalKapibara = 'images/happy_emotions.png';
                          });
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
