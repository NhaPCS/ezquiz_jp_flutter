import 'package:flutter/material.dart';

class TestResult {
  double total_point;
  int correct_count;
  int wrong_count;
  int test_time;
  int test_duration;
  String test_name;
  String test_id;
  String user_id;

  TestResult(
      {this.total_point,
      this.correct_count,
      this.wrong_count,
      this.test_time,
      this.test_duration,
      this.test_name,
      this.test_id,
      this.user_id});

  TestResult.fromJson(var map) {
    total_point = map["total_point"];
    correct_count = map["correct_count"];
    wrong_count = map["wrong_count"];
    test_time = map["test_time"];
    test_duration = map["test_duration"];
    test_name = map["test_name"];
    test_id = map["test_id"];
    user_id = map["user_id"];
  }

  TestResult.fromMap(Map<dynamic, dynamic> map) {
    total_point = num.parse(map["total_point"].toString()).toDouble();
    correct_count = map["correct_count"];
    wrong_count = map["wrong_count"];
    test_time = map["test_time"];
    test_duration = map["test_duration"];
    test_name = map["test_name"];
    test_id = map["test_id"];
    user_id = map["user_id"];
  }

  String toJson() {
    return {
      "total_point": total_point,
      "correct_count": correct_count,
      "wrong_count": wrong_count,
      "test_time": test_time,
      "test_duration": test_duration,
      "test_name": test_name,
      "test_id": test_id,
      "user_id": user_id,
    }.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      "total_point": total_point,
      "correct_count": correct_count,
      "wrong_count": wrong_count,
      "test_time": test_time,
      "test_duration": test_duration,
      "test_name": test_name,
      "test_id": test_id,
      "user_id": user_id,
    };
  }

  Color getColor() {
    if (total_point == null) return Colors.grey;
    if (total_point >= 9.5)
      return Colors.red;
    else if (total_point >= 7.5)
      return Colors.deepOrange;
    else if (total_point >= 5)
      return Colors.green;
    else if (total_point >= 3)
      return Colors.blueAccent;
    else
      return Colors.grey;
  }
}
