import 'package:cloud_firestore/cloud_firestore.dart';

class Article{
  late final String id;
  late final String login;
  late final String title;
  late final String desc;
  late final String date;
  late final String likes;

  Article({required this.id, required this.login, required this.title, required this.desc, required this.date, required this.likes
  });

  factory Article.fromMap(Map<String, dynamic> json) => Article(
    id: json['id'],
    login: json['login'],
    title: json['title'],
    desc: json['desc'],
    date: json['date'],
    likes: json['likes']
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'login': login,
      'title': title,
      'desc': desc,
      'date': date,
      'likes': likes,
    };
  }
}

class NoteFirebase{
  final firestore = FirebaseFirestore.instance;


  Future<List<Article>> getArticleList(String login)async {
    var articleSnapshot = await firestore.collection('articles').orderBy('likes').get();
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
    var articleSnapshot = await firestore.collection('login').doc(login).collection('articles').get();
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
        .set({'id': Id, 'title': article.title, 'desc': article.desc, 'date': article.date, 'likes': article.likes, 'login': login});
  }

  Future<void> setDataArticleLogin(String login, Article article, String Id) async{
    await firestore.collection('login').doc(login).collection('articles').doc(Id)
        .set({'id': Id, 'title': article.title, 'desc': article.desc, 'date': article.date, 'likes': article.likes, 'login': login});
  }

  Future<void> updateArticle(Article article) async{
    await firestore.collection('articles').doc(article.id)
        .update({'id': article.id, 'title': article.title, 'desc': article.desc, 'date': article.date, 'likes': article.likes, });
  }

  Future<void> deleteArticle(String articleId) async {
    await firestore.collection('articles').doc(articleId)
        .delete();
  }

  Future<void> setLikeArticle(int newLike, String articleId )async {
    await firestore.collection('articles').doc(articleId)
        .update({'likes': newLike});
  }
}
