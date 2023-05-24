import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/forumdatabase.dart';

class PostScreen extends StatefulWidget {
  late String login;
  late Article article;
  late List<String> likes;
  PostScreen({required this.article, required this.login, required this.likes});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool isFavorite = false;
  late int _countLike;
  DatabaseHelperForum mForum = DatabaseHelperForum.instance;
  ArticleFirebase mForumFire = ArticleFirebase();

  @override
  initState(){
    super.initState();
    print(widget.article.id);
    print(widget.likes);
    var idUser = widget.article.id;
    List<String> likes  = widget.likes;
    isFavorite = likes.contains(idUser);
    _countLike = widget.article.likes;
  }

  void toggleFavorite() async {

    if (isFavorite) {
      setState(() {
        _countLike -=1;
        isFavorite = !isFavorite;
      });
      await mForum.remove(widget.article.id);
      await mForumFire.setLikeArticle(_countLike, widget.article.id, widget.login);
    } else {
      setState(() {
        _countLike +=1;
        isFavorite = !isFavorite;
      });
      await mForum.add(widget.article.id);
      await mForumFire.setLikeArticle(_countLike , widget.article.id, widget.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(
                      color: Colors.black26.withOpacity(0.05),
                      offset: Offset(0.0,6.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.10
                  )]
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
                                        widget.article.login,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: .4
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      widget.article.date,
                                      style: const TextStyle(
                                          color: Colors.grey
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        widget.article.title,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.article.desc,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 17,
                          letterSpacing: .2
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: toggleFavorite,
                                icon: const Icon(Icons.favorite),
                                color: isFavorite
                                    ? Colors.red
                                    : Colors.grey.withOpacity(0.5),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                "${_countLike} votes",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 15.0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}