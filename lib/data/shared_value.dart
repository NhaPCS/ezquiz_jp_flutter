import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezquiz_flutter/model/user.dart';

class ShareValueProvider {
  final String _currentLevel = "current_level";
  final String _apiUrl = "api_url";
  final String _userProfile = "user_profile";
  final String _deviceToken = "device_token";
  static User _currentUser;

  ShareValueProvider._();

  static final ShareValueProvider shareValueProvider = ShareValueProvider._();

  Future<String> getCurrentLevel() async {
    final shareValueProvider = await SharedPreferences.getInstance();
    String rs = shareValueProvider.getString(_currentLevel);
    return rs == null ? "n5" : rs;
  }

  void saveCurrentLevel(String level) async {
    final shareValueProvider = await SharedPreferences.getInstance();
    shareValueProvider.setString(_currentLevel, level.toLowerCase());
  }

  Future<String> getAPIUrl() async {
    final shareValueProvider = await SharedPreferences.getInstance();
    String rs = shareValueProvider.getString(_apiUrl);
    return rs;
  }

  void saveApiUrl(String url) async {
    final shareValueProvider = await SharedPreferences.getInstance();
    shareValueProvider.setString(_apiUrl, url);
  }

  void saveUserProfile(String user) async {
    final shareValueProvider = await SharedPreferences.getInstance();
    if (user == null) {
      shareValueProvider.remove(_userProfile);
    } else
      shareValueProvider.setString(_userProfile, user);
  }

  Future<User> getUserProfile() async {
    if (_currentUser != null)
      return _currentUser;
    else {
      final shareValueProvider = await SharedPreferences.getInstance();
      String json = shareValueProvider.getString(_userProfile);
      if (json != null) {
        _currentUser = User.fromJson(json);
        return _currentUser;
      } else
        return null;
    }
  }

  void saveDeviceToken(String deviceToken) async {
    final shareValueProvider = await SharedPreferences.getInstance();
    if (deviceToken != null)
      shareValueProvider.setString(_deviceToken, deviceToken);
  }

  Future<String> getDeviceToken() async {
    final shareValueProvider = await SharedPreferences.getInstance();
    return shareValueProvider.getString(_deviceToken);
  }
}
