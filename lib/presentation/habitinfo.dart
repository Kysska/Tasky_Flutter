import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitInfo extends StatefulWidget {
  final String? login;
  const HabitInfo({super.key, this.login});

  @override
  _HabitInfoState createState() =>
      _HabitInfoState();
}

class _HabitInfoState extends State<HabitInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  const LinearProgressIndicator(
                    value: 1,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
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
                  const LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
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