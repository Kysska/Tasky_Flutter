import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/taskdatabase.dart';

import 'addtask.dart';

class Home extends StatefulWidget{
  const Home({super.key});


  @override
  _HomeState createState() => _HomeState();

}
class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask())).then((value) => {
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
      body: Center(
        child: FutureBuilder<List<Task>>(
          future: DatabaseHelperTask.instance.getTasks(),
          builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot){
            if(!snapshot.hasData){
              return Center(child: Text('Loading..'));
            }
            return snapshot.data!.isEmpty
            ? Center(child: Text('No Tasks'),)
            : ListView(
              children: snapshot.data!.map((e) {
                return Center(
                  child: ListTile(
                  title: Text(e.name),
              ),
              );
              }).toList(),
            );
          }
          ),
        ),
      );
    
  }
  refreshPage(){
    setState(() {});
  }


}