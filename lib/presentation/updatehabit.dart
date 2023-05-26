import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:tasky_flutter/presentation/home.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../data/habitdatabase.dart';
import '../vidgets/input_field.dart';

class UpdateHabit extends StatefulWidget{
  final String? login;
  final Habit habit;
  const UpdateHabit({super.key, required this.login, required this.habit});

  @override
  State<UpdateHabit> createState() => _UpdateHabitState();
}

class _UpdateHabitState extends State<UpdateHabit>{
  late List<bool> _isSelectedWeekday = widget.habit.listWeek;
  late var _titleController = TextEditingController(text: widget.habit.title);
  HabitFirebase mHabitFire = HabitFirebase();
  DatabaseHelperHabit mHabit = DatabaseHelperHabit.instance;
  late var _selectedNotice = widget.habit.notice;
  late var _selectedTime = widget.habit.time;
  late String _selectedTag = widget.habit.tag;

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

  _dbHabitUpdate() async{
    await mHabit.update(Habit(title: _titleController.text, id: widget.habit.id, isCompleted: [], notice: _selectedNotice, time: _selectedTime, tag: _selectedTag, listWeek: _isSelectedWeekday, sumCompleted: widget.habit.sumCompleted,));
    await mHabitFire.updateCountHabit(widget.login!, Habit(title: _titleController.text, id: widget.habit.id, isCompleted: [], notice: _selectedNotice, time:  _selectedTime, tag: _selectedTag, listWeek: _isSelectedWeekday, sumCompleted: widget.habit.sumCompleted,));
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
              Navigator.pop(context, true);
              Navigator.pop(context, true);
              await mHabit.remove(widget.habit.id);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          MyInputField(title: "Название", hint: "Введите название задачи", controller: _titleController,),
          const SizedBox(height: 18,),
          WeekdaySelector(
            onChanged: (v) {
              setState(() {
                print(v % 7);
                _isSelectedWeekday[v % 7] = !_isSelectedWeekday[v % 7];
              });
            },
            values: _isSelectedWeekday,
          ),
          const SizedBox(height: 18,),
          MyInputField(title: "Время для уведомлений", hint: _selectedTime,
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
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
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

  _validateData() async {
    if(_titleController.text.isNotEmpty){
      _selectedTime ??= "15:00";
      _selectedNotice ??= "0";
      await _dbHabitUpdate();
    }
    else if(_titleController.text.isEmpty){
      final snackBar = SnackBar(
          content: const Text('Введите название')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}