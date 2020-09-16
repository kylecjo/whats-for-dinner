class Category {
  Category(this.alias, this.title);
  final String alias;
  final String title;

  factory Category.fromJson(dynamic json) {
    return Category(json['alias'] as String, json['title'] as String);
  }

  @override
  String toString() {
    return '${this.alias}, ${this.title}';
  }
}
