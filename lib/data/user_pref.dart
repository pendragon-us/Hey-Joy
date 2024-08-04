import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  static SharedPreferences? _prefs;
  static const String _keyNote = 'note';
  static const String _keyImage = 'image';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future setNote (String note) async {
    await _prefs!.setString(_keyNote, note);
  }

  static String getNote() {
    return _prefs!.getString(_keyNote) ?? '';
  }

  static Future setImage(String img) async {
    await _prefs!.setString(_keyImage, img);
  }

  static String getImage() {
    return _prefs!.getString(_keyImage) ?? 'images/pics/woman1.png';
  }
}
