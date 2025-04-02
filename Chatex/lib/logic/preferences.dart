import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _prefs;
  static ValueNotifier<String> languageNotifier =
      ValueNotifier<String>("Magyar");

  // Inicializálás (ezt a main.dart-ban egyszer kell meghívni)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

//Setterek ----------------------------------------------------
  static Future<void> setPreferredLanguage(String language) async {
    await _prefs?.setString('preferred_lang', language);
    languageNotifier.value = language;
  }

  static Future<void> setUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  static Future<void> setToken(String token) async {
    await _prefs?.setString('jwt_token', token);
  }

  static Future<void> setUserId(int id) async {
    await _prefs?.setInt('id', id);
  }

  static Future<void> setEmail(String email) async {
    await _prefs?.setString('email', email);
  }

  static Future<void> setPasswordHash(String passwordHash) async {
    await _prefs?.setString('password_hash', passwordHash);
  }

  static Future<void> setProfilePicture(String profilePicture) async {
    await _prefs?.setString("profile_picture", profilePicture);
  }

  static Future<void> setStatus(String status) async {
    await _prefs?.setString("status", status);
  }

//Getterek ----------------------------------------------------
  static String getPreferredLanguage() {
    Future.microtask(() {
      languageNotifier.value = _prefs?.getString('preferred_lang') ?? 'Magyar';
    });
    return _prefs?.getString('preferred_lang') ?? 'Magyar';
  }

  static String getUsername() {
    return _prefs?.getString('username') ?? '';
  }

  static String getToken() {
    return _prefs?.getString('jwt_token') ?? '';
  }

  static int? getUserId() {
    return _prefs?.getInt('id');
  }

  static String? getEmail() {
    return _prefs?.getString('email');
  }

  static String? getPasswordHash() {
    return _prefs?.getString('password_hash');
  }

  static String? getProfilePicture() {
    return _prefs?.getString('profile_picture');
  }

  static String? getStatus() {
    return _prefs?.getString('status') ?? 'offline';
  }

//Egyéb ----------------------------------------------------
  static Future<void> clearPreferences() async {
    await _prefs?.clear();
  }
}
