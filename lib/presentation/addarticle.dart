import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../data/forumdatabase.dart';

class AddArticle extends StatefulWidget {
  final Article article;
  final bool isEdit;
  final String login;

  const AddArticle(
      {Key? key,
      required this.article,
      required this.isEdit,
      required this.login})
      : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  String _desc = "";
  bool _isEdit = false;
  ArticleFirebase mArticleFire = ArticleFirebase();
  TextEditingController _controller = new TextEditingController();
  bool anonymityEnabled = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.isEdit;
    _desc = widget.article.desc;
    _controller.text = widget.article.title;
  }

  _changeDesc(String text) {
    setState(() {
      _desc = text;
    });
  }

  _addArticle() async {
    var id = DateTime.now().toString();
    Article article = Article(
        id: id,
        title: _controller.text,
        desc: _desc,
        date:
            DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(),
        login: widget.login,
        likes: 0,
        anonim: anonymityEnabled);
    await mArticleFire.setDataArticleList(widget.login, article, id);
    await mArticleFire.setDataArticleLogin(widget.login, article, id);
  }

  _updateArticle() async {
    await mArticleFire.updateArticle(
        _controller.text, _desc, widget.article.id, widget.login);
  }

  _deleteArticle() async {
    await mArticleFire.deleteArticle(widget.article.id, widget.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /* actions: [
        TextButton(
          onPressed: () {
          if(_isEdit) _updateArticle();
          else _addArticle();
          Navigator.pop(context, true);
        },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: const Text(
           'Опубликовать',
          style: TextStyle(color: Colors.white),
        ),
      ),
        ],

         CheckboxListTile(
                    title: Text(
                      'Разместить пост анонимно?',
                      style: GoogleFonts.comfortaa(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: anonymityEnabled,
                    onChanged: (newValue) {
                      setState(() {
                        anonymityEnabled = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
         */
      body: Stack(children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                if (!_isEdit)
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 8, top: 8),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                Random random = Random();
                                int index = random.nextInt(_randomQuestion.length);
                                String randomQuestion = _randomQuestion[index];
                                setState(() {
                                  _controller.text = randomQuestion;
                                });
                              },
                              fillColor: const Color(0xFF91D279),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                                child: Text(
                                  "Заголовок дня",
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 70),
                            RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              fillColor: const Color(0xFF3D3D3D),
                              elevation: 0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                                    child: Text(
                                      "Анонимно?",
                                      style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: anonymityEnabled,
                                    onChanged: (newValue) {
                                      setState(() {
                                        anonymityEnabled = newValue!;
                                      });
                                    },
                                    activeColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DecoratedBox(
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
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextField(
                        cursorColor: Colors.black,
                        textAlign: TextAlign.left,
                        controller: _controller,
                        minLines: 1,
                        maxLines: 5,
                        style: GoogleFonts.comfortaa(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Заголовок",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: DecoratedBox(
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
                    child: TextFormField(
                      cursorColor: Colors.black,
                      minLines: 20,
                      maxLines: 100,
                      initialValue: _desc,
                      style: GoogleFonts.comfortaa(
                          fontSize: 16, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Содержание...",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _changeDesc,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      if (_isEdit)
                        _updateArticle();
                      else
                        _addArticle();
                      Navigator.pop(context, true);
                    },
                    backgroundColor: const Color(0xFF93D7FF),
                    elevation: 0,
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 5),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: const Color(0xFF6A7791),
                    elevation: 0,
                    child: Transform.rotate(
                      angle: 45 * 3.1415926535 / 180,
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ]),
    );
  }

  final List<String> _randomQuestion = [
    "Где и кем ты себя видишь через 5 лет?",
    "Что помогает тебе справиться с ленью?",
    "Есть ли у тебя вредные привычки? Боришься ли ты с ними?",
    "Как выглядит отпуск твоей мечты?",
    "Любимый фильм/книга, которые помогают тебе справиться с плохим настроением",
    "Что хочешь поменять в себе?",
    "Кошкодевочки или кошкомальчики?",
    "Почему мы стремимся к совершенству, если оно недостижимо?",
    "Является ли страдание необходимой частью состояния души человека? Какими были бы люди, если бы они никогда не страдали?",
    "Что бы произошло, если бы Римская империя не распалась?",
    "Каким бы был мир, если бы не было Второй мировой войны",
    "Существует ли божественная сущность или высшая сила, определяющая нашу жизнь и мир?",
  ];
}
