import 'package:shared_preferences/shared_preferences.dart';

class ShareValueProvider {
  final String _currentLevel = "current_level";

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

}
