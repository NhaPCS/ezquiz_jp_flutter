import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/model/coin.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class PaymentItem extends StatefulWidget {
  final Coin coin;

  const PaymentItem({Key key, this.coin}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentItemState(coin);
  }
}

class _PaymentItemState extends State<PaymentItem> {
  final Coin _coin;

  _PaymentItemState(this._coin);

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SizeUtil.bigRadius)),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Container(
              padding: SizeUtil.smallPadding,
              child: Text(
                _coin.cost,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(SizeUtil.defaultRadius)),
            ),
            Container(
              width: SizeUtil.spaceDefault,
            ),
            Text(
              '${_coin.coin}',
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.attach_money,
              color: Colors.orange,
            ),
          ],
        ),
      ),
      onTap: () {
        _buyProduct(null);
      },
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    // refresh items for android
    String msg = await FlutterInappPurchase.consumeAllItems;
    print('consumeAllItems: $msg');
  }

  Future<Null> _buyProduct(IAPItem item) async {
    try {
      PurchasedItem purchased =
          await FlutterInappPurchase.buyProduct(item.productId);
      print('purchased: ${purchased.toString()}');
    } catch (error) {
      print('$error');
    }
  }

  Future<Null> _getProduct() async {
//    List<IAPItem> items = await FlutterInappPurchase.getProducts(_productLists);
//    for (var item in items) {
//      print('${item.toString()}');
//      this._items.add(item);
//    }
//
//    setState(() {
//      this._items = items;
//      this._purchases = [];
//    });
  }

  Future<Null> _getPurchases() async {
//    List<PurchasedItem> items =
//    await FlutterInappPurchase.getAvailablePurchases();
//    for (var item in items) {
//      print('${item.toString()}');
//      this._purchases.add(item);
//    }
//
//    setState(() {
//      this._items = [];
//      this._purchases = items;
//    });
  }

  Future<Null> _getPurchaseHistory() async {
//    List<PurchasedItem> items = await FlutterInappPurchase.getPurchaseHistory();
//    for (var item in items) {
//      print('${item.toString()}');
//      this._purchases.add(item);
//    }
//
//    setState(() {
//      this._items = [];
//      this._purchases = items;
//    });
  }
}
