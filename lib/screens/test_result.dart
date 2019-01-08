import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class TestResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestResultState();
  }
}

class _TestResultState extends State<TestResultScreen> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

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
                "Too bad T_T. You need to practice more and more. You got:",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              Container(
                height: SizeUtil.spaceDefault,
              ),
              Text(
                "10.0 points",
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
                "0/5",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SizeUtil.textSizeBig, color: Colors.white),
              ),
              AnimatedCircularChart(
                key: _chartKey,
                size: Size(300, 300),
                initialChartData: data,
                chartType: CircularChartType.Pie,
              ),
              ListTile(
                title: Text(
                  "Your correct answers are 12 questions",
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.stars,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text(
                  "You have finished this test during 3 minutes",
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.access_time,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text(
                  "The best person got 10.0 points",
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              WidgetUtil.getRoundedButtonWhite(context, "Do it again", () {}),
              WidgetUtil.getRoundedButtonWhite(context, "View answer", () {}),
              WidgetUtil.getRoundedButtonWhite(context, "Come back", () {}),
              Container(
                height: SizeUtil.spaceBig,
              )
            ],
          ),
        ),
      ),
    );
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
