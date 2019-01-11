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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: SizeUtil.spaceBig),
          width: SizeUtil.lineSize,
          color: ColorUtil.primaryColor,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: ColorUtil.primaryColor,
            ),
            Text(
              "08/01/2018",
              style: TextStyle(
                  color: ColorUtil.primaryColor, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: SizeUtil.spaceBig),
          width: SizeUtil.lineSize,
          color: ColorUtil.primaryColor,
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: SizeUtil.spaceBig),
              width: SizeUtil.lineSize,
              color: ColorUtil.primaryColor,
            ),
            Container(width: SizeUtil.spaceBig,),
            Column(
              children: <Widget>[
                Text(
                  "13:36 - JLPT N5 and N4 Quiz: Reading Comprehension",
                  style: TextStyle(
                      color: ColorUtil.textColor, fontWeight: FontWeight.bold),
                ),
                Container(height: SizeUtil.spaceDefault,),
                Text(
                  "You have finished this test during 10 minutes",
                  style: TextStyle(
                      color: ColorUtil.textGray, ),
                ),
                Text(
                  "You got 10/30 the correct answer",
                  style: TextStyle(
                    color: ColorUtil.textGray, ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
