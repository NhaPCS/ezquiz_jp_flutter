import 'package:firebase_database/firebase_database.dart';
import 'package:ezquiz_flutter/data/database.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/model/coin.dart';

Future<List<TestModel>> getListTest(Category category) async {
  DataSnapshot dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child("test")
      .orderByChild("cate_id")
      .equalTo(category.id)
      .once();
  List<TestModel> list = List();
  for (var value in dataSnapshot.value.values) {
    list.add(new TestModel.fromJson(value));
  }
  return list;
}

Future<bool> getListLevels() async {
  DataSnapshot dataSnapshot =
      await FirebaseDatabase.instance.reference().child("levels").once();
  Map<dynamic, dynamic> values = dataSnapshot.value;
  values.forEach((id, value) {
    print("level $value");
    Map<dynamic, dynamic> cate = value;
    cate.forEach((cateId, cateValue) {
      Category category =
          new Category(title: cateValue, id: cateId, levelId: id);
      DBProvider.db.insert(category);
    });
  });
  return true;
}

void changeLevel(BuildContext context, String level) async {
  List<Category> categories = await DBProvider.db.getCategoriesByLevel(level);
  int _totalSize = categories.length;
  int _index = 0;
  categories.forEach((Category category) async {
    List<TestModel> listTest = await getListTest(category);
    print(
        "CATEGORY_INFO ${category.title} list: ${listTest == null ? 0 : listTest.length}");
    category.lisTest = listTest;
    print("print here ${category.lisTest}");
    _index++;
    if (_index == _totalSize) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(categories)));
      print("print here push new screen");
    }
  });
}

Future<List<Category>> changeLevelFuture(
    BuildContext context, String level) async {
  List<Category> categories = await DBProvider.db.getCategoriesByLevel(level);
  int _totalSize = categories.length;
  int _index = 0;
  categories.forEach((Category category) async {
    List<TestModel> listTest = await getListTest(category);
    print(
        "CATEGORY_INFO ${category.title} list: ${listTest == null ? 0 : listTest.length}");
    category.lisTest = listTest;
    print("print here ${category.lisTest}");
    _index++;
    if (_index == _totalSize) {
      return categories;
    }
  });
}

Future<bool> getListCoins() async {
  DataSnapshot dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child("payment_settings")
      .once();
  Map<dynamic, dynamic> values = dataSnapshot.value;
  values.forEach((id, value) {
    print("payment $value");
    Map<dynamic, dynamic> cate = value;
    cate.forEach((payId, payValue) {
      Coin coin = Coin.fromMap(payValue);
      DBProvider.db.insertCoin(coin);
    });
  });
  return true;
}
