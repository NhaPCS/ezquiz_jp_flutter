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
          "Test history",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          WidgetUtil.getPrimaryIconWithColor(
              context, Icons.monetization_on, Colors.white)
        ],
      ),
      body: Padding(
        padding: SizeUtil.defaultPaddig,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
