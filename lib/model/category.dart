import 'package:ezquiz_flutter/model/test.dart';

final String tableCategory = 'category';
final String _id = 'id';
final String _title = 'title';
final String _levelId = 'levelId';

class Category {
  String title;
  String id;
  String levelId;

  List<TestModel> lisTest;

  Category({this.id, this.title, this.levelId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{_id: id, _title: title, _levelId: levelId};
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    id = map[_id];
    title = map[_title];
    levelId = map[_levelId];
  }
}

class CategoryProvider {


}
