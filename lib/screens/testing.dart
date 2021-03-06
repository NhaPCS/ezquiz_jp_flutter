import 'package:ezquiz_flutter/list_item/question_page.dart';
import 'package:ezquiz_flutter/model/question.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/screens/test_result.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/model/test_result.dart';

class TestingScreen extends StatefulWidget {
  final TestModel testModel;
  final bool isViewAnswer;

  TestingScreen(this.testModel, this.isViewAnswer);

  @override
  State<StatefulWidget> createState() {
    return _TestingState(testModel, isViewAnswer);
  }
}

class _TestingState extends State<TestingScreen>
    with TickerProviderStateMixin<TestingScreen> {
  AnimationController _animationController;
  final TestModel _testModel;
  List<Question> _listQuestion = List();
  PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool _isViewAnswer = false;
  bool _finished = false;

  _TestingState(this._testModel, this._isViewAnswer);

  @override
  void initState() {
    getListQuestion();
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: _testModel.duration),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
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
                  padding: SizeUtil.defaultPadding,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Text(
                      _listQuestion[index].selectedAnswer == null
                          ? ""
                          : _listQuestion[index].selectedAnswer,
                      style: TextStyle(
                          color: ColorUtil.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      "Question number ${index + 1}",
                      style: TextStyle(
                          color: getAnswerColor(_listQuestion[index])),
                    ),
                    trailing: getAnswerIcon(_listQuestion[index]),
                  ),
                ),
                onTap: () {
                  _jumpPage(index);
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
              child: Icon(
                Icons.cloud_done,
                color: _isViewAnswer ? Colors.grey : ColorUtil.primaryColor,
                size: SizeUtil.iconSize,
              ),
              onTap: () {
                if (!_isViewAnswer) showSubmitDialog();
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
                  if (!_finished && state == AnimationStatus.completed) {
                    _getResult();
                  }
                  _finished = true;
                }),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _selectedIndex = page;
                  });
                },
                itemBuilder: (context, index) {
                  Question question = _listQuestion[index];
                  return QuestionPage(question, () {
                    print("Click roi sao k hien?");
                    if (index < _listQuestion.length - 1) {
                      _jumpPage(index + 1);
                    } else {
                      showSubmitDialog();
                    }
                  }, _isViewAnswer);
                },
                itemCount: _listQuestion.length,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: _selectedIndex > 0,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: GestureDetector(
                    child: Wrap(
                      children: <Widget>[
                        Container(
                          width: SizeUtil.spaceSmall,
                        ),
                        Icon(
                          Icons.keyboard_arrow_left,
                          color: ColorUtil.textGray,
                        ),
                        Text(
                          "Pre",
                          style: TextStyle(color: ColorUtil.textGray),
                        )
                      ],
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: SizeUtil.spaceSmall,
                    ),
                    onTap: () {
                      if (_selectedIndex > 0) {
                        setState(() {
                          _selectedIndex--;
                          _jumpPage(_selectedIndex);
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    "${_selectedIndex + 1}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: ColorUtil.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeUtil.textSizeHuge),
                  ),
                ),
                Expanded(
                  child: Text(
                    "/${_listQuestion.length}",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: ColorUtil.textGray, fontSize: 25),
                  ),
                ),
                Visibility(
                  visible: _selectedIndex < _listQuestion.length - 1,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: GestureDetector(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          "Next",
                          style: TextStyle(color: ColorUtil.textGray),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: ColorUtil.textGray,
                        ),
                        Container(
                          width: SizeUtil.spaceSmall,
                        )
                      ],
                      spacing: SizeUtil.spaceSmall,
                    ),
                    onTap: () {
                      if (_selectedIndex < _listQuestion.length - 1) {
                        setState(() {
                          _selectedIndex++;
                          _jumpPage(_selectedIndex);
                        });
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Color getAnswerColor(Question question) {
    if (!_isViewAnswer || question.answer == null) return ColorUtil.textColor;
    if (question.selectedAnswer != null) {
      if (question.answer.toLowerCase() ==
          question.selectedAnswer.toLowerCase())
        return Colors.green;
      else {
        return Colors.red;
      }
    }
    return ColorUtil.textColor;
  }

  Widget getAnswerIcon(Question question) {
    if (!_isViewAnswer || question.answer == null)
      return Container(
        width: 0,
      );
    if (question.selectedAnswer != null) {
      if (question.answer.toLowerCase() ==
          question.selectedAnswer.toLowerCase())
        return Icon(Icons.done, color: Colors.green);
      else {
        return Icon(
          Icons.close,
          color: Colors.red,
        );
      }
    }
    return Container(
      width: 0,
    );
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
        list.add(new Question.fromMap(value));
      }
      setState(() {
        _listQuestion = list;
        _jumpPage(0);
        if (!_isViewAnswer) _animationController.forward(from: 0.0);
        print("QUESTION LIST $_listQuestion");
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
                    _getResult();
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

  void _getResult() async {
    if (_animationController != null) _animationController.stop();
    int testTime = _testModel.duration - _animationController.value.round();
    TestResult testResult =
        await getTestResult(_testModel, _listQuestion, testTime);
    if (testResult != null) {
      print("TEST RESULT ${testResult.total_point}");
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => TestResultScreen(testResult: testResult)))
          .then((type) {
        if (type != null) {
          if (type == "again") {
            _finished = false;
            _resetAnswers();
            _jumpPage(0);
          } else if (type == "answer") {
            setState(() {
              _isViewAnswer = true;
              _jumpPage(0);
            });
          }
        }
      });
    }
  }

  void _jumpPage(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(_selectedIndex,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
  }

  Future<void> _resetAnswers() async {
    for (Question question in _listQuestion) {
      question.selectedAnswer = null;
    }
    setState(() {
      _listQuestion = _listQuestion;
      _animationController.reset();
      _animationController.forward(from: 0.0);
    });
    return;
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
