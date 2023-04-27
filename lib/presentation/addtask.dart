
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';

import '../vidgets/input_field.dart';

class AddTask extends StatefulWidget{

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with TickerProviderStateMixin{

  final _titleController = TextEditingController();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this,);
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
  _validateData() {
    if(_titleController.text.isNotEmpty){
      print("Да");
      _dbAdd();
    }
    else if(_titleController.text.isEmpty){
      final snackBar = SnackBar(
          content: const Text('Введите название')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  _dbAdd() async{
    await DatabaseHelperTask.instance.add(Task(name: _titleController.text));
  }
  _validateDataHabit() {
    if(_titleController.text.isNotEmpty){
      print("Да");
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