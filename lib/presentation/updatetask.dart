import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';

import '../data/taskdatabase.dart';
import '../vidgets/input_field.dart';

class UpdateTask extends StatefulWidget{
  final String? login;
  final Task task;
  const UpdateTask({super.key, required this.login, required this.task});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask>{
  TaskFirebase mTaskFire = TaskFirebase();
  DatabaseHelperTask mTask = DatabaseHelperTask.instance;
  late var _selectedTitle;
  late var _selectedDate;
  late var _selectedNotice;
  late var _selectedTime;
  late String _selectedTag;
  late final TextEditingController _titleController;

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
    setState(() {
      _selectedTitle = widget.task.title;
      _selectedDate = widget.task.date;
      _selectedTag = widget.task.tag;
      _selectedNotice = widget.task.notice;
      _selectedTime = widget.task.time;
      _titleController = TextEditingController(text: _selectedTitle);
    });
  }

  _updateTask() async{
    await mTask.update(Task(title: _titleController.text, id: widget.task.id, date: _selectedDate, isCompleted: false, notice: _selectedNotice, time: _selectedTime, tag: _selectedTag, daysOfWeek: [],));
    await mTaskFire.updateTask(widget.login!, Task(title: _titleController.text, id: widget.task.id, date: _selectedDate, isCompleted: false, notice: _selectedNotice, time:  _selectedTime, tag: _selectedTag, daysOfWeek: [],));
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
              onPressed: () async{
                await mTask.remove(widget.task.id);
                Navigator.pop(context, true);
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
        body: Column(
            children: [
              const SizedBox(height: 10,),
              Expanded(
                child: Container(
                    width: double.maxFinite,
                    // height: 500,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: [
                                MyInputField(title: "Название", hint: _selectedTitle, controller: _titleController,),
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
                                                      'Редактировать',
                                                    ))))
                                      ]
                                  ),
                                )
                                //значок, цвет, дата
                              ],
                            ),
                          ),
                ),
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
        print(_selectedTag);
        print(item);
        if(_selectedTag == item) {
          return ItemTags(
          index: index, // required
          title: item,
          active: true, //xnjnjfhjf
          pressEnabled: true,
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
        }
        else{
          return ItemTags(
            index: index, // required
            title: item,
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
        }

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
      setState(() {
        _selectedNotice ??= "0";
        _selectedTag ??= "";
      });
      _updateTask();
    }
    else if(_titleController.text.isEmpty || _selectedTime == null || _selectedDate == null){
      const snackBar = SnackBar(
          content: Text('Введите название')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}










