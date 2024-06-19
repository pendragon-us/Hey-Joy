import 'package:shared_preferences/shared_preferences.dart';

class UserPref{
  static SharedPreferences? _prefs;
  static const String _key = 'note';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future setNote (String note) async {
    await _prefs!.setString(_key, note);
  }

  static String getNote() {
    return _prefs!.getString(_key) ?? '';
  }
}