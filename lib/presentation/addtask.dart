
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasky_flutter/data/habitdatabase.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';
import 'package:tasky_flutter/presentation/updatehabit.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../vidgets/input_field.dart';

class AddTask extends StatefulWidget{
  final String? login;
  const AddTask({super.key, required this.login});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with TickerProviderStateMixin{

  final _titleController = TextEditingController();
  late TabController _tabController;
  TaskFirebase mTaskFire = TaskFirebase();
  DatabaseHelperTask mTask = DatabaseHelperTask.instance;
  var _selectedDate = DateFormat.yMd().format(DateTime.now());
  var _selectedTime;
  late String _selectedTag = "";
  var id = DateTime.now().toString();


  List<String> TagsList = [
    "Работа",
    "Учёба",
    "Отдых",
    "Семья",
    "Спорт",
    "Питание",
    "Встреча",
    "Прогулка"
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this,);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedTime = TimeOfDay.now().format(context).toString();
  }

  _dbTaskAdd() async{
    await mTask.add(Task(title: _titleController.text, id: id, date: _selectedDate, isCompleted: false,  time: _selectedTime, tag: _selectedTag, daysOfWeek: [],));
    mTaskFire.setDataTaskList(widget.login!, Task(title: _titleController.text, id: id, date: _selectedDate, isCompleted: false, time:  _selectedTime, tag: _selectedTag, daysOfWeek: [],));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Column(
            children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Выберите готовую привычку\nи выйграйте призы",
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10,),
                InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateHabit(login: widget.login, habit: Habit(title: 'Отказ от сахара', id: id, isCompleted: [], tag: '', time: '15:00', listWeek: [true,true,true,true,true,true,true], sumCompleted: 0, assets: ["images/Cook.png", "images/medic_2.png"], receivedGifts: 0), isPattern: true,)));
                    },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          const Icon(Icons.cake),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Отказ от\nсахара',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.comfortaa(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateHabit(login: widget.login, habit: Habit(title: 'Время на свежем воздухе', id: id, isCompleted: [], tag: '', time: '15:00', listWeek: [true,true,true,true,true,true,true], sumCompleted: 0, assets:  ["images/Baterfly.png", "images/medic_2.png"], receivedGifts: 0  ), isPattern: true,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          const Icon(Icons.brightness_7_rounded),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Время на\nсвежем воздухе',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.comfortaa(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateHabit(login: widget.login, habit: Habit(title: 'Чтение книг', id: id, isCompleted: [], tag: '', time: '15:00', listWeek: [true,true,true,true,true,true,true], sumCompleted: 0, assets: ["images/Hat.png", "images/medic_2.png"], receivedGifts: 0 ), isPattern: true,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          const Icon(Icons.menu_book_sharp),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Чтение\nкниг',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.comfortaa(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text("Или создайте свою:",
          style: GoogleFonts.comfortaa(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            ),
          ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    SizedBox(
                      width:  MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TabBar(
                              controller: _tabController,
                              unselectedLabelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle : GoogleFonts.comfortaa(fontWeight: FontWeight.bold, fontSize: 16,),
                              dividerColor: Colors.black,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black),
                              tabs: const [
                                Tab(

                                  text: "Задачи",
                                ),
                                Tab(
                                  text: "Привычки",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                MyInputField(
                                  title: "Название",
                                  hint: "Введите название задачи",
                                  controller: _titleController,
                                ),
                                const SizedBox(height: 18,),
                                MyInputField(title: "Дата", hint: _selectedDate,
                                  widget: IconButton(
                                    icon: const Icon(Icons.calendar_month),
                                    onPressed: (){
                                      _getDateFromUser();
                                    },
                                  ),
                                ),
                                const SizedBox(height: 18,),
                                MyInputField(title: "Время", hint: _selectedTime,
                                  widget: IconButton(
                                    icon: const Icon(Icons.access_time),
                                    onPressed: (){
                                      _getTimeFromUser();
                                    },
                                  ),
                                ),
                                const SizedBox(height: 18,),
                                _getTagsFromUser(),
                                const SizedBox(height: 18,),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              _validateData();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.all(0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10))),
                                            child: Ink(
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: Container(
                                                    width: 120,
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Добавить',
                                                      style: GoogleFonts.comfortaa(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ))))
                                      ]
                                  ),
                                )
                                //значок, цвет, дата
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                              child: AddHabit(login: widget.login,),
                          )
                        ]
                    )
                ),
              )
            ]
        )
    );
  }

  _getTagsFromUser(){
    return Tags(
      // textField: TagsTextField(
      //   textStyle: const TextStyle(fontSize: 14),
      //   suggestions: [],
      //   onSubmitted:  (String str) {
      //     print(str);
      //     setState(() {
      //       TagsList.add(str);
      //     });
      //   },
      // ), //TODO исправить
      horizontalScroll: true,
      itemCount: TagsList.length,
      itemBuilder: (int index){
        final itemTag = TagsList[index];
        return ItemTags(
          index: index, // required
          title: itemTag,
          singleItem: true,
          textStyle: const TextStyle( fontSize: 14, ),
          combine: ItemTagsCombine.withTextBefore,
          icon: ItemTagsIcon(
            icon: Icons.add,
          ),
          onPressed: (item) => {
            setState((){
              _selectedTag = itemTag;
            })
          },
        );

      },
    );
  }
  _getDateFromUser() async{
    DateTime? checkDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2050));
    String pickerDate = DateFormat.yMd().format(checkDate!);
    setState(() {
      _selectedDate = pickerDate;
    });
  }

  _getTimeFromUser() async{
    TimeOfDay? checkTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true),
              child: childWidget!);
        });
    if(checkTime != null){
      setState(() {
        _selectedTime = checkTime.format(context);
      });
    }
  }

  _validateData()  async{
    if(_titleController.text.isNotEmpty){
      _selectedTag ??= "";
      try {
        await NotifyTask('habit');
      } on Exception catch (e) {
        // TODO
      }
      _dbTaskAdd();
      Navigator.of(context).pop(true);
    }
    else if(_titleController.text.isEmpty){
      const snackBar = SnackBar(
          content: Text('Введите название')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future NotifyTask(String chanel) async{
    String timesone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    final timeParts = _selectedTime.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    DateTime dateTime = DateFormat("M/d/yyyy").parse(_selectedDate);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(100),
        channelKey: chanel,
        title: 'У вас есть запланированное дело',
        body: _titleController.text,
      ),
      schedule: NotificationCalendar(timeZone: timesone, hour: hours, minute: minutes, day: dateTime.day, month: dateTime.month, year: dateTime.year),
    );
  }
}

class AddHabit extends StatefulWidget{
  final String? login;
  const AddHabit({super.key, required this.login});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit>{
  List<bool> isSelectedWeekday = List.generate(7, (index) => true);
  final _titleController = TextEditingController();
  HabitFirebase mHabitFire = HabitFirebase();
  DatabaseHelperHabit mHabit = DatabaseHelperHabit.instance;
  var _selectedTime;
  late String _selectedTag = "";


  List<String> TagsList = [
    "Работа",
    "Учёба",
    "Отдых",
    "Семья",
    "Спорт",
    "Питание",
    "Встреча",
    "Прогулка"
  ];

  _dbHabitAdd() async{
    var id = DateTime.now().toString();
    await mHabit.add(Habit(title: _titleController.text, id: id, isCompleted: [],  time: _selectedTime, tag: _selectedTag, listWeek: isSelectedWeekday, sumCompleted: 0, assets: ['images/medic_1.png', 'images/medic_2.png'], receivedGifts: 0,));
    mHabitFire.setDataHabitList(widget.login!, Habit(title: _titleController.text, id: id, isCompleted: [],  time:  _selectedTime, tag: _selectedTag, listWeek: [], sumCompleted: 0, assets: ['images/medic_1.png', 'images/medic_2.png'], receivedGifts: 0));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedTime = TimeOfDay.now().format(context).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyInputField(title: "Название", hint: "Введите название привычки", controller: _titleController,),
        const SizedBox(height: 18,),
        WeekdaySelector(
          onChanged: (v) {
            setState(() {
              isSelectedWeekday[v % 7] = !isSelectedWeekday[v  % 7];
            });
          },
          selectedFillColor: Colors.black,
          values: isSelectedWeekday,
          selectedElevation: 0,
        ),
        const SizedBox(height: 18,),
        MyInputField(title: "Время для уведомлений", hint:  _selectedTime,
          widget: IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: (){
              _getTimeFromUser();
            },
          ),
        ),
        const SizedBox(height: 18,),
        _getTagsFromUser(),
        const SizedBox(height: 18,),
        Align(
          alignment: Alignment.center,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _validateData();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),

                        child: Container(
                            width: 120,
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text(
                              'Добавить',
                            ))))
              ]
          ),
        )
      ],
    );
  }

  _getTimeFromUser() async{
    TimeOfDay? _checkTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true),
              child: childWidget!);
        });
    if(_checkTime != null){
      setState(() {
        _selectedTime = _checkTime.format(context);
      });
    }
  }


  _getTagsFromUser(){
    return Tags(
      // textField: TagsTextField(
      //   textStyle: const TextStyle(fontSize: 14),
      //   suggestions: [],
      //   onSubmitted:  (String str) {
      //     print(str);
      //     setState(() {
      //       TagsList.add(str);
      //     });
      //   },
      // ), //TODO исправить
      horizontalScroll: true,
      itemCount: TagsList.length,
      itemBuilder: (int index){
        final item = TagsList[index];
        return ItemTags(
          index: index, // required
          title: item,
          // active: item.active,
          // customData: item.customData,
          singleItem: true,
          textStyle: const TextStyle( fontSize: 14, ),
          combine: ItemTagsCombine.withTextBefore,
          icon: ItemTagsIcon(
            icon: Icons.add,
          ),
          onPressed: (item) => {
            setState((){
              _selectedTag = item.title!;
            })
          },
        );

      },
    );
  }

  _validateData() async{
    bool areAllFalse = isSelectedWeekday.every((value) => value == false);
    if(areAllFalse){
      const snackBar = SnackBar(
          content: Text('Убедитесь, что хотябы один день недели проставлен')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else{
      if(_titleController.text.isNotEmpty){
        _selectedTime ??= "15:00";
        try {
          for (int i = 0; i < isSelectedWeekday.length; i++) {
            if (isSelectedWeekday[i]) {
              await Notify('habit', i + 1);
            }
          }
        }
        catch(e){
        }
        _dbHabitAdd();
        Navigator.of(context).pop(true);
      }
      else{
        const snackBar = SnackBar(
            content: Text('Введите название')
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future Notify(String chanel, int week) async{
    String timesone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    final timeParts = _selectedTime.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(100),
        channelKey: chanel,
        title: _titleController.text,
        body: 'Пришло время действовать!',
      ),
      schedule: NotificationCalendar(weekday: week, timeZone: timesone, hour: hours, minute: minutes,),
    );
  }

}

