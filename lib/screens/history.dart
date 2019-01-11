import 'package:ezquiz_flutter/list_item/history_test_item.dart';
import 'package:ezquiz_flutter/model/history.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryState();
  }
}

class _HistoryState extends State<HistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<History> _listHistory = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      ),
      body: ListView.builder(itemCount: 100, itemBuilder: (context, index) {
       // History history = _listHistory[index];
        return HistoryItem();
      }),
    );
  }
}
