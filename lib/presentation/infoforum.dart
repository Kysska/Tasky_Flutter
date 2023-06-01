import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/forumdatabase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'addarticle.dart';


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

  String formatDate(String dateString) {
    DateTime date = DateFormat('yyyy-MM-dd – HH:mm').parse(dateString);

    String formattedTime = DateFormat('HH:mm').format(date);
    String formattedDate = DateFormat('dd MMMM yyyy').format(date);

    return '$formattedTime, $formattedDate';
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
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'images/default_avatar.png'),
                                radius: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        widget.article.anonim ?
                                        Text(
                                          "Анонимная Капибара",
                                          style: GoogleFonts.comfortaa(
                                            color: Color(0xff7e7c7c),
                                            fontSize: 18,
                                          ),
                                        )
                                            : Text(
                                          widget.article.login,
                                          style: GoogleFonts.comfortaa(
                                            color: Color(0xff7e7c7c),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2.0),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.65,
                                      child: Text(
                                        "${widget.article.title.length >= 25 ? widget.article.title.substring(0, 25) + '..' : widget.article.title}",
                                        style: GoogleFonts.comfortaa(
                                          color: Color(0xff111111),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 120,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${widget.article.desc.length >= 281 ? widget.article.desc.substring(0, 281) + '..' : widget.article.desc}",
                            style: TextStyle(
                              color: Color(0xff111111),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: toggleFavorite,
                              icon: const Icon(Icons.favorite, size: 22,),
                              color: isFavorite
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.5),

                            ),
                            SizedBox(width: 4.0),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "${_countLike} like",
                                style: GoogleFonts.comfortaa(
                                  fontSize: 14,
                                  color: Color(0xff7e7c7c),
                                ),
                              ),
                            ),
                            SizedBox(width: 120.0),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formatDate(widget.article.date),
                                style: GoogleFonts.comfortaa(
                                  color: Color(0xff7e7c7c),
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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