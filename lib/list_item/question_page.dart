import 'package:ezquiz_flutter/model/question.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_text.dart';

class QuestionPage extends StatefulWidget {
  final Question question;
  final VoidCallback selectedAnswerCallBack;

  const QuestionPage(this.question,  this.selectedAnswerCallBack);

  @override
  State<StatefulWidget> createState() {
    return _QuestionPageState(question, selectedAnswerCallBack);
  }
}

typedef SelectedAnswerCallBack = void Function(int index);

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin<QuestionPage> {
  final Question _question;
  final VoidCallback _selectedAnswerCallBack;
  String _radioGroup = "";

  _QuestionPageState(this._question, this._selectedAnswerCallBack);

  @override
  void initState() {
    _radioGroup = _question.selectedAnswer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeUtil.smallRadius),
      ),
      elevation: SizeUtil.elevationBig,
      child: Container(
        padding: SizeUtil.defaultPadding,
        child: ListView(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Q:",
                  style: TextStyle(
                      fontSize: SizeUtil.textSizeBig,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: HtmlText(
                    data: _question.question,
                  ),
                )
              ],
            ),
            Container(
              height: SizeUtil.spaceDefault,
            ),
            getRadioRow("a"),
            Container(
              height: SizeUtil.spaceDefault,
            ),
            getRadioRow("b"),
            Container(
              height: SizeUtil.spaceDefault,
            ),
            getRadioRow("c"),
            Container(
              height: SizeUtil.spaceDefault,
            ),
            getRadioRow("d"),
          ],
        ),
      ),
    );
  }

  _onChooseAnswer(String answer) {
    print("choose $answer");
    _question.selectedAnswer = answer;
    setState(() {
      _radioGroup = answer;
    });
    _selectedAnswerCallBack();
  }

  Widget getRadioRow(String answer) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Radio(
              activeColor: ColorUtil.primaryColor,
              value: answer,
              groupValue: _radioGroup,
              onChanged: (String value) {
                _onChooseAnswer(value);
              }),
          Expanded(
            child: HtmlText(
              data: _question.answers[answer],
            ),
          )
        ],
      ),
      onTap: () {
        _onChooseAnswer(answer);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
