import 'dart:math';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky_flutter/data/gamedatabase.dart';
import 'package:tasky_flutter/data/habitdatabase.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';
import 'package:tasky_flutter/presentation/habitinfo.dart';
import 'package:tasky_flutter/presentation/updatetask.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky_flutter/vidgets/emotional_selection.dart';

import 'addtask.dart';

class Home extends StatefulWidget{
  final String? login;
  const Home({super.key, this.login});


  @override
  _HomeState createState() => _HomeState();


}

class _HomeState extends State<Home> {

  final DatePickerController _controller = DatePickerController();
  var _selectedDate = DateTime.now();
  var isEmotionVisible = false;
  String emotionalKapibara = 'images/normal_emotions.png';

  @override
  initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.jumpToSelection();
    });
  }

  changeEmotionVisible(){
    setState(() {
      isEmotionVisible = !isEmotionVisible;
    });
  }


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
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/background_image.png'), // Замените на путь к вашей картинке
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Привет, ${widget.login}",
                    style: GoogleFonts.comfortaa(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: EmotionSelection(login: widget.login,),
          ),

          Padding(
            padding: const EdgeInsets.only(top:180.0),
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: DatePicker(
                  DateTime.now().subtract(Duration(days: 30)),
                  controller: _controller,
                  width: 65,
                  height: 75,
                  locale: "ru_RU",
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.black,
                  selectedTextColor: Colors.white,

                  dateTextStyle: GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  monthTextStyle: GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  dayTextStyle:  GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
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
                return  MyDraggableScrollableSheet(
                  login: widget.login,
                  selectedDate: _selectedDate,
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
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
  DatabaseHelperTask mTask = DatabaseHelperTask.instance;
  final List<bool> _isSelected = [true, false];
  var _selectedDate = DateTime.now();
  int _kapikountMoney = 0;

  _getMoney() async{
    _kapikountMoney = await GameDatabase().getMoney();
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    getListTask();
    _getMoney();
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

  plusMoney() async{
    Random random = Random();
    int randomNumber = random.nextInt(21) + 5;
    _kapikountMoney += randomNumber;
    await GameDatabase().setMoney(_kapikountMoney);
  }

  minusMoney() async{
    _kapikountMoney -= 10;
    await GameDatabase().setMoney(_kapikountMoney);
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
              ),
              color: Colors.white,
            ),
            child:
              Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 110,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(10, kMinInteractiveDimension),
                                primary: _isSelected[0] ? Colors.black : Colors.white,
                                onPrimary: _isSelected[0] ? Colors.white : Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSelected[0] = !_isSelected[0];
                                  _isSelected[1] = !_isSelected[1];
                                });
                              },
                              child: Text(
                                  "Задачи",
                                  style: GoogleFonts.comfortaa(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 40,
                            width: 110,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(70, kMinInteractiveDimension),
                                primary: _isSelected[1] ? Colors.black : Colors.white,
                                onPrimary: _isSelected[1] ? Colors.white : Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),

                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSelected[0] = !_isSelected[0];
                                  _isSelected[1] = !_isSelected[1];
                                });
                              },
                              child: Text(
                                "Привычки",
                                style: GoogleFonts.comfortaa(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if(_isSelected[0])
                  Expanded(
                    child: Scrollbar(
                      child: FutureBuilder<List<Task>>(
                        future: mTask.getTasks(),
                        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Text('Загрузка..'));
                          }
                          return snapshot.data!.isEmpty
                              ? Center(child: Text(
                                'Ещё нет задач, добавим?',
                                  style: GoogleFonts.comfortaa(
                                    color: Color(0xFF6A7791),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                          )
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
                                                  Navigator.of(context).pop(true);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Задача удалена')),
                                                  );
                                                  },
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
                                    elevation: 0,
                                    color: snapshot.data![index].isCompleted ? Color(0xFFD9DCE2) : Colors.white,
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data![index].title.length >= 25 ? "${snapshot.data![index].title.substring(0, 25)}..." : snapshot.data![index].title,
                                        style: GoogleFonts.comfortaa(
                                          color: snapshot.data![index].isCompleted ? Color(0xFF111010) : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text(
                                        snapshot.data![index].time,
                                        style: GoogleFonts.comfortaa(
                                          color:  snapshot.data![index].isCompleted ? Color(0xFF80919B) : Color(0xFF6A7791),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing:
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (snapshot.data![index].tag != "")
                                            Container(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Text(
                                                snapshot.data![index].tag,
                                                style: GoogleFonts.comfortaa(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          if (snapshot.data![index].isCompleted)
                                            IconButton(
                                              icon: const Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.pink,
                                              ),
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text("Отменить выполненную задачу"),
                                                      content: const Text("Вы правда хотите отменить выполнение задачи?"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () async {
                                                            minusMoney();
                                                            await mTask.updateCompleted(snapshot.data![index].title, 0);
                                                            _refreshPage();
                                                            Navigator.of(context).pop(true);
                                                          },
                                                          child: const Text("Да"),
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
                                          else
                                            IconButton(
                                              icon: const Icon(
                                                Icons.circle_outlined,
                                                color: Colors.pink,
                                              ),
                                              onPressed: () async{
                                                  plusMoney();
                                                  await mTask.updateCompleted(snapshot.data![index].title, 1);
                                                  _refreshPage();
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
                    HabitsCards(login: widget.login, selectedWeekday: _selectedDate.weekday, selectedDay: _selectedDate, kapikountMoney: _kapikountMoney,),
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
  final kapikountMoney;
  const HabitsCards({super.key, this.login, this.selectedWeekday, this.selectedDay, this.kapikountMoney});

  @override
  _HabitsCardsState createState() =>
      _HabitsCardsState();
}

class _HabitsCardsState extends State<HabitsCards> {

  ScrollController scrollController = ScrollController();
  HabitFirebase mHabitFire = HabitFirebase();
  List<Habit>? mListHabit;
  DatabaseHelperHabit mHabit = DatabaseHelperHabit.instance;
  var _selectedWeekday;
  var _selectedDay;
  late int _kapikountMoney;

  @override
  void initState() {
    super.initState();
    _selectedWeekday = widget.selectedWeekday;
    _selectedDay = widget.selectedDay;
    _kapikountMoney = widget.kapikountMoney;
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

  plusMoney() async{
    Random random = Random();
    int randomNumber = random.nextInt(21) + 5;
    _kapikountMoney += randomNumber;
    await GameDatabase().setMoney(_kapikountMoney);
  }

  minusMoney() async{
    _kapikountMoney -= 10;
    await GameDatabase().setMoney(_kapikountMoney);
  }


  @override
  Widget build(BuildContext context) {
        return Expanded(
          child: Scrollbar(
            child: FutureBuilder<List<Habit>>(
              future: mHabit.getHabit(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Habit>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Загрузка..'));
                }
                return snapshot.data!.isEmpty
                    ? Center(child: Text('Привычек нет'),)
                    : ListView.builder(
                  controller: scrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool selectedFormatWeek = snapshot.data![index]
                        .listWeek[_selectedWeekday - 1];
                    List<String> selectedFormatDate = snapshot.data![index]
                        .isCompleted;
                    String selectedFormatDay = DateFormat.yMd().format(
                        _selectedDay);
                    bool dayInList = selectedFormatDate.contains(
                        selectedFormatDay);
                    updateCompletedDate(
                        selectedFormatDate, snapshot.data![index].title);

                    if (selectedFormatWeek) {
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
                                  Text('Удалить',
                                      style: TextStyle(color: Colors.white)),
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
                                  content: const Text(
                                      "Вы правда хотите удалить привычку?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () async {
                                          await mHabit.remove(
                                              snapshot.data![index].id);
                                          Navigator.of(context).pop(true);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Привычка удалена')),
                                          );
                                        },
                                        child: const Text("Удалить")
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
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
                              title: Text(snapshot.data![index].title.length >= 25 ? '${snapshot.data![index].title.substring(0, 25)}...' : snapshot.data![index].title),
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
                                            title: const Text(
                                                "Отменить выполнененную привычку"),
                                            content: const Text(
                                                "Вы правда хотите отменить выполнение привычки сегодня?"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () async {
                                                    minusMoney();
                                                    selectedFormatDate.remove(
                                                        selectedFormatDay);
                                                    await mHabit
                                                        .updateCompleted(
                                                        snapshot.data![index]
                                                            .title,
                                                        selectedFormatDate,
                                                        snapshot.data![index]
                                                            .sumCompleted - 1);
                                                    _refreshPage();
                                                    Navigator.of(context).pop(
                                                        true);
                                                  },
                                                  child: const Text("Да")
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(
                                                        false),
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
                                    onPressed: () async {
                                      plusMoney();
                                      selectedFormatDate.add(selectedFormatDay);
                                      await mHabit.updateCompleted(
                                          snapshot.data![index].title,
                                          selectedFormatDate,
                                          snapshot.data![index].sumCompleted +
                                              1);
                                      _refreshPage();
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => HabitInfo(
                                      login: widget.login,
                                      sumCompleted: selectedFormatDate.length -
                                          1,
                                      habit: snapshot.data![index],)))
                                    .then((value) =>
                                {
                                  if(value != null && value == true){
                                    _refreshPage()
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }
                    else {
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
    if (selectedFormatDate.isNotEmpty) {
      String lastDateStr = selectedFormatDate.last;
      if (lastDateStr.isNotEmpty) {
        DateTime lastDate = await DateFormat("M/d/yyyy").parse(lastDateStr);
        DateTime dayBeforeYesterday = await DateTime.now().subtract(Duration(days: 2));

        if (lastDate.isBefore(dayBeforeYesterday)){
          print(dayBeforeYesterday);
          print(lastDateStr);
          await mHabit.updateCompleted(title, selectedFormatDate, 0);
        }
      }
    }
  }

}