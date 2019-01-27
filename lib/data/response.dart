
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
