
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:tasky_flutter/data/habitdatabase.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';
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
  var _selectedDate;
  var _selectedNotice;
  var _selectedTime;
  late String _selectedTag = "";

  List<String> NoticeList = <String>[
    "15 минут",
    "30 минут",
    "1 час",
    "2 часа",
    "4 часа",
    "8 часов",
    "12 часов",
    "1 день",
  ];

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

  _dbTaskAdd() async{
    var id = DateTime.now().toString();
    await mTask.add(Task(title: _titleController.text, id: id, date: _selectedDate, isCompleted: false, notice: _selectedNotice, time: _selectedTime, tag: _selectedTag, daysOfWeek: [],));
    await mTaskFire.setDataTaskList(widget.login!, Task(title: _titleController.text, id: id, date: _selectedDate, isCompleted: false, notice: _selectedNotice, time:  _selectedTime, tag: _selectedTag, daysOfWeek: [],));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        ),
        body: Column(
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Container(
                      width:  MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TabBar(
                              controller: _tabController,
                              unselectedLabelColor: Colors.blue,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue),
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
                    // height: 500,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                MyInputField(title: "Название", hint: "Введите название задачи", controller: _titleController,),
                                SizedBox(height: 18,),
                                MyInputField(title: "Дата", hint: '',
                                  widget: IconButton(
                                    icon: Icon(Icons.calendar_month),
                                    onPressed: (){
                                      _getDateFromUser();
                                    },
                                  ),
                                ),
                                SizedBox(height: 18,),
                                MyInputField(title: "Время", hint: '',
                                  widget: IconButton(
                                    icon: Icon(Icons.access_time),
                                    onPressed: (){
                                      _getTimeFromUser();
                                    },
                                  ),
                                ),
                                SizedBox(height: 18,),
                                _getNoticeFromUser(),
                                SizedBox(height: 18,),
                                _getTagsFromUser(),
                                SizedBox(height: 18,),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              _validateData();
                                              Navigator.of(context).pop(true);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.all(0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10))),
                                            child: Ink(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10)),
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
        print(itemTag);
        return ItemTags(
          index: index, // required
          title: itemTag,
          // active: item.active,
          // customData: item.customData,
          singleItem: true,
          textStyle: TextStyle( fontSize: 14, ),
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
    DateTime? _checkDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2050));
    String _pickerDate = DateFormat.yMd().format(_checkDate!);
    setState(() {
      _selectedDate = _pickerDate;
    });
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

  _getNoticeFromUser() {
    return DropdownButton<String>(
      hint: const Text(
        'Уведомлять до',
      ),
      isExpanded: true,
      value: _selectedNotice,
      items: NoticeList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _selectedNotice = _!;
        });
      },
    );

  }

  _validateData() {
    if(_titleController.text.isNotEmpty || _selectedTime != null || _selectedDate != null){
      _selectedNotice ??= "0";
      _selectedTag ??= "";
      _dbTaskAdd();
    }
    else if(_titleController.text.isEmpty || _selectedTime == null || _selectedDate == null){
      final snackBar = SnackBar(
          content: const Text('Введите название')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
  var _selectedNotice;
  var _selectedTime;
  late String _selectedTag = "";

  List<String> NoticeList = <String>[
    "15 минут",
    "30 минут",
    "1 час",
    "2 часа",
    "4 часа",
    "8 часов",
    "12 часов",
    "1 день",
  ];

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
    await mHabit.add(Habit(title: _titleController.text, id: id, isCompleted: [], notice: _selectedNotice, time: _selectedTime, tag: _selectedTag, listWeek: isSelectedWeekday, sumCompleted: 0,));
    await mHabitFire.setDataHabitList(widget.login!, Habit(title: _titleController.text, id: id, isCompleted: [], notice: _selectedNotice, time:  _selectedTime, tag: _selectedTag, listWeek: [], sumCompleted: 0,));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyInputField(title: "Название", hint: "Введите название задачи", controller: _titleController,),
        const SizedBox(height: 18,),
        WeekdaySelector(
          onChanged: (v) {
            setState(() {
              print(v % 7);
              isSelectedWeekday[v % 7] = !isSelectedWeekday[v % 7];
            });
          },
          values: isSelectedWeekday,
        ),
        const SizedBox(height: 18,),
        MyInputField(title: "Время для уведомлений", hint: '',
          widget: IconButton(
            icon: Icon(Icons.access_time),
            onPressed: (){
              _getTimeFromUser();
            },
          ),
        ),
        SizedBox(height: 18,),
        _getNoticeFromUser(),
        SizedBox(height: 18,),
        _getTagsFromUser(),
        SizedBox(height: 18,),
        Align(
          alignment: Alignment.center,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _validateData();
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
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
        //значок, цвет, дата
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

  _getNoticeFromUser() {
    return DropdownButton<String>(
      hint: const Text(
        'Уведомлять до',
      ),
      isExpanded: true,
      value: _selectedNotice,
      items: NoticeList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _selectedNotice = _!;
        });
      },
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
        final item = TagsList[index];

        return ItemTags(
          index: index, // required
          title: item,
          // active: item.active,
          // customData: item.customData,
          singleItem: true,
          textStyle: TextStyle( fontSize: 14, ),
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

  _validateData() {
    if(_titleController.text.isNotEmpty){
      _selectedTime ??= "15:00";
      _selectedNotice ??= "0";
      _dbHabitAdd();
    }
    else if(_titleController.text.isEmpty){
      final snackBar = SnackBar(
          content: const Text('Введите название')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}

