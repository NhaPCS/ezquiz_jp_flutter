import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:ezquiz_flutter/screens/home.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'dart:async';
import 'dart:io' show Platform;

void main() => runApp(MaterialApp(
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
    return SplashScreen(
      seconds: 5,
      title: Text("EzQuiz\nAlways with you"),
      image: Image.network(
          "https://images.pexels.com/photos/918441/pexels-photo-918441.jpeg"),
      backgroundColor: Colors.white,
      photoSize: 60,
      navigateAfterSeconds: HomeScreen(_listCategories),
      styleTextUnderTheLoader: null,
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
        Category category = new Category(id, value);
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
          print("add final ${_listCategories.length}");
          _listCategories.add(category);
        });
      }
    });
  }
}

void getLevelTest(String level) {
  FirebaseDatabase.instance
      .reference()
      .child("test")
      .orderByChild("level")
      .equalTo(level)
      .onChildAdded
      .listen((Event event) {});
}
