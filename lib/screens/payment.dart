import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaymentState();
  }
}

class _PaymentState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          child: WidgetUtil.getPrimaryIconWithColor(
              context, Icons.close, Colors.white),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Payment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: SizeUtil.smallPadding,
              child: WidgetUtil.getPrimaryIconWithColor(
                  context, Icons.monetization_on, Colors.white),
            ),
            onTap: () {},
          )
        ],
      ),
      body: Padding(
        padding: SizeUtil.defaultPaddig,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(SizeUtil.bigRadius)),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    padding: SizeUtil.defaultPaddig,
                    onPressed: null,
                    child: Text(
                      "Current coins:",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeUtil.bigRadius)),
                    color: ColorUtil.primaryColor,
                  ),
                  Container(
                    width: SizeUtil.spaceBig,
                  ),
                  Text(
                    "123",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.attach_money,
                    color: Colors.orange,
                  ),
                  Container(
                    width: SizeUtil.spaceDefault,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
