import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _prefs;

  // Inicializálás (ezt a main.dart-ban egyszer kell meghívni)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- PREFERENCES GETTEREK ÉS SETTEREK ---

  static Future<void> setPreferredLanguage(String language) async {
    await _prefs?.setString('preferred_lang', language);
  }

  static String getPreferredLanguage() {
    return _prefs?.getString('preferred_lang') ?? 'magyar';
  }

  static Future<void> setUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  static String getUsername() {
    return _prefs?.getString('username') ?? '';
  }

  static Future<void> setToken(String token) async {
    await _prefs?.setString('jwt_token', token);
  }

  static String getToken() {
    return _prefs?.getString('jwt_token') ?? '';
  }

  // Adatok törlése (például kijelentkezéskor)
  static Future<void> clearPreferences() async {
    await _prefs?.clear();
  }
}
