import 'package:ezquiz_flutter/list_item/question_page.dart';
import 'package:ezquiz_flutter/model/question.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/screens/test_result.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TestingScreen extends StatefulWidget {
  final TestModel _testModel;

  TestingScreen(this._testModel);

  @override
  State<StatefulWidget> createState() {
    return _TestingState(_testModel);
  }
}

class _TestingState extends State<TestingScreen>
    with TickerProviderStateMixin<TestingScreen> {
  AnimationController _animationController;
  final TestModel _testModel;
  List<Question> _listQuestion = List();
  SwiperController _swiperController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  _TestingState(this._testModel);

  @override
  void initState() {
    getListQuestion();
    super.initState();
    _swiperController = SwiperController();
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: _testModel.duration),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: ListView.builder(
            itemCount: _listQuestion.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  padding: SizeUtil.defaultPaddig,
                  child: ListTile(
                    leading: Text(
                      _listQuestion[index].selectedAnswer == null
                          ? ""
                          : _listQuestion[index].selectedAnswer,
                      style: TextStyle(
                          color: ColorUtil.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    title: Text("Question number ${index + 1}"),
                  ),
                ),
                onTap: () {
                  _swiperController.move(index, animation: true);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            child: WidgetUtil.getPrimaryIcon(context, Icons.close),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            _testModel.testName,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            GestureDetector(
              child: WidgetUtil.getPrimaryIcon(context, Icons.cloud_done),
              onTap: () {
                showSubmitDialog();
              },
            ),
            Container(
              width: SizeUtil.spaceDefault,
            ),
            GestureDetector(
              child: WidgetUtil.getPrimaryIcon(context, Icons.filter_list),
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
            Container(
              width: SizeUtil.spaceDefault,
            ),
          ],
        ),
        bottomNavigationBar: Countdown(
          total: _testModel.duration,
          animation: new StepTween(begin: _testModel.duration, end: 0)
              .animate(_animationController)
                ..addStatusListener((state) {
                  print("STATE $state");
                  if (state == AnimationStatus.completed) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TestResultScreen()));
                  }
                }),
        ),
        body: Swiper(
          index: _selectedIndex,
          itemCount: _listQuestion.length,
          pagination: SwiperPagination(
              builder: FractionPaginationBuilder(
                  color: Colors.grey,
                  activeColor: Theme.of(context).primaryColor)),
          controller: _swiperController,
          itemBuilder: (BuildContext context, int index) {
            Question _question = _listQuestion[index];
            return QuestionPage(_question);
          },
        ));
  }

  void getListQuestion() {
    FirebaseDatabase.instance
        .reference()
        .child("question")
        .child(_testModel.id)
        .once()
        .then((DataSnapshot dataSnapshot) {
      List<Question> list = List();
      for (var value in dataSnapshot.value) {
        list.add(new Question.fromJson(value));
      }
      setState(() {
        _listQuestion = list;
        _swiperController.move(1, animation: false);
        _animationController.forward(from: 0.0);
      });
    });
  }

  void showSubmitDialog() {
    _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        padding: SizeUtil.defaultMargin,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Text(
              "Do you want to submit this test?",
              textAlign: TextAlign.center,
            ),
            Container(
              height: SizeUtil.spaceBig,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: SizeUtil.spaceDefault),
                    child: WidgetUtil.getRoundedButton(context, "Cancel", () {
                      Navigator.of(context).pop();
                    }),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: SizeUtil.spaceDefault),
                  child: WidgetUtil.getRoundedButton(context, "Submit", () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestResultScreen()));
                  }),
                ))
              ],
            ),
            Container(
              height: SizeUtil.spaceBig,
            )
          ],
        ),
      );
    });
  }
}

class Countdown extends AnimatedWidget {
  final int total;

  Countdown({Key key, this.animation, this.total})
      : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        LinearPercentIndicator(
          backgroundColor: ColorUtil.background,
          percent: (animation.value / total),
          lineHeight: 8,
          progressColor: ColorUtil.primaryColor,
          width: MediaQuery.of(context).size.width * 0.95,
        )
      ],
    );
  }
}
