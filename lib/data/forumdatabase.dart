class Article{
  late final String id;
  late final String login;
  late final String title;
  late final String desc;
  late final String date;
  late final bool isImportant;

  Article({required this.id, required this.login, required this.title, required this.desc, required this.date, required this.isImportant
  });

  factory Article.fromMap(Map<String, dynamic> json) => Article(
    id: json['id'],
    login: json['login'],
    title: json['title'],
    desc: json['desc'],
    date: json['date'],
    isImportant: _boolFromJson(json['isImportant']),
  );

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'login': login,
      'title': title,
      'desc': desc,
      'date': date,
      'isImportant': _boolToJson(isImportant)
    };
  }

  static int _boolToJson(bool value) {
    if (value == true) {
      return 1;
    } else {
      return 0;
    }
  }

  static bool _boolFromJson(int value) {
    if (value == 1) {
      return true;
    } else {
      return false;
    }
  }
}