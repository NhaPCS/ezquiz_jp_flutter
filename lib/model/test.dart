import 'package:sqflite/sqflite.dart';


final String tableTestModel = 'testModel';
final String _id = '_id';
final String _testName = 'test_name';
final String _comment = "comment";
final String _level = "level";
final String _description = "description";
final String _creationTime = "creation_time";
final String _duration = "duration";
final String _enable = "enable";
final String _testFile = "test_file";
final String _testBuyCount = "test_buy_count";
final String _testDoneCount = "test_done_count";
final String _rateCount = "rate_count";
final String _cateId = "cate_id";
final String _coin = "coin";
final String _isBought = "isBought";
final String _isTest = "isTest";

class TestModel {
  String id;
  String testName;
  int comment;
  String level;
  String description;
  int creationTime;
  int duration;
  bool enable;
  String testFile;
  int testBuyCount;
  int testDoneCount;
  int coin;
  int rateCount;
  String cateId;
  bool isBought;
  bool isTest;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      _id: id,
      _testName: testName,
      _comment: comment,
      _level: level,
      _description: description,
      _creationTime: creationTime,
      _duration: duration,
      _enable: enable == true ? 1 : 0,
      _testFile: testFile,
      _testBuyCount: testBuyCount,
      _testDoneCount: testDoneCount,
      _coin: coin,
      _rateCount: rateCount,
      _cateId: cateId,
      _isBought: isBought == true ? 1 : 0,
      _isTest: isTest == true ? 1 : 0
    };
    return map;
  }

  TestModel.fromMap(Map<dynamic, dynamic> map) {
    id = map[_id];
    testName = map[_testName];
    comment = map[_comment];
    level = map[_level];
    description = map[_description];
    creationTime = map[_creationTime];
    duration = map[_duration];
    enable = map[_enable] == 1;
    testFile = map[_testFile];
    testBuyCount = map[_testBuyCount];
    testDoneCount = map[_testDoneCount];
    coin = map[_coin];
    rateCount = map[_rateCount];
    cateId = map[_cateId];
    isBought = map[_isBought] == 1;
    isTest = map[_isTest] == 1;
  }

  TestModel.fromJson(var map){
    id = map["id"];
    testName = map["test_name"];
    comment = map["comment"];
    level = map["level"];
    creationTime = map["creation_time"];
    duration = map["duration"];
    enable = map["enable"];
    coin = map["coin"];
    rateCount = map["rate_count"];
    cateId = map["cate_id"];

  }
}

class TestModelProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTestModel ( 
  $_id text primary key, 
  $_testName text not null,
  $_comment integer not null,
  $_level text not null,
  $_description text not null,
  $_creationTime integer not null,
  $_duration integer not null,
  $_enable integer not null,
  $_testFile text,
  $_testBuyCount integer not null,
  $_testDoneCount integer not null,
  $_coin integer not null,
  $_rateCount integer not null,
  $_cateId text,
  $_isBought integer not null,
  $_isTest integer not null,
  )
''');
    });
  }

  Future<TestModel> insert(TestModel testModel) async {
    await db.insert(tableTestModel, testModel.toMap());
    return testModel;
  }

  Future<TestModel> getTestModel(int id) async {
    List<Map> maps =
        await db.rawQuery("select * from $tableTestModel where $_id = $id");
    if (maps.length > 0) {
      return TestModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.rawDelete("delete from $tableTestModel where $_id = $id");
  }

  Future<int> update(TestModel testModel) async {
    return await db.rawUpdate(
        "update $tableTestModel set "
            "$_comment = ${testModel.comment}, "
            "$_duration = ${testModel.duration}, "
            "$_enable = ${testModel.enable}, "
            "$_testFile = ${testModel.testFile}, "
            "$_testBuyCount = ${testModel.testBuyCount}, "
            "$_comment = ${testModel.comment}, "
            "$_comment = ${testModel.comment}, "
            "$_comment = ${testModel.comment}, "
            "$_comment = ${testModel.comment}, "
            "$_duration =${testModel.duration}");
  }

  Future close() async => db.close();
}
