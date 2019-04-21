import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io' show Platform;

import 'package:ezquiz_flutter/data/database.dart';
import 'package:ezquiz_flutter/data/response.dart';
import 'package:ezquiz_flutter/data/shared_value.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/model/coin.dart';
import 'package:ezquiz_flutter/model/device_token.dart';
import 'package:ezquiz_flutter/model/question.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/model/test_result.dart';
import 'package:ezquiz_flutter/model/user.dart';
import 'package:ezquiz_flutter/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ezquiz_flutter/utils/resources.dart';

Future<List<TestModel>> getListTest(Category category) async {
  DataSnapshot dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child("test")
      .orderByChild("cate_id")
      .equalTo(category.id)
      .once();
  List<TestModel> list = List();
  for (var value in dataSnapshot.value.values) {
    TestModel testModel = TestModel.fromJson(value);
    list.add(testModel);
    if (testModel != null) {
      DBProvider.db.insertTest(testModel);
    }
  }
  return await DBProvider.db.getTestByCate(category.id);
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
      DBProvider.db.insertCategory(category);
    });
  });
  return true;
}

void changeLevel(BuildContext context, String level) async {
  List<Category> categories = await DBProvider.db.getCategoriesByLevel(level);
  int _totalSize = categories.length;
  int _index = 0;
  categories.forEach((Category category) async {
    await getListTest(category);
    _index++;
    if (_index == _totalSize) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          settings: RouteSettings(name: "home"),
          builder: (context) => HomeScreen(categories)));
      print("print here push new screen");
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
    Coin coin = Coin.fromMap(value);
    DBProvider.db.insertCoin(coin);
  });
  return true;
}

Future<bool> isBought(String testId) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if (user == null) return false;
  DataSnapshot dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child("buy_history")
      .child(user.uid)
      .child(testId)
      .once();
  return dataSnapshot.value != null;
}

Future<int> getCoinReward() async {
  DataSnapshot dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child("system_settings")
      .child("coin_bonus")
      .once();
  return dataSnapshot.value;
}

Future<void> incrementCoins(int coin) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if (user == null) return;
  await FirebaseDatabase.instance
      .reference()
      .child("user")
      .child(user.uid)
      .child("coin")
      .runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + coin;
    return mutableData;
  });
}

typedef CoinCallBack = void Function(int coin);

void getCurrentCoins(CoinCallBack callBack) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if (user == null) return;
  FirebaseDatabase.instance
      .reference()
      .child("user")
      .child(user.uid)
      .child("coin")
      .onValue
      .listen((Event event) {
    callBack(event.snapshot.value);
  });
}

Future getAPIUrl() async {
  DataSnapshot dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child("system_settings")
      .child("api_url")
      .once();
  print("api: ${dataSnapshot.value}");
  ShareValueProvider.shareValueProvider.saveApiUrl(dataSnapshot.value);
}

Future<bool> sigIn(String email, String pass) async {
  FirebaseUser user = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: pass);
  return user != null;
}

Future<bool> createUser(BuildContext context, String email, String pass) async {
  try {
    FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);
    return user != null;
  } on Exception catch(e){
    WidgetUtil.showErrorDialog(context, e.toString());
    return null;
  }
}

Future<User> getUserProfile() async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser != null) {
    await saveUserIfNeed(
        firebaseUser.uid, firebaseUser.email, firebaseUser.displayName);
    DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("user")
        .child(firebaseUser.uid)
        .once();
    if (dataSnapshot.value != null && dataSnapshot.value["id"] != null) {
      print("Value user ${dataSnapshot.value}");
      User user = User.fromMap(dataSnapshot.value);
      ShareValueProvider.shareValueProvider.saveUserProfile(user);
      return user;
    } else {
      ShareValueProvider.shareValueProvider.saveUserProfile(null);
      return null;
    }
  }
}

Future<BaseResponse> buyTest(BuildContext context, TestModel test) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if (user == null)
    return BaseResponse(
        status: BaseResponse.ERROR_AUTH,
        message: "You must login to buy this test.");
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  var baseUrl = await ShareValueProvider.shareValueProvider.getAPIUrl();
  print(baseUrl);
  // Await the http get response, then decode the json-formatted responce.
  var response = await http.post("${baseUrl}buyTest", body: {
    "test_id": test.id,
    "user_id": user.uid,
    "test_coin": "${test.coin}"
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    BaseResponse baseResponse = BaseResponse.fromJson(jsonResponse);
    return baseResponse;
  } else {
    print("Request failed with status: ${response.statusCode}.");
    return BaseResponse(
        status: BaseResponse.ERROR_OTHER, message: "Error. Please try again!");
  }
}

Future<TestResult> getTestResult(
    TestModel test, List<Question> listQuestion, int testTime) async {
  if (listQuestion == null || listQuestion.isEmpty) {
    return null;
  }
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser == null) return null;
  int correct = 0;
  int total = 0;
  for (Question question in listQuestion) {
    total++;
    if (question.isCorrect()) {
      correct++;
    }
  }
  double point = correct * (10.0 / total);
  point = num.parse(point.toStringAsFixed(2));
  TestResult testResult = TestResult(
      user_id: firebaseUser.uid,
      test_id: test.id,
      test_name: test.testName,
      total_point: point,
      correct_count: correct,
      wrong_count: (total - correct),
      test_duration: testTime,
      test_time: DateTime.now().millisecondsSinceEpoch);
  String key =
      FirebaseDatabase.instance.reference().child("test_result").push().key;
  FirebaseDatabase.instance
      .reference()
      .child("test_result")
      .child(key)
      .set(testResult.toMap());
  increaseTestDoneCount(test.id);
  return testResult;
}

void increaseTestDoneCount(String testId) async {
  FirebaseDatabase.instance
      .reference()
      .child("test")
      .child(testId)
      .child("test_done_count")
      .runTransaction((MutableData mutableData) async {
    mutableData.value = (mutableData.value ?? 0) + 1;
    return mutableData;
  });
}

Future<ResultStatisticResponse> getTestStatistic(
    String testID, int correctCount) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser == null) return null;
  var baseUrl = await ShareValueProvider.shareValueProvider.getAPIUrl();
  print(baseUrl);
  // Await the http get response, then decode the json-formatted responce.
  var response = await http.post("${baseUrl}testResult", body: {
    "test_id": testID,
    "user_id": firebaseUser.uid,
    "correct_count": correctCount.toString()
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    print("STATISTIC $jsonResponse");
    ResultStatisticResponse statisticResponse =
        ResultStatisticResponse.fromJson(jsonResponse);
    return statisticResponse;
  } else {
    print("Request failed with status: ${response.statusCode}.");
    return null;
  }
}

Future<List<TestResult>> getTestHistory() async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser == null) return null;
  List<TestResult> list = List();
  DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child("test_result")
      .orderByChild("user_id")
      .equalTo(firebaseUser.uid)
      .once();
  Map<dynamic, dynamic> values = snapshot.value;
  values.forEach((id, value) {
    print("payment $value");
    TestResult testResult = TestResult.fromMap(value);
    list.add(testResult);
  });
  return list;
}

Future<TestModel> getTestModel(String testId) async {
  DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child("test")
      .child(testId)
      .once();
  return TestModel.fromMap(snapshot.value);
}

Future<User> saveUserIfNeed(String uid, String email, String name) async {
  DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child("user")
      .child(uid)
      .once();
  String messagingToken =
      await ShareValueProvider.shareValueProvider.getDeviceToken();
  String platform = Platform.isIOS ? "ios" : "android";
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  DeviceToken deviceToken = DeviceToken(platform, packageInfo.version);
  print("AAAA $deviceToken");
  if (snapshot == null || snapshot.value == null) {
    User user = User(
        id: uid,
        email: email,
        display_name: name,
        level_id: "n5",
        coin: 0,
        deviceID: {
          messagingToken: deviceToken,
        });

    FirebaseDatabase.instance
        .reference()
        .child("user")
        .child(uid)
        .set(user.toMap());
    FirebaseDatabase.instance
        .reference()
        .child("user")
        .child(uid)
        .child("deviceID")
        .child(messagingToken)
        .set(deviceToken.toMap());
    ShareValueProvider.shareValueProvider.saveUserProfile(user);
    return user;
  } else {
    FirebaseDatabase.instance
        .reference()
        .child("user")
        .child(uid)
        .child("deviceID")
        .child(messagingToken)
        .set(deviceToken.toMap());
    User user = User.fromMap(snapshot.value);
    ShareValueProvider.shareValueProvider.saveUserProfile(user);
    return user;
  }
}
