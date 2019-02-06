import 'package:ezquiz_flutter/model/question.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_text.dart';

class QuestionPage extends StatefulWidget {
  final Question question;
  final VoidCallback selectedAnswerCallBack;
  final bool isViewAnswer;

  const QuestionPage(
      this.question, this.selectedAnswerCallBack, this.isViewAnswer);

  @override
  State<StatefulWidget> createState() {
    return _QuestionPageState(question, selectedAnswerCallBack, isViewAnswer);
  }
}

typedef SelectedAnswerCallBack = void Function(int index);

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin<QuestionPage> {
  final Question _question;
  final VoidCallback _selectedAnswerCallBack;
  String _radioGroup = "";
  final bool _isViewAnswer;

  _QuestionPageState(
      this._question, this._selectedAnswerCallBack, this._isViewAnswer);

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
            HtmlText(
              data: _question.question,
            ),
            Container(
              height: SizeUtil.spaceDefault,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: SizeUtil.lineSize,
                    color: ColorUtil.background,
                  ),
                ),
                Text(
                  "Choose the best answer",
                  style: TextStyle(
                      fontSize: SizeUtil.textSizeTiny,
                      color: ColorUtil.textGray),
                ),
                Expanded(
                  child: Container(
                    height: SizeUtil.lineSize,
                    color: ColorUtil.background,
                  ),
                ),
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
    if (_isViewAnswer) return;
    print("choose $answer");
    _question.selectedAnswer = answer;
    setState(() {
      _radioGroup = answer;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _selectedAnswerCallBack();
    });
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
              color: getAnswerColor(answer),
            ),
          ),
          getAnswerIcon(answer),
        ],
      ),
      onTap: () {
        _onChooseAnswer(answer);
      },
    );
  }

  Color getAnswerColor(String answer) {
    if (!_isViewAnswer) return ColorUtil.textColor;
    if (_question.answer == null) return ColorUtil.textColor;
    if (_question.selectedAnswer != null) {
      if (_question.answer.toLowerCase() ==
              _question.selectedAnswer.toLowerCase() &&
          _question.selectedAnswer == answer.toLowerCase())
        return Colors.green;
      else {
        if (_question.answer.toLowerCase() !=
            _question.selectedAnswer.toLowerCase()) {
          if (_question.selectedAnswer == answer.toLowerCase()) {
            return Colors.red;
          }
          if (_question.answer == answer.toLowerCase()) {
            return Colors.green;
          }
        }
      }
    } else if (_question.answer == answer) {
      return Colors.green;
    }
    return ColorUtil.textColor;
  }

  Widget getAnswerIcon(String answer) {
    if (!_isViewAnswer) return Container();
    if (_question.answer == null) return Container();
    if (_question.selectedAnswer != null) {
      if (_question.answer.toLowerCase() ==
              _question.selectedAnswer.toLowerCase() &&
          _question.selectedAnswer == answer.toLowerCase())
        return Icon(Icons.done_all, color: Colors.green);
      else {
        if (_question.answer.toLowerCase() !=
            _question.selectedAnswer.toLowerCase()) {
          if (_question.selectedAnswer == answer.toLowerCase()) {
            return Icon(Icons.close, color: Colors.red);
          }
          if (_question.answer == answer.toLowerCase()) {
            return Icon(Icons.done, color: Colors.green);
          }
        }
      }
    } else if (_question.answer == answer) {
      return Icon(Icons.done_all, color: Colors.green);
    }
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
