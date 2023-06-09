
import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/forumdatabase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


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
  TextEditingController _textEditingController = TextEditingController();
  late int _countLike;
  DatabaseHelperForum mForum = DatabaseHelperForum.instance;
  ArticleFirebase mForumFire = ArticleFirebase();
  CommentFirebase mCommentFire = CommentFirebase();
  Future<List<Comment>>? _questions;
  List<Comment>? _retrievedQuestions;
  final String _avatar = "images/avatar.jpg";

  @override
  initState() {
    super.initState();
    var idUser = widget.article.id;
    List<String> likes = widget.likes;
    isFavorite = likes.contains(idUser);
    _countLike = widget.article.likes;
    _questions = mCommentFire.getCommentList(idUser);
    getListArticle();
  }

  Future getListArticle() async {
    _retrievedQuestions =
        (await mCommentFire.getCommentList(widget.article.id));
  }

  void toggleFavorite() async {
    if (isFavorite) {
      setState(() {
        _countLike -= 1;
        isFavorite = !isFavorite;
      });
      await mForum.remove(widget.article.id);
      await mForumFire.setLikeArticle(
          _countLike, widget.article.id, widget.login);
      await mForumFire.setLikeArticleUser(
          _countLike, widget.article.id, widget.login);
    } else {
      setState(() {
        _countLike += 1;
        isFavorite = !isFavorite;
      });
      await mForum.add(widget.article.id);
      await mForumFire.setLikeArticle(
          _countLike, widget.article.id, widget.login);
      await mForumFire.setLikeArticleUser(
          _countLike, widget.article.id, widget.login);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26.withOpacity(0.05),
                            offset: Offset(0.0, 6.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.10)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                      radius: 16,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.asset(_avatar),
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            widget.article.anonim
                                                ? Text(
                                                    "Анонимная Капибара",
                                                    style:
                                                        GoogleFonts.comfortaa(
                                                      color: Color(0xff7e7c7c),
                                                      fontSize: 18,
                                                    ),
                                                  )
                                                : Text(
                                                    widget.article.login,
                                                    style:
                                                        GoogleFonts.comfortaa(
                                                      color: Color(0xff7e7c7c),
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        const SizedBox(height: 2.0),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.article.title,
                            style: GoogleFonts.comfortaa(
                              color: Color(0xff111111),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 15.0, left: 15, right: 15),
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
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  widget.article.desc,
                                  style: GoogleFonts.comfortaa(
                                    color: Color(0xff111111),
                                    fontSize: 15,
                                  ),
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
                                  icon: const Icon(
                                    Icons.favorite,
                                    size: 22,
                                  ),
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
                                SizedBox(width: 90.0),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formatDate(widget.article.date),
                                    style: GoogleFonts.comfortaa(
                                      color: Color(0xff7e7c7c),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, top: 20.0, bottom: 10.0),
                          child: Text(
                            "Комментарии",
                            // "Replies (${widget.question.replies.length})",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: FutureBuilder(
                              future: _questions,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Ошибка: ${snapshot.error}');
                                } else if (_retrievedQuestions == null) {
                                  return Center(
                                    child: Text(
                                      'Нет комментариев',
                                      style: GoogleFonts.comfortaa(
                                        color: Color(0xFF6A7791),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                                return _retrievedQuestions!.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Нет комментариев',
                                          style: GoogleFonts.comfortaa(
                                            color: Color(0xFF6A7791),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: _retrievedQuestions!
                                            .map((reply) => Container(
                                                margin: EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 20.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black26
                                                            .withOpacity(0.03),
                                                        offset:
                                                            Offset(0.0, 6.0),
                                                        blurRadius: 10.0,
                                                        spreadRadius: 0.10)
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 60,
                                                        color: Colors.white,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          reply
                                                                              .login,
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                              letterSpacing: .4),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2.0),
                                                                      Text(
                                                                        reply
                                                                            .date,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.4)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            (reply.login == widget.login) ?
                                                            PopupMenuButton<String>(
                                                              itemBuilder:
                                                                  (BuildContext context) =>
                                                              <PopupMenuEntry<String>>[
                                                                const PopupMenuItem<String>(
                                                                  value: 'delete',
                                                                  child: Text('Удалить'),
                                                                ),
                                                              ],
                                                              onSelected: (String value) async {
                                                                switch (value) {
                                                                  case 'delete':
                                                                    _retrievedQuestions!.remove(reply);
                                                                    setState(() {});
                                                                    await mCommentFire
                                                                        .deleteArticle(widget.article.id, reply.id, widget.login);
                                                                    break;
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons.more_vert,
                                                                color: Colors.grey
                                                                    .withOpacity(0.6),
                                                              ),
                                                            ):
                                                                SizedBox.shrink(),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 15.0),
                                                        child: Text(
                                                          reply.desc,
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.25),
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )))
                                            .toList(),
                                      );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Напиши свой комментарий...',
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      var id = DateTime.now();
                      String text = _textEditingController.text;
                      _retrievedQuestions?.add(Comment(id: id.toString(),  desc: text, date: DateFormat('yyyy-MM-dd – kk:mm').format(id).toString(), anonim: false, login: widget.login));
                      _textEditingController.clear();
                      setState(() {});
                      mCommentFire.setDataArticleList(Comment(id: id.toString(),  desc: text, date: DateFormat('yyyy-MM-dd – kk:mm').format(id).toString(), anonim: false, login: widget.login), widget.article.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
