import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _prefs;

  // Inicializálás (ezt a main.dart-ban egyszer kell meghívni)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

//Setterek ----------------------------------------------------
  static Future<void> setPreferredLanguage(String language) async {
    await _prefs?.setString('preferred_lang', language);
  }

  static Future<void> setUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  static Future<void> setToken(String token) async {
    await _prefs?.setString('jwt_token', token);
  }

  // Felhasználó ID beállítása
  static Future<void> setUserId(int id) async {
    await _prefs?.setInt('id', id);
  }

  static Future<void> setEmail(String email) async {
    await _prefs?.setString('email', email);
  }

  static Future<void> setPasswordHash(String passwordHash) async {
    await _prefs?.setString('password_hash', passwordHash);
  }

//Getterek ----------------------------------------------------
  static String getPreferredLanguage() {
    return _prefs?.getString('preferred_lang') ?? 'Magyar';
  }

  static String getUsername() {
    return _prefs?.getString('username') ?? '';
  }

  static String getToken() {
    return _prefs?.getString('jwt_token') ?? '';
  }

  // Felhasználó ID lekérése
  static int? getUserId() {
    return _prefs?.getInt('id');
  }

  static String? getEmail() {
    return _prefs?.getString('email');
  }

  static String? getPasswordHash() {
    return _prefs?.getString('password_hash');
  }

//Egyéb ----------------------------------------------------
  // Adatok törlése (például kijelentkezéskor)
  static Future<void> clearPreferences() async {
    await _prefs?.clear();
  }
}
