import 'package:ezquiz_flutter/model/user.dart';

class BaseResponse {
  static const int ERROR_AUTH = 202;
  static const int ERROR_OUT_BALANCE = 201;
  static const int ERROR_OTHER = 219;

  int status;
  String message;

  BaseResponse({this.status, this.message});

  bool isSuccess() {
    return status == 1;
  }

  BaseResponse.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        message = json["message"];
}

class ResultStatisticResponse extends BaseResponse {
  int user_better_count;
  int user_worse_count;
  int user_equal_count;
  int best_count;
  double best_point;
  List<dynamic> array_user_best;

  ResultStatisticResponse.fromJson(Map<String, dynamic> json)
      : user_better_count = json["data"]["user_better_count"],
        user_worse_count = json["data"]["user_worse_count"],
        user_equal_count = json["data"]["user_equal_count"],
        best_count = json["data"]["best_count"],
        best_point = json["data"]["best_point"].toDouble(),
        array_user_best = json["data"]["array_user_best"];
}
