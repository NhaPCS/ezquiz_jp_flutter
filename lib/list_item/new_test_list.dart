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
    return _ListTestState(category.lisTest);
  }
}

class _ListTestState extends State<ListTest>
    with AutomaticKeepAliveClientMixin<ListTest> {
  List<TestModel> _listTest = List();

  _ListTestState(this._listTest);

  @override
  void initState() {
    print("print here");
    //  if (_listTest.isEmpty) getListTest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      padding: SizeUtil.tinyPadding,
      itemCount: _listTest.length,
      itemBuilder: (BuildContext context, int index) {
        return getTestWidget(_listTest[index]);
      },
    );
  }

  Widget getTestWidget(TestModel test) {
    return GestureDetector(
      child: Card(
        margin: SizeUtil.tinyPadding,
        elevation: SizeUtil.elevationDefault,
        child: Container(
          padding: SizeUtil.defaultPaddig,
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
                        fontSize: SizeUtil.textSizeSmall,
                        color: ColorUtil.textGray),
                  ),
                ],
              ),
              Container(
                height: SizeUtil.spaceDefault,
              ),
              Row(
                children: <Widget>[
                  WidgetUtil.getCircleImageWithMargin(
                      SizeUtil.avatarSizeSmall,
                      "https://images.pexels.com/photos/9291/nature-bird-flying-red.jpg",
                      0),
                  Container(
                    width: SizeUtil.textSizeDefault,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(test.testName != null ? test.testName : "",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold)),
                        Container(
                          height: SizeUtil.spaceDefault,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.file_download,
                              size: SizeUtil.iconSizeTiny,
                            ),
                            Text(
                              "${test.testBuyCount == null ? 0 : test.testBuyCount}",
                              style:
                                  TextStyle(fontSize: SizeUtil.textSizeSmall),
                            ),
                            Container(
                              width: SizeUtil.spaceDefault,
                            ),
                            Icon(
                              Icons.library_books,
                              size: SizeUtil.iconSizeTiny,
                            ),
                            Text(
                              "${test.testDoneCount == null ? 0 : test.testDoneCount}",
                              style:
                                  TextStyle(fontSize: SizeUtil.textSizeSmall),
                            ),
                            Container(
                              width: SizeUtil.spaceDefault,
                            ),
                            Icon(
                              Icons.attach_money,
                              size: SizeUtil.iconSizeTiny,
                              color: Colors.orange,
                            ),
                            Text(
                              "${(test.coin == 0 || test.coin == null) ? "Free" : test.coin}",
                              style: TextStyle(
                                  fontSize: SizeUtil.textSizeSmall,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                height: SizeUtil.spaceBig,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  test.testName,
                  style: TextStyle(color: ColorUtil.textGray),
                ),
              ),
              Container(
                height: SizeUtil.spaceBig,
              ),
              Container(
                height: SizeUtil.lineSize,
                color: ColorUtil.background,
              ),
              Padding(
                padding: EdgeInsets.only(top: SizeUtil.spaceDefault),
                child: Row(
                  children: <Widget>[
                    Text(
                      "${test.rateCount == null ? 0 : test.rateCount} rates  ${test.comment == null ? 0 : test.comment} comments",
                      style: TextStyle(
                          color: ColorUtil.textGray,
                          fontSize: SizeUtil.textSizeSmall),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.cloud_download,
                        color: ColorUtil.textGray,
                      ),
                      onTap: () {},
                    ),
                    Container(
                      width: SizeUtil.spaceBig,
                    ),
                    GestureDetector(
                      child: Icon(Icons.comment, color: ColorUtil.textGray),
                      onTap: () {},
                    )
                  ],
                ),
              )
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

  @override
  bool get wantKeepAlive => true;
}
