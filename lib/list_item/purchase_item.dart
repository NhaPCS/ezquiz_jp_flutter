import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/model/coin.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: SizeUtil.spaceBig,
          ),
          Text(
            "123",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.attach_money,
            color: Colors.orange,
          ),
          Container(
            width: SizeUtil.spaceSmall,
          ),
        ],
      ),
    );
  }
}
