import 'package:ezquiz_flutter/data/service.dart';
import 'package:ezquiz_flutter/list_item/history_test_item.dart';
import 'package:ezquiz_flutter/model/test_result.dart';
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
  List<TestResult> _listHistory = List();
  String _selectedType;
  Map<String, String> _mapTypes;

  @override
  void initState() {
    _mapTypes = Map();
    _mapTypes["all"] = "All";
    _mapTypes["good"] = "Good";
    _mapTypes["normal"] = "Normal";
    _mapTypes["too_bad"] = "Too bad";
    _selectedType = _mapTypes["all"];
    _getListHistory();
    super.initState();
  }

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
        actions: <Widget>[getSubjectPopupWidget()],
      ),
      body: ListView.builder(
          itemCount: _listHistory == null ? 0 : _listHistory.length,
          itemBuilder: (context, index) {
            // History history = _listHistory[index];
            return HistoryItem(
              testResult: _listHistory[index],
            );
          }),
    );
  }

  PopupMenuButton getSubjectPopupWidget() {
    return new PopupMenuButton<String>(
        child: Center(
          child: Padding(
            padding: SizeUtil.defaultPadding,
            child: Text(
              _selectedType,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeUtil.textSizeDefault,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        itemBuilder: (BuildContext context) {
          return _mapTypes.keys.map((String id) {
            return PopupMenuItem<String>(
              child: Text(
                _mapTypes[id],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: id,
            );
          }).toList();
        },
        onSelected: (String value) {});
  }

  void _getListHistory() {
    getTestHistory().then((List<TestResult> list) {
      setState(() {
        _listHistory = list;
      });
    });
  }
}
