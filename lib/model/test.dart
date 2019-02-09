
class TestModel {
  String id;
  String testName;
  int comment;
  String level;
  String description;
  int creationTime;
  int duration;
  bool enable;
  int testBuyCount;
  int testDoneCount;
  int coin;
  int rateCount;
  String cateId;
  bool isBought;
  bool isTest;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "test_name": testName,
      "comment": comment,
      "level": level,
      "description": description,
      "creation_time": creationTime,
      "duration": duration,
      "enable": enable == true ? 1 : 0,
      "test_buy_count": testBuyCount,
      "test_done_count": testDoneCount,
      "coin": coin,
      "rate_count": rateCount,
      "cate_id": cateId,
      "isBought": isBought == true ? 1 : 0,
      "isTest": isTest == true ? 1 : 0
    };
    return map;
  }

  TestModel.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    testName = map["test_name"];
    comment = map["comment"];
    level = map["level"];
    description = map["description"];
    creationTime = map["creation_time"];
    duration = map["duration"];
    enable = map["enable"] == 1;
    testBuyCount = map["test_buy_count"];
    testDoneCount = map["test_done_count"];
    coin = map["coin"];
    rateCount = map["rate_count"];
    cateId = map["cate_id"];
    isBought = map["isBought"] == 1;
    isTest = map["isTest"] == 1;
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
