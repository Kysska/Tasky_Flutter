import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky_flutter/presentation/updatehabit.dart';

import '../data/habitdatabase.dart';
import '../vidgets/table_calendar.dart';

class HabitInfo extends StatefulWidget {
  final String? login;
  final int sumCompleted;
  final Habit habit;
  const HabitInfo({super.key, this.login, required this.sumCompleted, required this.habit});

  @override
  _HabitInfoState createState() =>
      _HabitInfoState();
}

class _HabitInfoState extends State<HabitInfo> {

  late int sumCompleted;
  late double percentageCompleted;
  late double percentage2Completed;
  late DateTime firstDate;
  late DateTime now = DateTime.now();
  late var differ;
  late List<DateTime> toHighlight = [];

  @override
  void initState() {
    super.initState();
    sumCompleted = widget.sumCompleted;
    percentageCompleted = sumCompleted / 21;
    percentage2Completed = sumCompleted / 50;
    firstDate = DateTime.parse(widget.habit.id);
    differ = now.difference(firstDate).inDays;
    _getDateString();
  }

  _getDateString(){
    List<String> dateString = widget.habit.isCompleted;
    for(int i = 0; i < dateString.length; i++){
      if("" == dateString[i]){
        continue;
      }
      else{
        List<String> dateParts = dateString[i].split('/');
        int month = int.parse(dateParts[0]);
        int day = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);
        DateTime date = DateTime(year, month, day);
        toHighlight.add(date);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateHabit(login: widget.login, habit: widget.habit, isPattern: false, )));
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Text(widget.habit.title,
                style: GoogleFonts.comfortaa(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.habit.tag, style: GoogleFonts.comfortaa(),),
              Text("Привычка была добавлена: ${firstDate.day.toString()}.${firstDate.month.toString()}.${firstDate.year.toString()}",
                    style: GoogleFonts.comfortaa(),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 130,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // Use BorderRadius.circular() for circular border radius
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Текущая\nсерия',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.comfortaa(
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.stacked_line_chart_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(height: 12,),
                              Text(
                                '${widget.habit.sumCompleted}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.comfortaa(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // Use BorderRadius.circular() for circular border radius
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Привычек\nзавершено',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.comfortaa(
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.check,
                                color: Colors.black,
                              ),
                              SizedBox(height: 12,),
                              Text(
                                '${widget.habit.sumCompleted}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.comfortaa(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // Use BorderRadius.circular() for circular border radius
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Прошедших\nдней',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.comfortaa(
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(height: 12,),
                              Text(
                                '${differ}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.comfortaa(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /*HomeTaskCountCard(
                          size: size,
                          count: widget.habit.sumCompleted,
                          desc: 'Текущая серия',
                          image: 'image1',
                          color: const Color(0xffff5722)),
                      HomeTaskCountCard(
                          size: size,
                          count: widget.habit.isCompleted.length - 1,
                          desc: 'Привычка завершена',
                          image: 'image2',
                          color: const Color(0xff03a9f4)),
                      HomeTaskCountCard(
                          size: size,
                          count: differ,
                          desc: 'Кол-во прошедших дней',
                          image: 'image3',
                          color: const Color(0xff03a9f4)
                      ), */
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      height: 240,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Use BorderRadius.circular() for circular border radius
                        color: Colors.deepPurple[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                            child: Image.asset(widget.habit.assets.first),
                          ),
                          Text("1 подарок",
                            style: GoogleFonts.comfortaa(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percentageCompleted,
                            backgroundColor: Colors.grey,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "${widget.habit.sumCompleted}/21",
                            style: GoogleFonts.comfortaa(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple.shade400,),
                            ),
                            child: Text("Забрать",
                                  style: GoogleFonts.comfortaa(
                                    fontWeight: FontWeight.bold
                                  ),
                            ),
                            onPressed:() {
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 240,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Use BorderRadius.circular() for circular border radius
                        color: Colors.deepOrangeAccent[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                            child: Image.asset(widget.habit.assets.last),
                          ),
                          Text(
                            "2 подарок",
                            style: GoogleFonts.comfortaa(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percentage2Completed,
                            backgroundColor: Colors.grey,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "${widget.habit.sumCompleted}/50",
                            style: GoogleFonts.comfortaa(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent.shade400,),
                            ),
                            child: Text("Забрать",
                              style: GoogleFonts.comfortaa(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed:() {
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              CalendarPage(toHighlight: toHighlight,),
            ],
          ),
      ),
    );
  }

}

class HomeTaskCountCard extends StatelessWidget {
  HomeTaskCountCard({
    Key? key,
    required this.size,
    required this.desc,
    required this.count,
    required this.image,
    this.color,
  }) : super(key: key);

  final Size size;
  final String desc;
  final int? count;
  final String image;
  final Color? color;

  Map<String, Color> imageColorMap = {
    'image1': Colors.red,
    'image2': Colors.blue,
    'image3': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color!.withOpacity(.4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 130,
        width: size.width / 3 - 32,
        child: Stack(
          children: [
            Positioned(
              top: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 100,
                  height: 100,
                  color: imageColorMap[image] ?? Colors.grey,
                ),
              ),
            ),
            Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 130,
                    width: size.width / 3 - 32,
                    color: Colors.black87.withOpacity(.3),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    desc,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  Text(
                    '$count',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}