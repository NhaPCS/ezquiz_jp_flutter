import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/data/shared_value.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io';
import 'package:ezquiz_flutter/screens/screen.dart';

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    getListCoins();
    getLevels();
    getAPIUrl();
    getUserProfile();
    super.initState();
    FirebaseAdMob.instance.initialize(
        appId: Platform.isIOS
            ? Constant.ADS_APP_ID_IOS
            : Constant.ADS_APP_ID_ANDROID);
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      print("TOKENNNN $token");
      assert(token != null);
      ShareValueProvider.shareValueProvider.saveDeviceToken(token);
    });
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
