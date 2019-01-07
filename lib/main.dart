import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:ezquiz_flutter/screens/home.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:async';
import 'dart:io' show Platform;

void main() => runApp(MaterialApp(
  home: MyApp(),
  theme: ThemeData(
      fontFamily: 'base',
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
  String _level;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 1,
      title: Text("EzQuiz\nAlways with you"),
      image: Image.network(
          "https://images.pexels.com/photos/918441/pexels-photo-918441.jpeg"),
      backgroundColor: Colors.white,
      photoSize: 60,
      navigateAfterSeconds: HomeScreen(),
      styleTextUnderTheLoader: null,
    );
  }
}

void getLevelTest(String level) {
  FirebaseDatabase.instance
      .reference()
      .child("test")
      .orderByChild("level")
      .equalTo(level)
      .onChildAdded
      .listen((Event event) {

  });
}
