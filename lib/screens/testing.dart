import 'package:flutter/material.dart';
import 'package:ezquiz_flutter/utils/resources.dart';
import 'package:ezquiz_flutter/model/models.dart';


class TestingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }

}

class _TestingState extends State<TestingScreen> {

  final TestModel _testModel;

  _TestingState(this._testModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close, color: Theme.of(context).primaryColor,),
        title: Text(_testModel.name),
        actions: <Widget>[
          Icon(Icons.extension, color: Theme.of(context).primaryColor,),
          Icon(Icons.filter_list, color: Theme.of(context).primaryColor,),
        ],
      ),
      body: Card(
        margin: Size.defaultMargin,
        elevation: Size.elevationDefault,
        child: Container(
          padding: Size.defaultPaddig,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("1")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}