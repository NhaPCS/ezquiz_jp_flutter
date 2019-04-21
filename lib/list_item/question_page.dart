import 'package:ezquiz_flutter/model/question.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class QuestionPage extends StatefulWidget {
  final Question question;
  final VoidCallback selectedAnswerCallBack;
  final bool isViewAnswer;

  const QuestionPage(
      this.question, this.selectedAnswerCallBack, this.isViewAnswer);

  @override
  State<StatefulWidget> createState() {
    return _QuestionPageState();
  }
}

typedef SelectedAnswerCallBack = void Function(int index);

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin<QuestionPage> {
  String _radioGroup = "";

  @override
  void initState() {
    _radioGroup = widget.question.selectedAnswer;
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
            Html(
              data: widget.question.question,
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
    if (widget.isViewAnswer) return;
    print("choose $answer");
    widget.question.selectedAnswer = answer;
    setState(() {
      _radioGroup = answer;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      widget.selectedAnswerCallBack();
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
            child: Html(
              data: widget.question.answers[answer],
              defaultTextStyle: TextStyle(color: getAnswerColor(answer)),
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
    if (!widget.isViewAnswer) return ColorUtil.textColor;
    if (widget.question.answer == null) return ColorUtil.textColor;
    if (widget.question.selectedAnswer != null) {
      if (widget.question.answer.toLowerCase() ==
          widget.question.selectedAnswer.toLowerCase() &&
          widget.question.selectedAnswer == answer.toLowerCase())
        return Colors.green;
      else {
        if (widget.question.answer.toLowerCase() !=
            widget.question.selectedAnswer.toLowerCase()) {
          if (widget.question.selectedAnswer == answer.toLowerCase()) {
            return Colors.red;
          }
          if (widget.question.answer == answer.toLowerCase()) {
            return Colors.green;
          }
        }
      }
    } else if (widget.question.answer == answer) {
      return Colors.green;
    }
    return ColorUtil.textColor;
  }

  Widget getAnswerIcon(String answer) {
    if (!widget.isViewAnswer) return Container();
    if (widget.question.answer == null) return Container();
    if (widget.question.selectedAnswer != null) {
      if (widget.question.answer.toLowerCase() ==
          widget.question.selectedAnswer.toLowerCase() &&
          widget.question.selectedAnswer == answer.toLowerCase())
        return Icon(Icons.done_all, color: Colors.green);
      else {
        if (widget.question.answer.toLowerCase() !=
            widget.question.selectedAnswer.toLowerCase()) {
          if (widget.question.selectedAnswer == answer.toLowerCase()) {
            return Icon(Icons.close, color: Colors.red);
          }
          if (widget.question.answer == answer.toLowerCase()) {
            return Icon(Icons.done, color: Colors.green);
          }
        }
      }
    } else if (widget.question.answer == answer) {
      return Icon(Icons.done_all, color: Colors.green);
    }
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
