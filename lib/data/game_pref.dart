import 'package:shared_preferences/shared_preferences.dart';

class GamePref {
  static SharedPreferences? _prefs;
  static const String _gameKey = 'gameKey';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future saveGameData(String score) async {
    await _prefs!.setString(_gameKey, score);
  }

  static String getGameData() {
    return _prefs!.getString(_gameKey) ?? 'No BestTime';
  }
}
