import 'package:flutter/material.dart';
import 'package:tasky_flutter/data/forumdatabase.dart';

class Forum extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Forum> {
  final List<Article> questions = [
    Article(id: '', login: 'Jonhy', title: '1234', desc: 'ewgeggrgegergg', date: '2024', likes: '123'),
    // Добавьте остальные вопросы сюда
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: questions.map((question) =>
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => PostScreen(
                //           question: question,
                //         )
                //     )
                // );
              },
              child: Container(
                height: 180,
                margin: EdgeInsets.all(15.0),
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
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const CircleAvatar(
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
                                        width: MediaQuery.of(context).size.width * 0.65,
                                        child: Text(
                                          question.title,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: .4
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.0),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            question.login,
                                            style: TextStyle(
                                                color: Colors.grey.withOpacity(0.6)
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            question.date,
                                            style: TextStyle(
                                                color: Colors.grey.withOpacity(0.6)
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.bookmark,
                              color: Colors.grey.withOpacity(0.6),
                              size: 26,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "${question.desc}..",
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
                                "votes",
                                // "${question.votes} votes",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.withOpacity(0.6),
                                    fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                color: Colors.grey.withOpacity(0.6),
                                size: 16,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                "replies",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.withOpacity(0.6)
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
    );
  }
}