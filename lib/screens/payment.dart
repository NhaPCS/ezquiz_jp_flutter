import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/list_item/purchase_item.dart';
import 'package:ezquiz_flutter/model/coin.dart';
import 'package:ezquiz_flutter/data/database.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaymentState();
  }
}

class _PaymentState extends State<PaymentScreen> {
  List<Coin> _listCoins = List();

  @override
  void initState() {
    DBProvider.db.getListCoins().then((List<Coin> list) {
      setState(() {
        _listCoins = list;
      });
    });
    super.initState();
  }

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
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeUtil.bigRadius)),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: SizeUtil.defaultPaddig,
                      child: Text(
                        "Current coins:",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          color: ColorUtil.primaryColor,
                          borderRadius:
                              BorderRadius.circular(SizeUtil.bigRadius)),
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
              ),
            ),
            GridView.builder(
                itemCount: _listCoins.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return PaymentItem(
                    coin: _listCoins[index],
                  );
                })
          ],
        ),
      ),
    );
  }
}
