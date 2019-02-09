import 'package:ezquiz_flutter/data/database.dart';
import 'package:ezquiz_flutter/list_item/test_item.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/model/test.dart';
import 'package:ezquiz_flutter/screens/home.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:flutter/material.dart';

class ListTest extends StatefulWidget {
  final Category category;
  final FilterType filterType;

  ListTest({Key key, this.category, this.filterType});

  @override
  State<StatefulWidget> createState() {
    return _ListTestState(category, filterType);
  }
}

class _ListTestState extends State<ListTest>
    with AutomaticKeepAliveClientMixin<ListTest> {
  final FilterType _filterType;
  final Category _category;

  List<TestModel> _listTest = List();

  _ListTestState(this._category, this._filterType);

  @override
  void initState() {
    _changeType();
    super.initState();
  }

  _changeType() {
    switch (_filterType) {
      case FilterType.most_rate:
        DBProvider.db
            .getMostVoteTest(_category.id)
            .then((List<TestModel> list) {
          setState(() {
            _listTest = list;
          });
        });
        break;
      case FilterType.free:
        DBProvider.db.getFreeTest(_category.id).then((List<TestModel> list) {
          setState(() {
            _listTest = list;
          });
        });
        break;
      case FilterType.hasFee:
        DBProvider.db.getHasFreeTest(_category.id).then((List<TestModel> list) {
          setState(() {
            _listTest = list;
          });
        });
        break;
      case FilterType.most_done:
        DBProvider.db
            .getMostDoneTest(_category.id)
            .then((List<TestModel> list) {
          setState(() {
            _listTest = list;
          });
        });
        break;
      case FilterType.none:
      default:
        DBProvider.db.getTestByCate(_category.id).then((List<TestModel> list) {
          setState(() {
            _listTest = list;
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      padding: SizeUtil.tinyPadding,
      itemCount: _listTest == null ? 0 : _listTest.length,
      itemBuilder: (BuildContext context, int index) {
        return TestItem(
          testModel: _listTest[index],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
