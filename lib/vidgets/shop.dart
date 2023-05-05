import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/shopdatabase.dart';

class Shop extends StatefulWidget{
  const Shop({super.key});


  @override
  _ShopState createState() => _ShopState();

}
class _ShopState extends State<Shop> with TickerProviderStateMixin {

  ShopFirebase mShop = ShopFirebase();
  InventoryDatabase inventoryDatabase = InventoryDatabase.instance;
  List<EatInShop>? mListEat;
  Future<List<EatInShop>>? retrievedListEat;

  @override
  void initState() {
    super.initState();
    retrievedListEat= mShop.getEatList();
    getListFood();
  }

  Future<List<EatInShop>?> getListFood() async{
    mListEat = await mShop.getEatList();
    return mListEat;
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabControl = TabController(length: 4, vsync: this,);
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
            decoration: BoxDecoration(
              // color: colorPrimary,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: const Radius.circular(18.0),
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
                            text: "Одежда",
                          ),
                          Tab(
                            icon: Icon(Icons.home_filled, color: Colors.black87),
                            text: "Комната",
                          ),
                          Tab(
                              icon: Icon(Icons.face, color: Colors.black87),
                              text: "Инвентарь"
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabControl,
                          children: <Widget>[
                            Column(
                                children: [
                                  Container(
                                    height: 320.0,
                                    child:
                                    const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      // child: _getCardFood()
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
                                    child: _getCard()
                                  ),
                                ),
                                ]
                            ),
                            Column(
                                children:[
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: const <Widget>[
                                        // _getCard(),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                            Column(
                                children:[
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    height: 320.0,
                                    child:
                                    const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      // child: _getInventar()
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
              itemCount: mListEat!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
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
                                  int? count = await inventoryDatabase.getCount(mListEat![index].title);
                                  print(count);
                                 if(count! > 0){
                                   count+=1;
                                   inventoryDatabase.updateCount(count, mListEat![index].title);
                                 }
                                 else{
                                   inventoryDatabase.add(EatInInventory(title: mListEat![index].title, asset: mListEat![index].asset, money: mListEat![index].money, count: 1));
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