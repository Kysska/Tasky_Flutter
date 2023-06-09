import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/inventorydatabase.dart';
import 'package:tasky_flutter/data/shopdatabase.dart';

import '../data/gamedatabase.dart';

class Shop extends StatefulWidget{
  final String login;
  final VoidCallback onBuyButtonPressed;
  const Shop({super.key, required this.login, required this.onBuyButtonPressed,});


  @override
  _ShopState createState() => _ShopState();

}
class _ShopState extends State<Shop> with TickerProviderStateMixin {

  ShopFirebase mShop = ShopFirebase();
  InventoryDatabase mInventory = InventoryDatabase.instance;
  InventoryFirebase mInventoryFire = InventoryFirebase();
  List<EatInShop>? mListEat;
  Future<List<EatInShop>>? retrievedListEat;
  Future<List<ClothesInShop>>? retrievedListClothes;
  List<EatInShop>? mListMedic;
  List<ClothesInShop>? mListClothes;
  Future<List<EatInShop>>? retrievedListMedic;
  GameDatabase mGame = GameDatabase();
  var _kapikoinCount;

  @override
  initState(){
    super.initState();
    updateCoin();
    retrievedListEat= mShop.getEatList();
    retrievedListMedic= mShop.getMedicList();
    retrievedListClothes = mShop.getClothesList();
    getMedFood();
    getListFood();
    getClothesFood();
  }
  Future<void> updateCoin() async{
    _kapikoinCount = await mGame.getMoney();
  }

  _updateKapicoin(newCount) async{
    _kapikoinCount = newCount;
    await mGame.setMoney(_kapikoinCount);
  }

  Future<List<EatInShop>?> getListFood() async{
    mListEat = await mShop.getEatList();
    return mListEat;
  }

  Future<List<EatInShop>?> getMedFood() async{
    mListMedic = await mShop.getMedicList();
    return mListMedic;
  }

  Future<List<ClothesInShop>?> getClothesFood() async{
    mListClothes = await mShop.getClothesList();
    return mListClothes;
  }


  @override
  Widget build(BuildContext context) {
    final TabController tabControl = TabController(length: 3, vsync: this,);
    return DraggableScrollableSheet(
    expand: false,
    builder: (context, scrollController) => SingleChildScrollView(
      // child: Padding(
      //   padding: MediaQuery.of(context).viewInsets,
      child: StatefulBuilder(builder:
          (BuildContext context, StateSetter setState) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              // color: colorPrimary,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
              ),
            ),
            child: DefaultTabController(
              length: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12),
                child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      TabBar(
                        controller: tabControl,
                        indicator: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink.shade100, Colors.blue.shade100]),
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue),
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.fastfood_rounded, color: Colors.black87,),
                            text: "Еда",
                          ),
                          Tab(
                            icon: Icon(Icons.loyalty_outlined, color: Colors.black87),
                            text: "Лекарства",
                          ),
                          Tab(
                            icon: Icon(Icons.home_filled, color: Colors.black87),
                            text: "Одежда",
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabControl,
                          children: <Widget>[
                            Column(
                                children: [Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  height: 320.0,
                                  child:
                                  Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: _getCard()
                                  ),
                                ),
                                ]
                            ),
                            Column(
                                children: [Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  height: 320.0,
                                  child:
                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: _getMedicCard()
                                  ),
                                ),
                                ]
                            ),
                            Column(
                                children: [Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  height: 320.0,
                                  child:
                                  Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: _getClothesCard()
                                  ),
                                ),
                                ]
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ));
      }),
      // ),
    ),
  );

  }
  _getCard(){
    return FutureBuilder<List<EatInShop>>(
      future: retrievedListEat,
      builder: (BuildContext context, AsyncSnapshot<List<EatInShop>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
              itemCount: mListEat != null ? mListEat!.length : 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (mListEat == null) {
                  return const Center(
                    child:
                    Text("Если вы увидели это, перейдите либо на соседнюю вкладку магазина,"
                        " либо выйдите из магазина и зайдите ещё раз"),
                  );
                }
                return Container(
                  height: 170,
                  width: 160,
                  child: Card(
                      child: Column(
                        children: [
                          Container(
                            child: Image.asset(mListEat![index].asset,
                                width: 50, height: 50),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            alignment: Alignment.centerLeft,
                            child: Text(mListEat![index].title),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            alignment: Alignment.bottomLeft,
                            child: Text(mListEat![index].money.toString()),
                          ),
                          ButtonBar(
                            children: [
                              TextButton(
                                child: const Text('Купить'),
                                onPressed: () async {
                                  int newCount = _kapikoinCount - mListEat![index].money;
                                  if(newCount > _kapikoinCount){
                                    const snackBar = SnackBar(
                                        content: Text('Не хватает монет')
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                  else{
                                    _updateKapicoin(_kapikoinCount - mListEat![index].money);
                                    bool foodIn = await mInventory.checkIfExists(mListEat![index].title);
                                    if(foodIn){
                                      int count = await mInventory.getCount(mListEat![index].title);
                                      count +=1;
                                      await mInventory.updateCount(count, mListEat![index].title);
                                      widget.onBuyButtonPressed();
                                      mInventoryFire.updateCountEat(widget.login, count, mListEat![index].title);
                                    }
                                    else{
                                      await mInventory.add(EatInInventory(title: mListEat![index].title, asset: mListEat![index].asset, money: mListEat![index].money, count: 1));
                                      widget.onBuyButtonPressed();
                                      mInventoryFire.setDataEatList(widget.login, EatInInventory(title: mListEat![index].title, asset: mListEat![index].asset, money: mListEat![index].money, count: 1));
                                    }
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      )),
                );
              }
          );
        }
        else if (snapshot.connectionState == ConnectionState.done &&
            mListEat!.isEmpty) {
          return const Text('No data available');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        }
    );
  }

  _getClothesCard(){
    return FutureBuilder<List<ClothesInShop>>(
      future: retrievedListClothes,
      builder: (BuildContext context, AsyncSnapshot<List<ClothesInShop>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              ClothesInShop clothes = snapshot.data![index];
              bool isBuy = clothes.isBuy;
              return FutureBuilder<bool>(
                future: InventoryClothesDatabase.instance.checkIfExists(clothes.title),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    bool foodIn = snapshot.data ?? false;

                    return Container(
                      height: 170,
                      width: 160,
                      child: Card(
                        color: isBuy ? Colors.white : Colors.grey,
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset(clothes.asset, width: 50, height: 50),
                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.centerLeft,
                              child: Text(clothes.title),
                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.bottomLeft,
                              child: Text(clothes.money.toString()),
                            ),
                            ButtonBar(
                              children: [
                                isBuy
                                    ? foodIn
                                    ? Icon(Icons.check)
                                    : TextButton(
                                  child: const Text('Купить'),
                                  onPressed: () async {
                                    int newCount = _kapikoinCount - clothes.money;
                                    if (newCount > _kapikoinCount) {
                                      const snackBar = SnackBar(content: Text('Не хватает монет'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    } else {
                                      _updateKapicoin(_kapikoinCount - clothes.money);
                                      await InventoryClothesDatabase.instance.add(
                                        ClothesInInventory(
                                          title: clothes.title,
                                          asset: clothes.asset,
                                          money: clothes.money,
                                        ),
                                      );
                                      setState(() {});
                                      widget.onBuyButtonPressed(); //TODO
                                      //  mInventoryFire.setDataEatList(widget.login, ClothesInInventory(title: mListClothes![index].title, asset: mListClothes![index].asset, money: mListClothes![index].money,));
                                    }
                                  },
                                )
                                    : Icon(Icons.lock),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  _getMedicCard(){
    return FutureBuilder<List<EatInShop>>(
        future: retrievedListMedic,
        builder: (BuildContext context, AsyncSnapshot<List<EatInShop>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
                itemCount: mListMedic != null ? mListMedic!.length : 0,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  if(mListMedic == null){
                    return const Center(
                      child:
                          Text("Если вы увидели это, перейдите либо на соседнюю вкладку магазина,"
                          " либо выйдите из магазина и зайдите ещё раз"),
                    );
                  }
                  return Container(
                    height: 170,
                    width: 160,
                    child: Card(
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset(mListMedic![index].asset,
                                  width: 50, height: 50),
                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.centerLeft,
                              child: Text(mListMedic![index].title),
                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.bottomLeft,
                              child: Text(mListMedic![index].money.toString()),
                            ),
                            ButtonBar(
                              children: [
                                TextButton(
                                  child: const Text('Купить'),
                                  onPressed: () async {
                                    int newCount = _kapikoinCount - mListMedic![index].money;
                                    if(newCount > _kapikoinCount){
                                      const snackBar = SnackBar(
                                          content: Text('Не хватает монет')
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                    else{
                                      _updateKapicoin(_kapikoinCount - mListMedic![index].money);
                                      bool foodIn = await mInventory.checkIfExists(mListMedic![index].title);
                                      if(foodIn){
                                        int count = await mInventory.getCount(mListMedic![index].title);
                                        count +=1;
                                        await mInventory.updateCount(count, mListMedic![index].title);
                                        await mInventoryFire.updateCountEat(widget.login, count, mListMedic![index].title);
                                      }
                                      else{
                                        await mInventory.add(EatInInventory(title: mListMedic![index].title, asset: mListMedic![index].asset, money: mListMedic![index].money, count: 1));
                                        await mInventoryFire.setDataEatList(widget.login, EatInInventory(title: mListMedic![index].title, asset: mListMedic![index].asset, money: mListMedic![index].money, count: 1));
                                      }
                                    }
                                  },
                                ),
                              ],
                            )
                          ],
                        )),
                  );
                }
            );
          }
          else if (snapshot.connectionState == ConnectionState.done &&
              mListEat!.isEmpty) {
            return const Text('No data available');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }

}