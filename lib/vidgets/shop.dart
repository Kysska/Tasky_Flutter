import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Shop extends StatefulWidget{
  const Shop({super.key});


  @override
  _ShopState createState() => _ShopState();

}
class _ShopState extends State<Shop> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.red,
        shape: CircleBorder(),
      ),
      onPressed: () {
        _popupModal();
      },
      child: Icon(Icons.shopping_bag, color: Colors.white,),
    );


  }
  _popupModal(){
    final TabController tabControl = TabController(length: 4, vsync: this,);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
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
                                tabs: [
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
                                          const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              // child: _getCardClothes()
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
                                              children: <Widget>[
                                                _getCard(),
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
                                            Padding(
                                                padding: const EdgeInsets.all(15.0),
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
        });
  }
  _getCard(){
    return Container(
      height: 200,
      width: 200,
      child: Card(
          child: Column(
            children: [
              Container(
                child:  Image.asset(
                    'images/default_capibara.png',
                    width: 50,
                    height: 50),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                alignment: Alignment.centerLeft,
                child: Text("Яичница"),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                alignment: Alignment.bottomLeft,
                child: Text("100"),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    child: const Text('Купить'),
                    onPressed: () {/* ... */},
                  ),
                ],
              )
            ],
          )
      ),
    );
  }

}