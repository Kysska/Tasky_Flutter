import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/presentation/updatehabit.dart';

import '../data/habitdatabase.dart';

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

  @override
  void initState() {
    super.initState();
    sumCompleted = widget.sumCompleted;
    percentageCompleted = sumCompleted / 21;
    percentage2Completed = sumCompleted / 50;
    firstDate = DateTime.parse(widget.habit.id);
    differ = firstDate.difference(now).inDays;
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
      body: Padding(padding: const EdgeInsets.only(left: 25.0),
        child: Column(
          children: [
            Text(widget.habit.title),
            Text(widget.habit.tag),
            Row(
              children: [
                Text("Привычка была добавлена: ${firstDate.day.toString()}-${firstDate.month.toString()}-${firstDate.year.toString()}"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomeTaskCountCard(
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
                        color: const Color(0xff03a9f4)),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 240,
                  padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                        child: Image.asset(widget.habit.assets.first),
                      ),
                      const Text("1 подарок",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: percentageCompleted,
                        backgroundColor: Colors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                      Text(
                          "${sumCompleted}/21"
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple.shade400,),
                        ),
                        child: Text("Забрать"),
                        onPressed:() {

                        },
                      )
                    ],
                  ),
      ),
                SizedBox(width: 10), // Расстояние между контейнерами
                Container(
                  width: 150,
                  height: 240,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                        child: Image.asset(widget.habit.assets.last),
                      ),
                      const Text(
                        "2 подарок",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: percentage2Completed,
                        backgroundColor: Colors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                      Text(
                          "${sumCompleted}/50"
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent.shade400,),
                        ),
                        child: Text("Забрать"),
                        onPressed:() {

                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
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