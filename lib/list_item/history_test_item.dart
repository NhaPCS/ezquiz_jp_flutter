import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/model/test_result.dart';
import 'package:intl/intl.dart';
import 'package:ezquiz_flutter/screens/testing.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/model/test.dart';

class HistoryItem extends StatefulWidget {
  final TestResult testResult;

  const HistoryItem({Key key, this.testResult}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HistoryItem(testResult);
  }
}

class _HistoryItem extends State<HistoryItem> {
  final TestResult _testResult;

  _HistoryItem(this._testResult);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: SizeUtil.spaceBig),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: SizeUtil.lineSize,
                  height: SizeUtil.spaceBig,
                  color: ColorUtil.primaryColor,
                ),
                Icon(
                  Icons.access_time,
                  color: ColorUtil.primaryColor,
                ),
                Container(
                  width: SizeUtil.lineSize,
                  height: SizeUtil.spaceBig,
                  color: ColorUtil.primaryColor,
                ),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: ColorUtil.primaryColor, shape: BoxShape.circle),
                ),
                Text(
                  _testResult.total_point == null
                      ? ""
                      : "${_testResult.total_point}",
                  style: TextStyle(
                      fontFamily: "trattello",
                      color: _testResult.getColor(),
                      fontSize: SizeUtil.textSizeBig),
                ),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: ColorUtil.primaryColor, shape: BoxShape.circle),
                ),
                Container(
                  width: SizeUtil.lineSize,
                  height: 53,
                  color: ColorUtil.primaryColor,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                  left: SizeUtil.spaceBig,
                  right: SizeUtil.spaceBig,
                  top: SizeUtil.spaceBig),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: SizeUtil.spaceSmall,
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            _testResult.test_time * 1000)),
                    style: TextStyle(
                        color: ColorUtil.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: SizeUtil.spaceDefault,
                  ),
                  Text(
                    "${DateFormat("HH:mm").format(DateTime.fromMicrosecondsSinceEpoch(_testResult.test_time * 1000))} - ${_testResult.test_name}",
                    style: TextStyle(
                        color: ColorUtil.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: SizeUtil.spaceDefault,
                  ),
                  Text(
                    "You have finished this test during ${_getDurationMinute()} minutes",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: ColorUtil.textGray,
                    ),
                  ),
                  Text(
                    "You got ${_testResult.correct_count}/${_testResult.correct_count + _testResult.wrong_count} the correct answer",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: ColorUtil.textGray,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: EdgeInsets.only(top: SizeUtil.spaceBig),
                      height: SizeUtil.lineSize,
                      color: ColorUtil.lineColor,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () {
        _showHistoryDialog();
      },
    );
  }

  void _showHistoryDialog() {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: double.infinity,
            child: Container(
              color: Colors.white,
              padding: SizeUtil.defaultMargin,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${_testResult.test_name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorUtil.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: SizeUtil.spaceBig,
                  ),
                  Text(
                    "${_testResult.total_point}",
                    style: TextStyle(
                        fontFamily: "trattello",
                        fontSize: SizeUtil.textSizeSuperHuge,
                        fontWeight: FontWeight.bold,
                        color: _testResult.getColor()),
                  ),
                  Container(
                    height: SizeUtil.spaceDefault,
                  ),
                  ListTile(
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: ColorUtil.primaryColor,
                          shape: BoxShape.circle),
                    ),
                    title: Text(
                        "You got ${_testResult.correct_count} correct answers."),
                  ),
                  ListTile(
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: ColorUtil.primaryColor,
                          shape: BoxShape.circle),
                    ),
                    title: Text(
                        "You have finished this test during ${_getDurationMinute()} minutes"),
                  ),
                  ListTile(
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: ColorUtil.primaryColor,
                          shape: BoxShape.circle),
                    ),
                    title: Text(
                        "Test time at: ${DateFormat("HH:mm - dd/MM/yyyy").format(DateTime.fromMicrosecondsSinceEpoch(_testResult.test_time * 1000))}"),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            getTestModel(_testResult.test_id)
                                .then((TestModel test) {
                              if (test != null) {
                                test.id = _testResult.test_id;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TestingScreen(test, false)));
                              }
                            });
                          },
                          child: Text(
                            "Do it again",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: ColorUtil.primaryColor,
                        ),
                      ),
                      Container(
                        width: 2,
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            getTestModel(_testResult.test_id)
                                .then((TestModel test) {
                              if (test != null) {
                                test.id = _testResult.test_id;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TestingScreen(test, true)));
                              }
                            });
                          },
                          child: Text(
                            "View answer",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: ColorUtil.primaryColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  int _getDurationMinute() {
    if (_testResult == null || _testResult.test_duration == null) return 0;
    int duration = (_testResult.test_duration / 60).round();
    return duration == 0 ? 1 : duration;
  }
}
