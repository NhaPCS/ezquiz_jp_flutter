import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:ezquiz_flutter/model/question.dart';

class TestingScreen extends StatefulWidget {
  final TestModel _testModel;

  TestingScreen(this._testModel);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestingState(_testModel);
  }
}

class _TestingState extends State<TestingScreen> {
  final TestModel _testModel;
  List<Question> _listQuestion;
  SwiperController _swiperController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _TestingState(this._testModel);

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
  }

  @override
  Widget build(BuildContext context) {
    _listQuestion = new List();
    _listQuestion.add(new Question("What is your name?", "a"));
    _listQuestion
        .add(new Question("What is print('_TestingState.build');?", "b"));
    _listQuestion.add(new Question("What is 3?", "a"));
    _listQuestion.add(new Question("What is 4?", "c"));
    _listQuestion.add(new Question("What is 5?", "a"));
    _listQuestion.add(new Question("What is 6?", "d"));
    _listQuestion.add(new Question("What is 7?", "d"));
    _listQuestion.add(new Question("What is 8?", "b"));
    _listQuestion.add(new Question("What is 9?", "c"));

    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: ListView.builder(
            itemCount: _listQuestion.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  padding: Size.defaultPaddig,
                  child: Row(
                    children: <Widget>[
                      Text(
                        _listQuestion[index].answer,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      Container(
                        width: Size.textSizeSmall,
                      ),
                      Text(
                        _listQuestion[index].question,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
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
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          actions: <Widget>[
            WidgetUtil.getPrimaryIcon(context, Icons.extension),
            Container(
              width: Size.spaceDefault,
            ),
            GestureDetector(
              child: WidgetUtil.getPrimaryIcon(context, Icons.filter_list),
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
            Container(
              width: Size.spaceDefault,
            ),
          ],
        ),
        body: Swiper(
          itemCount: _listQuestion.length,
          pagination: SwiperPagination(
              builder: FractionPaginationBuilder(
                  color: Colors.grey,
                  activeColor: Theme.of(context).primaryColor)),
          controller: _swiperController,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Size.smallRadius),
              ),
              elevation: Size.elevationBig,
              child: Container(
                padding: Size.defaultPaddig,
                child: Column(
                  children: <Widget>[
                    Expanded(child: HtmlText(data: """
    <!--For a much more extensive example, look at example/main.dart-->
    <div>
      <h1>Demo Page</h1>
      <p>This is a fantastic nonexistent product that you should buy!</p>
      <h2>Pricing</h2>
      <p>Lorem ipsum <b>dolor</b> sit amet.</p>
      <h2>The Team</h2>
      <p>There isn't <i>really</i> a team...</p>
      <h2>Installation</h2>
      <p>You <u>cannot</u> install a nonexistent product!</p>
      <!--You can pretty much put any html in here!-->
    </div>
  """))
                  ],
                ),
              ),
            );
          },
        ));
  }
}
