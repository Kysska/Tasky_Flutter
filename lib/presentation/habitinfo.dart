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

  @override
  void initState() {
    super.initState();
    sumCompleted = widget.sumCompleted;
    percentageCompleted = sumCompleted / 21;
    percentage2Completed = sumCompleted / 50;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateHabit(login: widget.login, habit: widget.habit, )));
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.only(left: 25.0),
        child: Row(
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
                    child: Image.asset("images/Donut.png"),
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
                    child: Image.asset("images/Ice-cream.png"),
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
      ),
    );
  }

}