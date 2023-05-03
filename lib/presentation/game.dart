import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/vidgets/kapibara.dart';
import 'package:tasky_flutter/vidgets/shop.dart';

class Game extends StatefulWidget{
  const Game({super.key});


  @override
  _GameState createState() => _GameState();

}
class _GameState extends State<Game> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final _scrollController = ScrollController();
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("images/room.jpg"),
            //   fit: BoxFit.cover,
            // ),
          ),
          child:
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                backgroundColor: Colors.red,
                                shape: CircleBorder(),
                              ),
                              onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Shop();
                              });
                        },
                        child: Icon(Icons.shopping_bag, color: Colors.white,),
                            )
                          ),
                          // Column(
                          //   children: [
                          //     LinearPercentIndicator(
                          //       center: new Text("Hunger: $_hunger%", style: TextStyle(color: Colors.white,
                          //         fontSize: 16,)),
                          //       lineHeight: 20,
                          //       width: MediaQuery.of(context).size.width * 0.5,
                          //       barRadius: Radius.circular(35),
                          //       percent: _hunger / maxHunger,
                          //       progressColor: Colors.red,
                          //       backgroundColor: Colors.grey[400],
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Align(
                          //         alignment: Alignment.centerRight,
                          //         child: Row(
                          //           children: <Widget>[
                          //             Icon(
                          //               Icons.trip_origin,
                          //               color: Colors.yellow,
                          //               size: 24.0,
                          //             ),
                          //             SizedBox(width: 4.0),
                          //             Text(countNowMoney.toString(), style: TextStyle(fontSize: 24.0, color: Colors.black87))
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 10),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                          },
                          child: Stack(
                              children: [DragTarget<String>(builder: (context, candidateData, rejectedData){
                                  return Kapibara();
                              },
                                  onWillAccept: (data) {
                                    return data == data;
                                  },
                                  onAccept: (data) {
                                    // putListFood(data).then((value) =>
                                    //     setState(() {
                                    //       _feed(10);
                                    //       listFood[data] = listFood[data]! -1;
                                    //       num? currentValueMoney = listFood[data];
                                    //       FirebaseFirestore.instance.collection('users').doc(deviceId).collection('food').doc(data).update({'count' : currentValueMoney});
                                    //       // _isDropped = true;
                                    //     }));
                                  }
                              ),
                              ]
                          ),
                        ),

                      ],
                    ),
                ),
                // Center(
                //   child: Row(
                //     children: [
                //       IconButton(
                //         icon: Icon(Icons.arrow_left),
                //         onPressed: () {
                //           _scrollController.animateTo(_scrollController.offset - MediaQuery.of(context).size.width * 0.5, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                //         },
                //       ),
                //       Expanded(
                //         child: Container(
                //           height: 200,
                //           child: SingleChildScrollView(
                //             controller: _scrollController,
                //             scrollDirection: Axis.horizontal,
                //             child: StreamBuilder(
                //               stream: FirebaseFirestore.instance.collection('users').doc(deviceId).collection('food').snapshots(),
                //               builder: (BuildContext context,
                //                   AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                //                 print("3");
                //                 print(_hunger);
                //                 if(!setState1) {
                //                   return CircularProgressIndicator();
                //                 }
                //                 if (snapshot.connectionState == ConnectionState.waiting) {
                //                   return SizedBox.shrink();
                //                 }
                //                 int length;
                //                 if(snapshot.data == null || snapshot.data!.docs.isEmpty)
                //                 {
                //                   length = 0;
                //                 } else {
                //                   length = snapshot.data!.docs.length;
                //                 }
                //                 return Row(
                //                   children: List.generate(length, (index) {
                //                     final int count = snapshot.data!.docs[index].get('count');
                //                     if (count <= 0) {
                //                       return SizedBox.shrink();
                //                     }
                //                     return Draggable(data: snapshot.data!.docs[index].id,
                //                       child: Padding(
                //                           padding: const EdgeInsets.all(
                //                               2.0),
                //                           child:
                //                           Container(
                //                             // height: 70,
                //                             // width: 70,
                //                             // decoration: BoxDecoration(
                //                             //   shape: BoxShape.circle,
                //                             //   color: Colors.white,
                //                             // ),
                //                             child: Image.asset(
                //                               snapshot.data!.docs[index].get('image'), width: 100,
                //                               height: 100,),
                //                           )
                //                       ),
                //
                //                       feedback: Padding(
                //                           padding: const EdgeInsets.all(
                //                               2.0),
                //                           child:
                //                           Container(
                //                             // height: 70,
                //                             // width: 70,
                //                             // decoration: BoxDecoration(
                //                             //   shape: BoxShape.circle,
                //                             //   color: Colors.white,
                //                             // ),
                //                             child: Image.asset(
                //                               snapshot.data!.docs[index].get('image'), width: 100,
                //                               height: 100,),
                //                           )
                //                       ),);
                //                   }),//data!!!!
                //                 );},
                //             ),
                //           ),
                //         ),
                //       ),
                //       IconButton(
                //         icon: Icon(Icons.arrow_right),
                //         onPressed: () {
                //           _scrollController.animateTo(_scrollController.offset + MediaQuery.of(context).size.width * 0.5, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                //         },
                //       ),
                //     ],
                //   ),
                // )
              ]

          ),
        ) ); }

}