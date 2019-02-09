import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:ezquiz_flutter/model/test_result.dart';
import 'package:ezquiz_flutter/data/response.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/screens/testing.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:async';
import 'dart:io';

class TestResultScreen extends StatefulWidget {
  final TestResult testResult;

  const TestResultScreen({Key key, this.testResult}) : super(key: key);

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
  InterstitialAd _interstitialAd;

  _TestResultState(this._testResult);

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: Constant.ADS_INTERSTITIAL_ID_IOS,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
        if (event == MobileAdEvent.loaded) {
          _interstitialAd?.show();
        } else if (event == MobileAdEvent.failedToLoad) {
          RewardedVideoAd.instance.show();
        }
      },
    );
  }

  void _loadRewardAds() {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
    };
    String adUnit = Platform.isIOS
        ? Constant.ADS_REWARD_ID_IOS
        : Constant.ADS_REWARD_ID_ANDROID;
    print("ADS $adUnit");
    RewardedVideoAd.instance
        .load(adUnitId: adUnit, targetingInfo: MobileAdTargetingInfo());
  }

  @override
  void initState() {
    _loadRewardAds();
    getTestStatistic(_testResult.test_id, _testResult.correct_count)
        .then((ResultStatisticResponse response) {
      setState(() {
        _resultStatisticResponse = response;
      });
    });
    super.initState();
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
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
              _getChartView(),
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
              WidgetUtil.getRoundedButtonWhite(context, "View answer", () {
                Navigator.of(context).pop("answer");
              }),
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

  List<CircularStackEntry> _getChartData() {
    List<CircularStackEntry> list = List();
    List<CircularSegmentEntry> listSegment = List();
    if (_resultStatisticResponse == null) return list;
    listSegment.add(new CircularSegmentEntry(
        (_resultStatisticResponse.user_equal_count).toDouble(),
        Colors.yellow[200],
        rankKey: 'Q1'));
    listSegment.add(new CircularSegmentEntry(
        (_resultStatisticResponse.user_worse_count).toDouble(), Colors.red[200],
        rankKey: 'Q2'));
    listSegment.add(new CircularSegmentEntry(
        (_resultStatisticResponse.user_better_count).toDouble(),
        Colors.blue[200],
        rankKey: 'Q3'));
    list.add(new CircularStackEntry(listSegment));
    return list;
  }

  Widget _getChartView() {
    if (_resultStatisticResponse == null) {
      return Container(
        padding: SizeUtil.bigMargin,
        child: Text(
          "Waiting for response...",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }
    if ((_resultStatisticResponse.user_better_count == 0 &&
        _resultStatisticResponse.user_worse_count == 0 &&
        _resultStatisticResponse.user_equal_count == 0)) {
      return Container(
        padding: SizeUtil.bigMargin,
        child: Text(
          "Sorry! No data for the chart...",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }
    return AnimatedCircularChart(
      key: _chartKey,
      size: Size(280, 280),
      initialChartData: _getChartData(),
      chartType: CircularChartType.Pie,
    );
  }
}
