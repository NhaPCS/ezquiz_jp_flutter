import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:ezquiz_flutter/model/test_result.dart';
import 'package:ezquiz_flutter/data/response.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/screens/testing.dart';

class TestResultScreen extends StatefulWidget {
  final TestResult testResult;

  const TestResultScreen({Key key, this.testResult})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestResultState(testResult);
  }
}

class _TestResultState extends State<TestResultScreen> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  final TestResult _testResult;
  ResultStatisticResponse _resultStatisticResponse;

  _TestResultState(this._testResult);

  @override
  void initState() {
    getTestStatistic(_testResult.test_id, _testResult.correct_count)
        .then((ResultStatisticResponse response) {
      setState(() {
        _resultStatisticResponse = response;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.primaryColor,
      body: Padding(
        padding: EdgeInsets.only(
            left: SizeUtil.spaceBig * 2, right: SizeUtil.spaceBig),
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                height: SizeUtil.spaceDefault,
              ),
              Text(
                _getTitle(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              Container(
                height: SizeUtil.spaceDefault,
              ),
              Text(
                "${_testResult.total_point} points",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SizeUtil.textSizeHuge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                height: SizeUtil.spaceDefault,
              ),
              Text(
                "${_testResult.correct_count}/${(_testResult.correct_count + _testResult.wrong_count)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SizeUtil.textSizeBig, color: Colors.white),
              ),
              AnimatedCircularChart(
                key: _chartKey,
                size: Size(280, 280),
                initialChartData: data,
                chartType: CircularChartType.Pie,
              ),
              ListTile(
                title: Text(
                  "You got ${_testResult.correct_count} correct answers.",
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.done_all,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text(
                  _getRankMessage(),
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.stars,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text(
                  "You have finished this test during ${_getDurationMinute()} minutes",
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.access_time,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text(
                  "The best person got ${_getBestPoint()} points",
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              WidgetUtil.getRoundedButtonWhite(context, "Do it again", () {
                Navigator.of(context).pop("again");
              }),
              WidgetUtil.getRoundedButtonWhite(context, "View answer", () {}),
              WidgetUtil.getRoundedButtonWhite(context, "Come back", () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }),
              Container(
                height: SizeUtil.spaceBig,
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    if (_testResult == null || _testResult.total_point == null) return "";
    if (_testResult.total_point > 9.5)
      return "Very excellent! You got:";
    else if (_testResult.total_point > 7.5)
      return "Good! You got:";
    else if (_testResult.total_point > 5)
      return "Not bad! You got:";
    else if (_testResult.total_point > 3)
      return "Not good, you need to try more. You got:";
    else
      return "Too bad T_T. You need to practice more and more! You got:";
  }

  double _getBestPoint() {
    if (_resultStatisticResponse == null ||
        _resultStatisticResponse.best_point == null) return 0;
    return _resultStatisticResponse.best_point;
  }

  String _getRankMessage() {
    if (_resultStatisticResponse == null) return "Waiting for response...";
    if (_resultStatisticResponse.user_better_count == null ||
        _resultStatisticResponse.user_better_count == 0)
      return "Congratulation! You got the best points!";
    else {
      return "Your points are currently ranked number ${_resultStatisticResponse.user_better_count + 1}";
    }
  }

  int _getDurationMinute() {
    if (_testResult == null || _testResult.test_duration == null) return 0;
    int duration = (_testResult.test_duration / 60).round();
    return duration == 0 ? 1 : duration;
  }

  List<CircularStackEntry> data = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(500.0, Colors.red[200], rankKey: 'Q1'),
        new CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
        new CircularSegmentEntry(2000.0, Colors.blue[200], rankKey: 'Q3'),
        new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ];
}
