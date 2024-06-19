import 'package:shared_preferences/shared_preferences.dart';

class MoodPref {
  static SharedPreferences? _prefs;
  static const String _moodKey = 'selectedIndex';
  static const String _quotesKey = 'quotes';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future saveMood(int index, List<String> quotes) async {
    await _prefs!.setInt(_moodKey, index);
    await _prefs!.setStringList(_quotesKey, quotes);
  }

  static int getMood() {
    return _prefs!.getInt(_moodKey) ?? 2; // Default to 2 if not set
  }

  static List<String> getQuotes() {
    return _prefs!.getStringList(_quotesKey) ?? [];
  }
}
