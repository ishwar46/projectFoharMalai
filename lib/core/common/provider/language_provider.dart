import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String languageCodeKey = 'languageCode';

  Future<void> saveLanguageCode(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageCodeKey, languageCode);
  }

  Future<String?> getSavedLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageCodeKey);
  }
}
