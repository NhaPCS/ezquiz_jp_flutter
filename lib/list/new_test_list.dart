import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ezquiz_flutter/screens/login.dart';
import 'package:ezquiz_flutter/screens/testing.dart';
import 'package:intl/intl.dart';

class ListTest extends StatefulWidget {
  final Category category;

  const ListTest({Key key, this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListTestState();
  }
}

class _ListTestState extends State<StatefulWidget> {
  List<TestModel> _listTest = List();

  @override
  void initState() {
    print("print here");
    if (_listTest.isEmpty) getListTest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: Size.tinyPadding,
      itemCount: _listTest.length,
      itemBuilder: (BuildContext context, int index) {
        return getTestWidget(_listTest[index]);
      },
    );
  }

  void getListTest() {
//    FirebaseDatabase.instance
//        .reference()
//        .child("test")
//        .orderByChild("n5")
//        .onValue
//        .listen((Event event) {
//      setState(() {
//        _listTest.clear();
//        Map<dynamic, dynamic> schedules = event.snapshot.value;
//        schedules.forEach((key, values) {
////          TestModel testModel = values[key];
////          testModel.id = key;
////          _listTest.add(testModel);
//          print("Data $key , value: ${values.toString()}");
//        });
//      });
//    }, onError: (Object o) {
//      print(o.toString());
//    });

    FirebaseDatabase.instance
        .reference()
        .child("test")
        .orderByChild("n5")
        .once()
        .then((DataSnapshot dataSnapshot) {
      List<TestModel> list = List();

      for (var value in dataSnapshot.value.values) {
        list.add(new TestModel.fromJson(value));
      }
      setState(() {
        _listTest.clear();
        _listTest = list;
      });
    });
  }

  Widget getTestWidget(TestModel test) {
    return GestureDetector(
      child: Card(
        margin: Size.tinyPadding,
        elevation: Size.elevationDefault,
        child: Container(
          padding: Size.defaultPaddig,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    DateFormat("dd/MM/yyyy").format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            test.creationTime * 1000)),
                    style: TextStyle(
                        fontSize: Size.textSizeSmall,
                        color: ColorUtil.textGray),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  WidgetUtil.getCircleImageWithMargin(
                      Size.avatarSizeSmall,
                      "https://images.pexels.com/photos/9291/nature-bird-flying-red.jpg",
                      0),
                  Container(
                    width: Size.textSizeDefault,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(test.testName != null ? test.testName : "",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )),
                        Row(
                          children: <Widget>[],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if (FirebaseAuth.instance.currentUser() == null)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TestingScreen(test)));
        }
      },
    );
  }
}
