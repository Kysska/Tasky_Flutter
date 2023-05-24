import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/forumdatabase.dart';
import 'package:tasky_flutter/presentation/infoforum.dart';

import 'addarticle.dart';

class Forum extends StatefulWidget {
  late String login;
  Forum({required this.login});
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Forum> with TickerProviderStateMixin {
  TabController? _tabController;
  DatabaseHelperForum mForum = DatabaseHelperForum.instance;
  ArticleFirebase mForumFire = ArticleFirebase();
  late List<String> idUser;
  Future<List<Article>>? _questions;
  List<Article>? _retrievedQuestions;

  _initLike() async {
    idUser = await mForum.getNotes();
  }

  @override
  void initState() {
    _tabController =
        TabController(length: 2, vsync: this);
    _initLike();
    getListArticle();
    _questions = mForumFire.getArticleList(widget.login);
    super.initState();
  }

  Future<List<Article>?> getListArticle() async{
    _retrievedQuestions = (await mForumFire.getArticleList(widget.login));
    return _retrievedQuestions;
  }

  _refreshPage(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: "Сообщения",
                height: 85,
              ),
              Tab(
                text: "Мои Сообщения",
                height: 85,
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Text("Сортировать по"),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _retrievedQuestions?.sort((a, b) => (b.date).compareTo((a.date)));
                      });
                    },
                    child: Text("времени"),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _retrievedQuestions?.sort((a, b) => b.likes.compareTo(a.likes));
                      });
                    },
                    child: Text("лайкам"),
                  ),
                  ]
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) =>
                  AddArticle(article: Article(id: '', login: widget.login, title: '', desc: '', date: '', likes: 0),
                    isEdit: false,
                    login: widget.login,))).then((value) =>
          {
            if(value != null && value == true){
              _refreshPage()
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Опубликовать на форуме'),
        backgroundColor: Colors.indigoAccent,
      ),
      body:
      TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder(
          future: _questions,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: Colors.transparent);
            } else if (snapshot.hasError) {
              return Text('Ошибка: ${snapshot.error}');
            }
            else {
              return SingleChildScrollView(
                child: Column(
                    children: _retrievedQuestions!.map((question) =>
                        GestureDetector(
                          onTap:
                              () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    PostScreen(article: question,
                                      login: widget.login, likes: idUser,))).then((value) =>
                            {
                              if(value != null && value == true){
                                // _refreshPage()
                              }
                            });
                          },
                          child: Container(
                            height: 180,
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [BoxShadow(
                                    color: Colors.black26.withOpacity(0.05),
                                    offset: Offset(0.0, 6.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 0.10
                                )
                                ]
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    height: 70,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'images/default_avatar.png'),
                                              radius: 22,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.65,
                                                    child: Text(
                                                        "${question.title.length >= 25 ? question.title.substring(0, 25) + '..' : question.title}",
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          letterSpacing: .4
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2.0),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        question.login,
                                                        style: TextStyle(
                                                            color: Colors.grey
                                                                .withOpacity(0.6)
                                                        ),
                                                      ),
                                                      SizedBox(width: 15),
                                                      Text(
                                                        question.date,
                                                        style: TextStyle(
                                                            color: Colors.grey
                                                                .withOpacity(0.6)
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "${question.desc.length >= 281 ? question.desc.substring(0, 281) + '..' : question.desc}",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(0.8),
                                            fontSize: 16,
                                            letterSpacing: .3
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.grey.withOpacity(0.6),
                                            size: 22,
                                          ),
                                          SizedBox(width: 4.0),
                                          Text(
                                            "${question.likes} like",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.withOpacity(0.6),
                                                fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                    ).toList()
                ),
              );
          }
  },
        ),
          FutureBuilder(
            future: ArticleFirebase().getArticleListUser(widget.login),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Ошибка: ${snapshot.error}');
              }
              else {
                List<Article> questions = snapshot.data ?? [];
                return SingleChildScrollView(
                  child: Column(
                      children: questions.map((question) =>
                          GestureDetector(
                            onTap:
                                () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      PostScreen(article: question,
                                        login: widget.login, likes: idUser,))).then((value) =>
                              {
                                if(value != null && value == true){
                                  _refreshPage()
                                }
                              });
                            },
                            child: Container(
                              height: 180,
                              margin: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [BoxShadow(
                                      color: Colors.black26.withOpacity(0.05),
                                      offset: Offset(0.0, 6.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.10
                                  )
                                  ]
                              ),
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundImage: AssetImage('images/default_avatar.png'),
                                            radius: 22,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    question.title.length >= 25 ? '${question.title.substring(0, 25)}..' : question.title,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: .4
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                Text(
                                                  question.date,
                                                  style: const TextStyle(
                                                      color: Colors.grey
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      PopupMenuButton<String>(
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('Удалить'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Text('Редактировать'),
                                          ),
                                        ],
                                        onSelected: (String value) async {
                                          switch (value) {
                                            case 'delete':
                                              await mForumFire.deleteArticle(question.id, question.login);
                                              _refreshPage();
                                              break;
                                            case 'edit':
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AddArticle(
                                                    article: Article(
                                                      id: question.id,
                                                      login: widget.login,
                                                      title: question.title,
                                                      desc: question.desc,
                                                      date: question.date,
                                                      likes: 0,
                                                    ),
                                                    isEdit: true,
                                                    login: widget.login,
                                                  ),
                                                ),
                                              ).then((value) {
                                                if (value != null && value == true) {
                                                  _refreshPage();
                                                }
                                              });
                                              break;
                                          }
                                        },
                                        child: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey.withOpacity(0.6),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                    Container(
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "${question.desc.length >= 281 ? question.desc.substring(0, 281) + '..' : question.desc}",
                                          style: TextStyle(
                                              color: Colors.grey.withOpacity(0.8),
                                              fontSize: 16,
                                              letterSpacing: .3
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.grey.withOpacity(0.6),
                                              size: 22,
                                            ),
                                            SizedBox(width: 4.0),
                                            Text(
                                              "${question.likes} like",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.withOpacity(0.6),
                                                  fontWeight: FontWeight.w600
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                      ).toList()
                  ),
                );
              }
            },
          ),

        ]
      ),
    );
  }
}