import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/forumdatabase.dart';

class AddArticle extends StatefulWidget {
  final Article article;
  final bool isEdit;
  final String login;
  const AddArticle({Key? key, required this.article, required this.isEdit, required this.login}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  String _desc = "";
  bool _isEdit = false;
  ArticleFirebase mArticleFire = ArticleFirebase();
  TextEditingController _controller = new TextEditingController();
  bool anonymityEnabled = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.isEdit;
    _desc = widget.article.desc;
    _controller.text = widget.article.title;
  }

  _changeDesc(String text){
    setState(() {
      _desc = text;
    });
  }


  _addArticle() async{
    var id = DateTime.now().toString();
    Article article = Article( id: id, title: _controller.text, desc: _desc, date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(), login: widget.login, likes: 0);
    await mArticleFire.setDataArticleList(widget.login, article, id);
    await mArticleFire.setDataArticleLogin(widget.login, article, id);
  }
  _updateArticle() async{
    await mArticleFire.updateArticle(_controller.text, _desc, widget.article.id, widget.login);
  }
  _deleteArticle() async{
    await mArticleFire.deleteArticle(widget.article.id, widget.login);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
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

        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              if(!_isEdit)
              Column(
                children: [
                  Text("Если вы не знаете о чём писать, вы можете задать себе вопрос"),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Random random = Random();
                          int index = random.nextInt(_randomQuestion.length);
                          String randomQuestion = _randomQuestion[index];
                          print(randomQuestion);
                          setState(() {
                            _controller.text = randomQuestion;
                          });
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
                          'Вопрос дня',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextField(
                controller: _controller,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  hintText: "Заголовок",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
                TextFormField(
                  minLines: 1,
                  maxLines: 100,
                  initialValue: _desc,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
            ],
          ),
        ),
      ),
    );
  }

  final List<String> _randomQuestion = [
    "Скучаете по прошлому?",
    "Где и кем ты себя видишь через 5 лет?",
    "Что помогает тебе справиться с ленью?",
    "Есть ли у тебя вредные привычки? Боришься ли ты с ними?",
    "Как выглядит отпуск твоей мечты?",
    "Что мечтаешь донести этому миру?",
    "Любимый фильм/книга, которые помогают тебе справиться с плохим настроением"
    "Что хочешь поменять в себе?",
    "Кошкодевочки или кошкомальчики?",
  ];

}