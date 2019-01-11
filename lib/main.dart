import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/data/database.dart';
import 'package:ezquiz_flutter/data/shared_value.dart';

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
  @override
  void initState() {
    getLevels();
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

  void getLevels() {
    getListLevels().then((success) async {
      changeLevel(context,
          await ShareValueProvider.shareValueProvider.getCurrentLevel());
    });
  }
}
