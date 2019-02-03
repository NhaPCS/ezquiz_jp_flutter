import 'package:ezquiz_flutter/model/device_token.dart';

class User {
  String avatar_url;
  Map<String, DeviceToken> deviceID;
  String display_name;
  String email;
  String level_id;
  int coin = 0;
  String birthday;
  String school;
  String description;
  String id;

  User.fromJson(var map) {
    print("USER $map");
    id = map["id"];
    avatar_url = map["avatar_url"];
    display_name = map["display_name"];
    email = map["email"];
    level_id = map["level_id"];
    coin = map["coin"];
    birthday = map["birthday"];
    school = map["school"];
    description = map["description"];
    deviceID = map["deviceID"];
  }

  String toJson() {
    return {
      "id": id,
      "avatar_url": avatar_url,
      "display_name": display_name,
      "email": email,
      "level_id": level_id,
      "coin": coin,
      "birthday": birthday,
      "school": school,
      "description": description,
      "deviceID": deviceID
    }.toString();
  }
}
