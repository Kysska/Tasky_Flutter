
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    required this.toHighlight,
    Key? key,
  }) : super(key: key);
  final List<DateTime> toHighlight;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DateTime _focusedDay = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(46.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TableCalendar(
                lastDay: DateTime(2023, 12, 31),
                firstDay: DateTime(2023, 1, 1),
                focusedDay: _focusedDay,
                calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    )
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    for (DateTime d in widget.toHighlight) {
                      if (day.day == d.day &&
                          day.month == d.month &&
                          day.year == d.year) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}