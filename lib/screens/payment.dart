import 'package:ezquiz_flutter/data/database.dart';
import 'package:ezquiz_flutter/list_item/purchase_item.dart';
import 'package:ezquiz_flutter/model/coin.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ezquiz_flutter/screens/tab_buy_history.dart';
import 'package:ezquiz_flutter/model/payment_history.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaymentState();
  }
}

class _PaymentState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin<PaymentScreen> {
  List<Coin> _listCoins = List();
  TabController _tabController;
  List<PaymentHistory> _listPaymentHistory = List();

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              Container(
                height: SizeUtil.spaceBig,
              ),
              StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: _listCoins.length,
                shrinkWrap: true,
                mainAxisSpacing: SizeUtil.spaceBig,
                crossAxisSpacing: SizeUtil.spaceBig,
                itemBuilder: ((context, int index) {
                  return PaymentItem(
                    coin: _listCoins[index],
                  );
                }),
                staggeredTileBuilder: (int index) {
                  return new StaggeredTile.fit(1);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: SizeUtil.lineSize,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: SizeUtil.smallPadding,
                    child: Text(
                      "Payment history",
                      style: TextStyle(color: ColorUtil.primaryColor),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: SizeUtil.lineSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: ColorUtil.primaryColor,
                labelColor: ColorUtil.primaryColor,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: ColorUtil.primaryColor),
                tabs: <Widget>[
                  Tab(
                    text: "Buy test",
                  ),
                  Tab(
                    text: "Charge coin",
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    TabBuy(
                      listPaymentHistory: _listPaymentHistory,
                    ),
                    TabBuy(
                      listPaymentHistory: _listPaymentHistory,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
