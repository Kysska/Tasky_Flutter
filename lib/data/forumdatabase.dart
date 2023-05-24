import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Article{
  late final String id;
  late final String login;
  late final String title;
  late final String desc;
  late final String date;
  late final int likes;
  late final bool anonim;

  Article({required this.id, required this.login, required this.title, required this.desc, required this.date, required this.likes, required this.anonim
  });

  factory Article.fromMap(Map<String, dynamic> json) => Article(
    id: json['id'],
    login: json['login'],
    title: json['title'],
    desc: json['desc'],
    date: json['date'],
    likes: json['likes'],
    anonim: json['anonim'],
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'login': login,
      'title': title,
      'desc': desc,
      'date': date,
      'likes': likes,
      'anonim': anonim,
    };
  }
}
class DatabaseHelperForum{
  DatabaseHelperForum._privateConstructor();
  static final DatabaseHelperForum instance = DatabaseHelperForum._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'forum.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE forum(
    id TEXT
    )
    ''');
  }


  Future<List<String>> getNotes() async {
    Database db = await instance.database;
    var articles = await db.query('forum');
    List<String> articleList = articles.isNotEmpty
        ? articles.map((e) => e['id']).toList().cast<String>()
        : [];
    return articleList;
  }

  Future<int> add(String id) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {'id': id};
    return await db.insert('forum', row);
  }

  Future<int> remove(String id) async{
    Database db = await instance.database;
    return await db.delete('forum', where: 'id = ?', whereArgs: [id]);
  }

}

class ArticleFirebase{
  final firestore = FirebaseFirestore.instance;


  Future<List<Article>> getArticleList(String login)async {
    var articleSnapshot = await firestore.collection('articles').get();
    if (articleSnapshot.docs.isEmpty) {
      return [];
    }
    List<Article> articleList = articleSnapshot.docs.map((doc) {
      Article article = Article.fromMap(doc.data());
      return article;
    }).toList();
    return articleList;
  }

  Future<List<Article>> getArticleListUser(String login)async {
    var articleSnapshot = await firestore.collection('user').doc(login).collection('articles').get();
    if (articleSnapshot.docs.isEmpty) {
      return [];
    }
    List<Article> articleList = articleSnapshot.docs.map((doc) {
      Article article = Article.fromMap(doc.data());
      return article;
    }).toList();
    return articleList;
  }

  Future<void> setDataArticleList(String login, Article article, String Id) async{
    await firestore.collection('articles').doc(Id)
        .set({'id': Id, 'title': article.title, 'desc': article.desc, 'date': article.date, 'likes': article.likes, 'login': login, 'anonim': article.anonim});
  }

  Future<void> setDataArticleLogin(String login, Article article, String Id) async{
    await firestore.collection('user').doc(login).collection('articles').doc(Id)
        .set({'id': Id, 'title': article.title, 'desc': article.desc, 'date': article.date, 'likes': article.likes, 'login': login, 'anonim': article.anonim});
  }

  Future<void> updateArticle(String title, String desc, String id, String login) async{
    await firestore.collection('articles').doc(id)
        .update({ 'title': title, 'desc': desc, });
    await firestore.collection('user').doc(login).collection('articles').doc(id)
        .update({'title': title, 'desc': desc,});
  }

  Future<void> deleteArticle(String articleId, String login) async {
    await firestore.collection('user').doc(login).collection('articles').doc(articleId).delete();
    await firestore.collection('articles').doc(articleId)
        .delete();
  }

  Future<void> setLikeArticle(int newLike, String articleId, String login)async {
    await firestore.collection('articles').doc(articleId)
        .update({'likes': newLike});
  }

  Future<int> getLikesUser(String articleId) async {
    DocumentSnapshot articleSnapshot = await FirebaseFirestore.instance.collection('articles').doc(articleId).get();
    Map<String, dynamic> articleData = articleSnapshot.data() as Map<String, dynamic>;
    int likes = articleData['likes'] ?? 0;
    return likes;
  }
}
