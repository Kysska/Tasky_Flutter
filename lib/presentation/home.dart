import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky_flutter/data/habitdatabase.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';
import 'package:tasky_flutter/presentation/habitinfo.dart';
import 'package:tasky_flutter/presentation/updatetask.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addtask.dart';
import 'note.dart';

class Home extends StatefulWidget{
  final String? login;
  const Home({super.key, this.login});


  @override
  _HomeState createState() => _HomeState();


}

class _HomeState extends State<Home> {

  final DatePickerController _controller = DatePickerController();
  var _selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask(login: widget.login,))).then((
              value) =>
          {
            if(value!=null && value == true){
              refreshPage()
            }
          });
        },
        backgroundColor: const Color(0xFF93D7FF),
        elevation: 0,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13),
            child: Text(
              "Привет, ${widget.login}",
              style: GoogleFonts.comfortaa(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                        // ToDo переход на создание новой записи блокнота
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
                  child: ElevatedButton(
                    onPressed: () {
                      // Обработчик нажатия для второй кнопки
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0x88FFFFFF),
                      elevation: 0,
                    ),
                    child: Text('Button 2'),
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Обработчик нажатия для третьей кнопки
                    },
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
          ),

          Padding(
            padding: const EdgeInsets.only(top:210.0),
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: DatePicker(
                DateTime.now().subtract(Duration(days: 2)),
                controller: _controller,
                locale: "ru_RU",
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.blue,
                selectedTextColor: Colors.white,
                dateTextStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey
                ),
                monthTextStyle: const TextStyle(
                    fontSize: 10,
                ),
                dayTextStyle:  const TextStyle(
                  fontSize: 10,
                ),
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                  // _showTasks();
                },
              ),
            ),
          ),
          FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 100)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return MyDraggableScrollableSheet(
                  login: widget.login,
                  selectedDate: _selectedDate,
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      )
      );
    
  }
  refreshPage(){
    setState(() {
      _selectedDate = DateTime.now();
    });
  }
}

class MyDraggableScrollableSheet extends StatefulWidget {
  final String? login;
  final selectedDate;

  const MyDraggableScrollableSheet({super.key, this.login, this.selectedDate});

  @override
  _MyDraggableScrollableSheetState createState() =>
      _MyDraggableScrollableSheetState();
}

class _MyDraggableScrollableSheetState extends State<MyDraggableScrollableSheet> {

  TaskFirebase mTaskFire = TaskFirebase();
  List<Task>? mListTask;
  Future<List<Task>>? retrievedListTask;
  DatabaseHelperTask mTask = DatabaseHelperTask.instance;
  final List<bool> _isSelected = [true, false];
  var _selectedDate = DateTime.now();


  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    retrievedListTask = mTask.getTasks();
    getListTask();
  }

  @override
  void didUpdateWidget(covariant MyDraggableScrollableSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _selectedDate = widget.selectedDate;
    }
  }

  Future<List<Task>?> getListTask() async{
    mListTask = await mTask.getTasks();
    return mListTask;
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.0,
                  spreadRadius: 10.0,
                  offset: const Offset(0.0, 5.0),
                  color: Colors.black.withOpacity(0.1),
                )
              ],
              color: Colors.white,
            ),
            child:
              Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ToggleButtons(
                      constraints: BoxConstraints(minWidth: 70, maxWidth: 70, minHeight: kMinInteractiveDimension),
                      isSelected: _isSelected,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      fillColor: Colors.blueAccent,
                      color: Colors.black87,
                      selectedColor: Colors.white,
                      onPressed: (int index) {
                        setState(() {
                          _isSelected[0] = !_isSelected[0];
                          _isSelected[1] = !_isSelected[1];
                        });
                      },
                      children: const <Widget>[
                        Text("Задачи"),
                        Text("Привычки"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if(_isSelected[0])
                  Expanded(
                    child: Scrollbar(
                      child: FutureBuilder<List<Task>>(
                        future: retrievedListTask,
                        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Text('Загрузка..'));
                          }
                          return snapshot.data!.isEmpty
                              ? Center(child: Text('Задач нет'),)
                              : ListView.builder(
                            controller: scrollController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              String selectedFormatDate = DateFormat.yMd().format(
                                  _selectedDate);
                              String dateSqlite = snapshot.data![index].date;
                              if(selectedFormatDate == dateSqlite) {
                                return Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Dismissible(
                                  key: Key(snapshot.data![index].id),
                                  background: Container(
                                    color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: const <Widget>[
                                          Icon(Icons.delete, color: Colors.white),
                                          Text('Удалить', style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  confirmDismiss: (DismissDirection direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Удалить задачу"),
                                          content: const Text("Вы правда хотите удалить задачу?"),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () async{
                                                  await mTask.remove(snapshot.data![index].id);
                                                  Navigator.of(context).pop(true);},
                                                child: const Text("Удалить")
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text("Закрыть"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Card(
                                    color: snapshot.data![index].isCompleted
                                        ? Colors.grey[300]
                                        : Colors.white,
                                    child: ListTile(
                                      title: Text(snapshot.data![index].title),
                                      subtitle: Text(snapshot.data![index].time),
                                      trailing:
                                      Row(
                                          mainAxisSize: MainAxisSize.min,
                                        children: [
                                          snapshot.data![index].tag == ""
                                              ? SizedBox.shrink()
                                              : Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(14.0),
                                              border: Border.all(
                                                width: 1.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              snapshot.data![index].tag,
                                              style: const TextStyle(fontSize: 14.0),
                                            ),
                                          ),
                                          snapshot.data![index].isCompleted
                                              ? IconButton(
                                                icon: const Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.pink,
                                            ),
                                            onPressed: () async {
                                              return await showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Отменить выполнененную задачу"),
                                                    content: const Text("Вы правда хотите отменить выполнение задачи?"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                          onPressed: () async{
                                                            await mTask.updateCompleted(snapshot.data![index].title, 0);
                                                            Navigator.of(context).pop(true);},
                                                          child: const Text("Да")
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator.of(context).pop(false),
                                                        child: const Text("Нет"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                              )
                                              : IconButton(
                                            icon: const Icon(
                                              Icons.circle_outlined,
                                              color: Colors.pink,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                mTask.updateCompleted(snapshot.data![index].title, 1);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTask(login: widget.login, task: snapshot.data![index],))).then((
                                            value) =>
                                        {
                                          if(value!=null && value == true){
                                            _refreshPage()
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                              }
                              else{
                                return SizedBox.shrink();
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  if(_isSelected[1])
                    HabitsCards(login: widget.login, selectedWeekday: _selectedDate.weekday, selectedDay: _selectedDate,),
                ],
              ),
          );
      },
    );

  }
  _refreshPage(){
    setState(() {});
  }
}

class HabitsCards extends StatefulWidget {
  final String? login;
  final selectedWeekday;
  final selectedDay;
  const HabitsCards({super.key, this.login, this.selectedWeekday, this.selectedDay});

  @override
  _HabitsCardsState createState() =>
      _HabitsCardsState();
}

class _HabitsCardsState extends State<HabitsCards> {

  ScrollController scrollController = ScrollController();
  HabitFirebase mHabitFire = HabitFirebase();
  List<Habit>? mListHabit;
  Future<List<Habit>>? retrievedListHabit;
  DatabaseHelperHabit mHabit = DatabaseHelperHabit.instance;
  var _selectedWeekday;
  var _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedWeekday = widget.selectedWeekday;
    _selectedDay = widget.selectedDay;
    retrievedListHabit = mHabit.getHabit();
    getListHabit();
  }

  Future<List<Habit>?> getListHabit() async{
    mListHabit = await mHabit.getHabit();
    return mListHabit;
  }

  @override
  void didUpdateWidget(covariant HabitsCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedWeekday != oldWidget.selectedWeekday) {
      _selectedWeekday = widget.selectedWeekday;
    }
    if (widget.selectedDay != oldWidget.selectedDay) {
      _selectedDay = widget.selectedDay;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: FutureBuilder<List<Habit>>(
          future: retrievedListHabit,
          builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Загрузка..'));
            }
            return snapshot.data!.isEmpty
                ? Center(child: Text('Привычек нет'),)
                : ListView.builder(
              controller: scrollController,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                bool selectedFormatWeek = snapshot.data![index].listWeek[_selectedWeekday - 1];
                List<String> selectedFormatDate = snapshot.data![index].isCompleted;
                String selectedFormatDay = DateFormat.yMd().format(_selectedDay);
                bool dayInList = selectedFormatDate.contains(selectedFormatDay);

                updateCompletedDate(selectedFormatDate, snapshot.data![index].title);

                if(selectedFormatWeek) {
                  return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Dismissible(
                    key: Key(snapshot.data![index].id),
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const <Widget>[
                            Icon(Icons.delete, color: Colors.white),
                            Text('Удалить', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Удалить привычку"),
                            content: const Text("Вы правда хотите удалить привычку?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () async{
                                    await mHabit.remove(snapshot.data![index].id);
                                    Navigator.of(context).pop(true);},
                                  child: const Text("Удалить")
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Закрыть"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      // snapshot.data![index].isCompleted
                      //     ? Colors.grey[300]
                      //     : Colors.white,
                      child: ListTile(
                          title: Text(snapshot.data![index].title),
                          subtitle: Text(snapshot.data![index].time),
                          trailing:
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              snapshot.data![index].tag == ""
                                  ? SizedBox.shrink()
                                  : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0),
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  snapshot.data![index].tag,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ),
                              dayInList
                                  ? IconButton(
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.pink,
                                ),
                                onPressed: () async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Отменить выполнененную привычку"),
                                        content: const Text("Вы правда хотите отменить выполнение привычки сегодня?"),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () async{
                                                selectedFormatDate.remove(selectedFormatDay);
                                                await mHabit.updateCompleted(snapshot.data![index].title, selectedFormatDate, snapshot.data![index].sumCompleted - 1);
                                                _refreshPage();
                                                Navigator.of(context).pop(true);},
                                              child: const Text("Да")
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text("Нет"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              )
                                  : IconButton(
                                icon: const Icon(
                                  Icons.circle_outlined,
                                  color: Colors.pink,
                                ),
                                onPressed: () async{
                                      selectedFormatDate.add(selectedFormatDay);
                                      await mHabit.updateCompleted(snapshot.data![index].title, selectedFormatDate, snapshot.data![index].sumCompleted + 1);
                                      _refreshPage();
                                },
                              ),
                            ],
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HabitInfo(login: widget.login, sumCompleted: selectedFormatDate.length - 1, habit: snapshot.data![index],))).then((
                                value) =>
                            {
                              if(value!=null && value == true){
                                _refreshPage()
                              }
                            });
                            },
                      ),
                    ),
                  ),
                );
                }
                else{
                  return const SizedBox.shrink();
                }
              },
            );
          },
        ),
      ),
    );
  }

  _refreshPage(){
    setState(() {});
  }

  updateCompletedDate(List<String> selectedFormatDate, String title) async {
    DateTime lastDate =  await DateFormat("dd/MM/yyyy").parse(selectedFormatDate.last);
    DateTime dayBeforeYesterday = await DateTime.now().subtract(Duration(days: 1));

    if (lastDate.isBefore(dayBeforeYesterday)) {
      await mHabit.updateCompleted(title, selectedFormatDate, 0);
    }
  }

}