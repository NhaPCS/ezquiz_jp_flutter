import 'package:shared_preferences/shared_preferences.dart';

class ShareValueProvider {
  final String _currentLevel = "current_level";
  final String _api_url = "api_url";

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
    String rs = shareValueProvider.getString(_api_url);
    return rs;
  }

  void saveApiUrl(String url) async {
    final shareValueProvider = await SharedPreferences.getInstance();
    shareValueProvider.setString(_api_url, url);
  }
}
