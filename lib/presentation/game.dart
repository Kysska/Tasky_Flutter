import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tasky_flutter/vidgets/shop.dart';

import '../data/gamedatabase.dart';
import '../data/inventorydatabase.dart';

class Game extends StatefulWidget {
  final String login;

  const Game({super.key, required this.login});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  InventoryFirebase mInventoryFire = InventoryFirebase();
  GameDatabase mGame = GameDatabase();
  Timer _hungerTimer = Timer.periodic(const Duration(minutes: 15), (timer) {});
  Timer _gifTimer = Timer.periodic(const Duration(minutes: 48), (timer) {});
  late Map<String, int> listFood = {};
  late ImageProvider myImageProvider;
  late int _kapikoinCount;
  late final List<String> gifList = [
    "images/Sit-1.gif",
    "images/Sit-2.gif",
    "images/Sleep-1.gif",
    "images/Sleep-2.gif",
  ];
  late final List<String> gifTapList = [
    "images/Tap-1.gif",
    "images/Tap-2.gif",
  ];
  late String gifAnimation = "images/Sit-1.gif";
  int _currentGifIndex = 0;
  int _currentGifTapIndex = 0;

  ///////////////////////////
  int _hungerScale = 100;
  int _hp = 3;
  List<Widget> hearts = List.generate(
    3,
    (index) => Icon(Icons.favorite, color: Colors.red),
  );

  @override
  void initState() {
    super.initState();
    myImageProvider = AssetImage(gifAnimation);
    _loadHungerScale();
    _getKapikoinCount();
    _gifTimerLoad();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheGifs();
  }

  _gifTimerLoad() {
    _gifTimer = Timer.periodic(Duration(seconds: 48), (timer) {
      setState(() {
        _currentGifIndex = (_currentGifIndex + 1) % gifList.length;
        gifAnimation = gifList[_currentGifIndex];
      });
    });
  }

  _loadHungerScale() {
    Future<int?> lastUpdated = mGame.getLastHunger();
    Future<int?> hp = mGame.getHpScale();
    Future<int?> hunger = mGame.getHungerScale();
    _loadHunger(lastUpdated, hp, hunger);
  }

  void _precacheGifs() async {
    await precacheImage(myImageProvider, context);
    for (var gifPath in gifList) {
      await precacheImage(AssetImage(gifPath), context);
    }
    for (var gifTapPath in gifTapList) {
      await precacheImage(AssetImage(gifTapPath), context);
    }
  }

  _startAnimation() {
    _currentGifTapIndex = (_currentGifTapIndex + 1) % gifTapList.length;
    gifAnimation = gifTapList[_currentGifTapIndex];
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        gifAnimation = gifList[_currentGifIndex];
      });
    });
  }

  //////////////////////////

  Future _getKapikoinCount() async {
    _kapikoinCount = await GameDatabase().getMoney();
  }

  ////////////////////////
  void onBuyButtonPressed() {
   setState(() {});
  }
  //////////////////////
  @override
  void dispose() {
    _hungerTimer.cancel();
    _gifTimer.cancel();
    super.dispose();
  }

  void _startTimers() {
    _hungerTimer = Timer.periodic(Duration(minutes: 15), (timer) {
      setState(() {
        if (_hungerScale <= 0 && _hp > 0) {
          _hungerScale = 100;
          _hp--;
          _changeHearts();
        } else if (_hungerScale <= 0 && _hp == 0) {
          _gifTimer.cancel();
          _hungerTimer.cancel();
        } else {
          _hungerScale--;
        }
      });
      _saveData();
    });
  }

  Future<void> _loadHunger(
      Future<int?> lastHunger, Future<int?> hp, Future<int?> hunger) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final int lastHungerValue = await lastHunger as int;
    final int hpValue = await hp as int;
    final int hungerValue = await hunger as int;
    if (lastHunger != null) {
      final difference =
          (now - (lastHungerValue)) ~/ 1000; // calculate difference in seconds
      final decrease =
          difference ~/ 1800; // decrease hunger by 1 for every minute
      final newHunger = (hungerValue) - decrease;
      if (newHunger > 0) {
        setState(() {
          _hungerScale = newHunger;
          _hp = hpValue;
        });
        _startTimers();
        _changeHearts();
      } else {
        if (hpValue == 0) {
          setState(() {
            _hungerScale = 0;
            _hp = hpValue;
          });
          _changeHearts();
          _startTimers();
        } else {
          setState(() {
            _hungerScale = 0;
            _hp = 0;
          });
          _changeHearts();
        }
      }
    } else {
      setState(() {
        _hungerScale = 100;
        _hp = 3;
      });
      _changeHearts();
      _startTimers();
    }
  }

  _showBlock() async {
    if (_kapikoinCount >= 10) {
      _kapikoinCount -= 10;
      await mGame.setMoney(_kapikoinCount);
      _startTimers();
      _gifTimerLoad();
      setState(() {
        _hungerScale = 100;
        _hp = 3;
      });
      _changeHearts();
    } else {
      const snackBar = SnackBar(content: Text('Не хватает монет'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _changeHearts() {
    hearts.clear();
    for (int i = 1; i <= 3; i++) {
      if (i <= _hp) {
        hearts.add(Icon(Icons.favorite, color: Colors.red));
      } else {
        hearts.add(Icon(Icons.favorite, color: Colors.grey));
      }
    }
  }

  void _saveData() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await mGame.setHpScale(_hp);
    await mGame.setHungerScale(_hungerScale);
    await mGame.setLastHunger(now);
  }

  void _feedPet() {
    if (_hungerScale + 10 <= 100) {
      setState(() {
        _hungerScale += 10; //10 - кол-во поднятия шкалы голода
      });
      _saveData();
    }
    else{
      setState(() {
        _hungerScale = 100;
      });
      _saveData();
    }
  }

  Future<void> _medic1Pet() async {
    if (_hp < 3) {
      setState(() {
        _hp += 1;
      });
      _changeHearts();
      await mGame.setHpScale(_hp);
    }
  }

  Future<void> _medic2Pet() async {
    if (_hp < 3) {
      setState(() {
        _hp = 3;
      });
      _changeHearts();
      await mGame.setHpScale(_hp);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Shop(login: widget.login, onBuyButtonPressed: () { setState(() {}); },);
                          },
                        );
                      },
                      child: Text(
                        "Магазин",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      LinearPercentIndicator(
                        center: new Text("Голод: $_hungerScale%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                        lineHeight: 20,
                        width: MediaQuery.of(context).size.width * 0.5,
                        barRadius: Radius.circular(35),
                        percent: _hungerScale / 100,
                        progressColor: Colors.red,
                        backgroundColor: Colors.grey[400],
                      ),
                      Row(
                        children: [hearts[0], hearts[1], hearts[2]],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _startAnimation();
              });
            },
            child: Stack(children: [
              DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                if (_hungerScale <= 0 && _hp == 0) {
                  return Column(
                    children: [
                      const Text("Он ушёл, но обещал вернуться"),
                      const Text("Восстановить здоровье"),
                      TextButton(
                          onPressed: _showBlock,
                          child: const Text("1000 kapikount"))
                    ],
                  );
                } else {
                  return Image.asset(
                    gifAnimation,
                  );
                }
              }, onWillAccept: (data) {
                return data == data;
              }, onAccept: (data) async {
                if (_hungerScale > 0) {
                  if (data == "Мята(1 здоровье)") {
                    _medic1Pet();
                  } else if (data == "Чай(3 здоровья)") {
                    _medic2Pet();
                  } else {
                    _feedPet();
                  }
                  await InventoryDatabase.instance.updateCount(listFood[data]! - 1, data);
                  _refreshPage();
                  await mInventoryFire.updateCountEat(
                      widget.login, listFood[data]! - 1, data);
                }
              }),
            ]),
          ),
        ),
        Center(
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: () {
                  _scrollController.animateTo(
                      _scrollController.offset -
                          MediaQuery.of(context).size.width * 0.5,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
              ),

              // Expanded(
              //   child: Container(
              //     height: 200,
              //     child: SingleChildScrollView(
              //       controller: _scrollController,
              //       scrollDirection: Axis.horizontal,
              //       child: StreamBuilder<List<EatInInventory>>(
              //           stream: InventoryDatabase.instance.getEatListStream(),
              //           builder: (BuildContext context,
              //               AsyncSnapshot<List<EatInInventory>> snapshot) {
              //             if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              //               return Row(
              //                 children:
              //                     List.generate(snapshot.data!.length, (index) {
              //                   final int count = snapshot.data![index].count;
              //                   listFood[snapshot.data![index].title] = count;
              //                   if (count <= 0) {
              //                     return SizedBox.shrink();
              //                   }
              //                   return Draggable(
              //                     data: snapshot.data![index].title,
              //                     feedback: Padding(
              //                         padding: const EdgeInsets.all(2.0),
              //                         child: Container(
              //                           // height: 70,
              //                           // width: 70,
              //                           // decoration: BoxDecoration(
              //                           //   shape: BoxShape.circle,
              //                           //   color: Colors.white,
              //                           // ),
              //                           child: Image.asset(
              //                             snapshot.data![index].asset,
              //                             width: 100,
              //                             height: 100,
              //                           ),
              //                         )),
              //                     child: Padding(
              //                         padding: const EdgeInsets.all(2.0),
              //                         child: Container(
              //                           // height: 70,
              //                           // width: 70,
              //                           // decoration: BoxDecoration(
              //                           //   shape: BoxShape.circle,
              //                           //   color: Colors.white,
              //                           // ),
              //                           child: Image.asset(
              //                             snapshot.data![index].asset,
              //                             width: 100,
              //                             height: 100,
              //                           ),
              //                         )),
              //                   );
              //                 }), //data!!!!
              //               );
              //             } else if (snapshot.connectionState ==
              //                     ConnectionState.done &&
              //                 snapshot.data!.isEmpty) {
              //               return SizedBox.shrink();
              //             } else {
              //               return CircularProgressIndicator();
              //             }
              //           }),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Container(
                  height: 200,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: StreamBuilder<List<ClothesInInventory>>(
                        stream: InventoryClothesDatabase.instance.getEatListStream(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ClothesInInventory>> snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return Row(
                              children:
                                  List.generate(snapshot.data!.length, (index) {
                                return Draggable(
                                  data: snapshot.data![index].title,
                                  feedback: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        // height: 70,
                                        // width: 70,
                                        // decoration: BoxDecoration(
                                        //   shape: BoxShape.circle,
                                        //   color: Colors.white,
                                        // ),
                                        child: Image.asset(
                                          snapshot.data![index].asset,
                                          width: 100,
                                          height: 100,
                                        ),
                                      )),
                                  child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        // height: 70,
                                        // width: 70,
                                        // decoration: BoxDecoration(
                                        //   shape: BoxShape.circle,
                                        //   color: Colors.white,
                                        // ),
                                        child: Image.asset(
                                          snapshot.data![index].asset,
                                          width: 100,
                                          height: 100,
                                        ),
                                      )),
                                );
                              }), //data!!!!
                            );
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data!.isEmpty) {
                            return SizedBox.shrink();
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                  _scrollController.animateTo(
                      _scrollController.offset +
                          MediaQuery.of(context).size.width * 0.5,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
              ),
            ],
          ),
        )
      ]),
    ));
  }

  _refreshPage() {
    setState(() {});
  }
}
