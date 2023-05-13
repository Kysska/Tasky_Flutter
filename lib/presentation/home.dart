import 'dart:math';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask(login: widget.login,))).then((value) => {
            if(value!=null && value == true){
              refreshPage()
            }
          });
        },

        child: Icon(
          Icons.add_box,
          color: Colors.white,

        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              color: Colors.white,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: DatePicker(
              DateTime.now().subtract(Duration(days: 30)),
              height: 100,
              width: 80,
              controller: _controller,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.blue,
              selectedTextColor: Colors.white,
              dateTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey
              ),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
                // _showTasks();
              },
            ),
          ),
          MyDraggableScrollableSheet(login: widget.login,)
        ],
      )
      );
    
  }
  refreshPage(){
    setState(() {});
  }
}

class MyDraggableScrollableSheet extends StatefulWidget {
  final String? login;
  const MyDraggableScrollableSheet({super.key, this.login});

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

  @override
  void initState() {
    super.initState();
    retrievedListTask = mTask.getTasks();
    getListTask();
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
            // Contents of the sheet
            child:
              Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ToggleButtons(
                      children: <Widget>[
                        Text("Задачи"),
                        Text("Привычки"),
                      ],
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Scrollbar(
                      child: FutureBuilder<List<Task>>(
                        future: retrievedListTask,
                        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Text('Loading..'));
                          }
                          return snapshot.data!.isEmpty
                              ? Center(child: Text('No Tasks'),)
                              : ListView.builder(
                            controller: scrollController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Dismissible(
                                  key: Key(snapshot.data![index].id),
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
                                          Container(
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
                                              ? Text("Выполнено")
                                              : IconButton(
                                            icon: Icon(
                                              Icons.check,
                                              color: Colors.pink,
                                            ),
                                            onPressed: () {
                                              // do something when pressed
                                            },
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
          );
      },
    );
    //             child: ToggleButtons(
    //               children: <Widget>[
    //                 Text("Задачи"),
    //                 Text("Привычки"),
    //               ],
    //               isSelected: _isSelected,
    //               borderRadius: BorderRadius.all(Radius.circular(10)),
    //               fillColor: Colors.blueAccent,
    //               color: Colors.black87,
    //               selectedColor: Colors.white,
    //               onPressed: (int index) {
    //                 setState(() {
    //                   _isSelected[0] = !_isSelected[0];
    //                   _isSelected[1] = !_isSelected[1];
    //                 });
    //               },
    //             ),
    //           ),
  }
}
