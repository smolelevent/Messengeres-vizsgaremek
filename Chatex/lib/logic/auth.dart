import 'package:chatex/chat/chat_build_ui.dart';
import 'package:chatex/main.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
//import '../utils/toast_service.dart';

class AuthService {
  // static const String serverUrl = //TODO: megoldani hogy rendes telefonon fusson
  //     bool.fromEnvironment('dart.vm.product') // Éles build esetén
  //         ? 'http://10.0.2.2' // Éles szerver
  //         : 'http://10.0.2.2'; // Fejlesztési szerver (emulátor)

//register logika --------------------------------------------------------------
  Future<void> register({
    required TextEditingController username,
    required TextEditingController email,
    required TextEditingController password,
    required context,
    required String language,
  }) async {
    try {
      final Uri registrationUrl = Uri.parse(
          'http://10.0.2.2/ChatexProject/chatex_phps/auth/register.php');
      final response = await http.post(
        registrationUrl,
        body: jsonEncode(<String, String>{
          'username': username.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
          'language': language,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["message"] == "Sikeres regisztráció!") {
        ToastMessages.showToastMessages(
            language == "Magyar"
                ? "Sikeres regisztráció!"
                : "Successful registration!",
            0.1,
            Colors.green,
            Icons.check,
            Colors.black,
            const Duration(seconds: 2));
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginUI(),
          ),
        );
      } else if (responseData["message"] ==
          "Ezzel az emailel már létezik felhasználó!") {
        ToastMessages.showToastMessages(
            language == "Magyar"
                ? "Ezzel az emailel már létezik felhasználó!"
                : "User already exists with this email!",
            0.1,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else if (responseData["message"] == "Érvénytelen email cím!") {
        ToastMessages.showToastMessages(
            language == "Magyar"
                ? "Érvénytelen email cím!"
                : "Invalid email address!",
            0.1,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      ToastMessages.showToastMessages(
          language == "Magyar" ? "Kapcsolati hiba!" : "Connection error!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
      log(e.toString());
    }
  }

//logIn logika --------------------------------------------------------------
  Future<void> logIn({
    required TextEditingController email,
    required TextEditingController password,
    required context,
    required String language,
  }) async {
    try {
      final Uri loginUrl =
          Uri.parse('http://10.0.2.2/ChatexProject/chatex_phps/auth/login.php');
      final response = await http.post(
        loginUrl,
        body: jsonEncode(<String, String>{
          'email': email.text.trim(),
          'password': password.text.trim(),
        }),
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final userId = responseData['id'];
        final token = responseData['token'];
        final preferredlang = responseData['preferred_lang'];
        final email = responseData['email'];
        final passwordHash = responseData['password_hash'];
        final profilePicture = responseData['profile_picture'];

        await Preferences.setUserId(userId);
        await Preferences.setToken(token);
        await Preferences.setPreferredLanguage(preferredlang);
        await Preferences.setEmail(email);
        await Preferences.setPasswordHash(passwordHash);
        await Preferences.setProfilePicture(profilePicture);
        ToastMessages.showToastMessages(
            language == "Magyar"
                ? "Sikeres bejelentkezés!"
                : "Successful login!",
            0.2,
            Colors.green,
            Icons.check,
            Colors.black,
            const Duration(seconds: 2));
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChatUI(),
          ),
        );
      } else if (responseData['message'] == 'Hibás email vagy jelszó!') {
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Hibás email vagy jelszó!"
              : "Incorrect email or password!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
        );
      } else {
        ToastMessages.showToastMessages(
            language == "Magyar"
                ? "Hiba kód: ${response.statusCode}"
                : "Error code: ${response.statusCode}",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      ToastMessages.showToastMessages(
          language == "Magyar" ? "Kapcsolati hiba!" : "Connection error!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
      log(e.toString());
    }
  }

//logOut logika --------------------------------------------------------------
  Future<void> logOut({required context}) async {
    await Future.delayed(const Duration(seconds: 1)); //TODO: kell loading
    if (context.mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginUI()));
    }
  }

//resetPassword logika --------------------------------------------------------------
  Future<void> resetPassword(
      {required TextEditingController email,
      required context,
      required language}) async {
    try {
      final Uri forgotPasswordUrl = Uri.parse(
          'http://10.0.2.2/ChatexProject/chatex_phps/reset_password/reset_password.php');
      final response = await http.post(
        forgotPasswordUrl,
        body: jsonEncode(<String, String>{
          'email': email.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);
      if (responseData["message"] == "Helyreállító e-mail elküldve.") {
        ToastMessages.showToastMessages(
            language == "Magyar"
                ? "A jelszó helyreállító emailt elküldtük!"
                : "Password recovery email sent!",
            0.2,
            Colors.green,
            Icons.check,
            Colors.black,
            const Duration(seconds: 2));
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginUI(),
          ),
        );
      } else if (responseData["message"] ==
          "Nincs ilyen email című felhasználó!") {
        ToastMessages.showToastMessages(
            language == "Magyar"
                ? "Nincs ilyen email című felhasználó!"
                : "No user with this email address!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else {
        ToastMessages.showToastMessages(
            language == "Magyar"
                ? "Hiba kód: ${response.statusCode}"
                : "Error code: ${response.statusCode}",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      ToastMessages.showToastMessages(
          language == "Magyar" ? "Kapcsolati hiba!" : "Connection error!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
      log(e.toString());
    }
  }
}
