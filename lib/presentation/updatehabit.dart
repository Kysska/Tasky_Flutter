import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:tasky_flutter/presentation/home.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../data/habitdatabase.dart';
import '../vidgets/input_field.dart';

class UpdateHabit extends StatefulWidget{
  final String? login;
  final bool isPattern;
  final Habit habit;
  const UpdateHabit({super.key, required this.login, required this.habit, required this.isPattern});

  @override
  State<UpdateHabit> createState() => _UpdateHabitState();
}

class _UpdateHabitState extends State<UpdateHabit>{
  late final List<bool> _isSelectedWeekday = widget.habit.listWeek;
  late final _titleController = TextEditingController(text: widget.habit.title);
  HabitFirebase mHabitFire = HabitFirebase();
  DatabaseHelperHabit mHabit = DatabaseHelperHabit.instance;
  late var _selectedTime = widget.habit.time;
  late String _selectedTag = widget.habit.tag;


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
    await mHabit.add(Habit(title: _titleController.text, id: widget.habit.id, isCompleted: [], time: _selectedTime, tag: _selectedTag, listWeek: _isSelectedWeekday, sumCompleted: widget.habit.sumCompleted, assets: widget.habit.assets, receivedGifts: widget.habit.receivedGifts,));
    mHabitFire.setDataHabitList(widget.login!, Habit(title: _titleController.text, id: widget.habit.id, isCompleted: [], time:  _selectedTime, tag: _selectedTag, listWeek: _isSelectedWeekday, sumCompleted: widget.habit.sumCompleted, assets: widget.habit.assets, receivedGifts: widget.habit.receivedGifts));
  }

  _dbHabitUpdate() async{
    await mHabit.update(Habit(title: _titleController.text, id: widget.habit.id, isCompleted: [], time: _selectedTime, tag: _selectedTag, listWeek: _isSelectedWeekday, sumCompleted: widget.habit.sumCompleted, assets: ['images/medic_1.png', 'images/medic_2.png'], receivedGifts: widget.habit.receivedGifts));
    mHabitFire.updateCountHabit(widget.login!, Habit(title: _titleController.text, id: widget.habit.id, isCompleted: [],  time:  _selectedTime, tag: _selectedTag, listWeek: _isSelectedWeekday, sumCompleted: widget.habit.sumCompleted, assets: ['images/medic_1.png', 'images/medic_2.png'], receivedGifts: widget.habit.receivedGifts));
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
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: MyInputField(title: "Название", hint: "Введите название задачи", controller: _titleController,),
          ),
          const SizedBox(height: 20,),
          WeekdaySelector(
            onChanged: (v) {
              setState(() {
                _isSelectedWeekday[v % 7] = !_isSelectedWeekday[v % 7];
              });
            },
            selectedFillColor: Colors.black,
            selectedElevation: 0,
            values: _isSelectedWeekday,
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: MyInputField(title: "Время для уведомлений", hint: _selectedTime,
              widget: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: (){
                  _getTimeFromUser();
                },
              ),
            ),
          ),
          const SizedBox(height: 20,),
          _getTagsFromUser(),
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: ElevatedButton(
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
                                )))),
                  )
                ]
            ),
          )
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

  _getTagsFromUser(){
    return Tags(
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

  _validateData() async {
    bool areAllFalse = _isSelectedWeekday.every((value) => value == false);
    if(areAllFalse){
      const snackBar = SnackBar(
          content: Text('Убедитесь, что хотябы один день недели проставлен')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else{
      if(_titleController.text.isNotEmpty){
        if(widget.isPattern == false){
          await _dbHabitUpdate();
        }
        else {
          await _dbHabitAdd();
        }
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
      else{
        const snackBar = SnackBar(
            content: Text('Введите название')
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

}