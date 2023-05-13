
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';

import '../vidgets/input_field.dart';

class AddTask extends StatefulWidget{
  final String? login;
  const AddTask({super.key, required this.login});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with TickerProviderStateMixin{

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late TabController _tabController;
  TaskFirebase mTaskFire = TaskFirebase();
  DatabaseHelperTask mTask = DatabaseHelperTask.instance;
  var _selectedDate;
  var _selectedNotice;
  var _selectedTime;
  late String _selectedTag;

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
              SizedBox(height: 10,),
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
                              tabs: [
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
                                MyInputField(title: "Дата", hint: _selectedDate,
                                  widget: IconButton(
                                    icon: Icon(Icons.calendar_month),
                                    onPressed: (){
                                      _getDateFromUser();
                                    },
                                  ),
                                ),
                                SizedBox(height: 18,),
                                MyInputField(title: "Время", hint: _selectedTime,
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
                              child: _getHabbit()
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
              _selectedTag = item.title;
            })
          },
        );

      },
    );
  }
  _getDateFromUser() async{
    DateTime? _checkDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2050));
    String _pickerDate = DateFormat.yMd().format(_checkDate!);
    if(_pickerDate != null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
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
      _dbTaskAdd();
    }
    else if(_titleController.text.isEmpty || _selectedTime == null || _selectedDate == null){
      final snackBar = SnackBar(
          content: const Text('Введите название')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _validateDataHabit() {
    if(_titleController.text.isNotEmpty){
    }
    else if(_titleController.text.isEmpty){
      final snackBar = SnackBar(
          content: const Text('Введите название')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _getHabbit() {
    return Column(
      children: [
        MyInputField(title: "Название", hint: "Введите название задачи", controller: _titleController,),
        SizedBox(height: 18,),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _validateDataHabit();
                    Navigator.pop(context);},
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
        )
        //значок, цвет, дата
      ],
    );
  }
}

