import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';

class HistoryItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryItem();
  }
}

class _HistoryItem extends State<HistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
              Container(
                width: SizeUtil.lineSize,
                color: ColorUtil.primaryColor,
              ),
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
                  "12/02/2019",
                  style: TextStyle(
                      color: ColorUtil.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: SizeUtil.spaceDefault,
                ),
                Text(
                  "13:36 - JLPT N5 and N4 Quiz: Reading Comprehension",
                  style: TextStyle(
                      color: ColorUtil.textColor, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: SizeUtil.spaceDefault,
                ),
                Text(
                  "You have finished this test during 10 minutes",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: ColorUtil.textGray,
                  ),
                ),
                Text(
                  "You got 10/30 the correct answer",
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
    );
  }
}
