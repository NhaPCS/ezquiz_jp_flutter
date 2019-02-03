import 'package:firebase_database/firebase_database.dart';
import 'package:ezquiz_flutter/data/database.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/model/coin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:ezquiz_flutter/data/response.dart';
import 'package:ezquiz_flutter/data/shared_value.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/screens/payment.dart';
import 'package:ezquiz_flutter/model/user.dart';

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

Future<bool> createUser(String email, String pass) async {
  FirebaseUser user = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: pass);
  return user != null;
}

Future<void> getUserProfile() async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser != null) {
    DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("user")
        .child(firebaseUser.uid)
        .once();
    if (dataSnapshot.value != null && dataSnapshot.value["id"] != null) {
      print("Value user ${dataSnapshot.value}");
      ShareValueProvider.shareValueProvider.saveUserProfile(dataSnapshot.value);
    } else{
      ShareValueProvider.shareValueProvider.saveUserProfile(null);
    }
  }
  return;
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
