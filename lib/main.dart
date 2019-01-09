import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/screens/home.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ezquiz_flutter/model/database.dart';

void main() =>
    runApp(MaterialApp(
      home: MyApp(),
      theme: ThemeData(
          fontFamily: 'base',
          textTheme: TextTheme(
              body1: TextStyle(fontSize: SizeUtil.textSizeDefault),
              body2: TextStyle(fontSize: SizeUtil.textSizeDefault),
              display1: TextStyle(fontSize: SizeUtil.textSizeDefault),
              display2: TextStyle(fontSize: SizeUtil.textSizeDefault),
              display3: TextStyle(fontSize: SizeUtil.textSizeDefault),
              button: TextStyle(fontSize: SizeUtil.textSizeDefault),
              display4: TextStyle(fontSize: SizeUtil.textSizeDefault),
              caption: TextStyle(fontSize: SizeUtil.textSizeDefault),
              title: TextStyle(fontSize: SizeUtil.textSizeDefault)),
          primaryColor: ColorUtil.primaryColor,
          primaryColorDark: ColorUtil.primaryColorDark,
          backgroundColor: ColorUtil.background,
          scaffoldBackgroundColor: ColorUtil.background,
          dialogBackgroundColor: Colors.white),
    ));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Category> _listCategories = List();
  int _categorySize = 0;

  @override
  void initState() {
    getListCategories();
    super.initState();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("icons/logo.png"),
          Container(
            height: SizeUtil.spaceBig,
          ),
          Text(
            "${StringUtil.appName} \nAlways with you",
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorUtil.primaryColor),
          )
        ],
      ),
    );
  }

  void getListCategories() {
    _listCategories.clear();
    _categorySize = 0;
    FirebaseDatabase.instance
        .reference()
        .child("levels")
        .child("n5")
        .once()
        .then((DataSnapshot dataSnapshot) {
      List<Category> list = List();
      Map<dynamic, dynamic> values = dataSnapshot.value;
      _categorySize = values.length;
      values.forEach((id, value) {
        Category category = new Category(id: id, title: value);
        getListTest(category);
        list.add(category);
        print("id $id value $value");
      });
    });
  }

  void getListTest(Category category) {
    FirebaseDatabase.instance
        .reference()
        .child("test")
        .orderByChild("cate_id")
        .equalTo(category.id)
        .once()
        .then((DataSnapshot dataSnapshot) {
      List<TestModel> list = List();
      for (var value in dataSnapshot.value.values) {
        list.add(new TestModel.fromJson(value));
        print("test $value");
      }
      category.lisTest = list;
      _listCategories.add(category);
      if (_listCategories.length == _categorySize) {
        setState(() {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen(_listCategories)));
        });
      }
    });
  }
}


void getLevels() {
  FirebaseDatabase.instance
      .reference()
      .child("levels").once().then((DataSnapshot dataSnapshot) {
    Map<dynamic, dynamic> values = dataSnapshot.value;
    values.forEach((id, value) {
      Map<dynamic, dynamic> cate = value[id];
      cate.forEach((cateId, cateValue) {
        Category category = new Category(
            title: cateValue, id: cateId, levelId: id);
        DBProvider.db.insert(category);
      });
    });
  });
}
