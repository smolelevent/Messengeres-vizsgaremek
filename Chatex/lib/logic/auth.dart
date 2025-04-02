import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/application/chat/build_ui.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/main.dart';
import 'dart:developer';
import 'dart:convert';

class AuthService {
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
        //final username = responseData['username'];
        //final email = responseData['email'];
        //final passwordHash = responseData['password_hash'];
        final preferredlang = responseData['preferred_lang'];

        //await Preferences.setUsername(username);
        //await Preferences.setEmail(email);
        //await Preferences.setPasswordHash(passwordHash);
        await Preferences.setPreferredLanguage(preferredlang);
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Sikeres regisztráció!"
              : "Successful registration!",
          0.1,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginUI(),
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
          const Duration(seconds: 2),
          context,
        );
      } else if (responseData["message"] == "Érvénytelen email cím!") {
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Érvénytelen email cím!"
              : "Invalid email address!",
          0.1,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        language == "Magyar" ? "Kapcsolati hiba!" : "Connection error!",
        0.1,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
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
        final preferredlang = responseData['preferred_lang'];
        final profilePicture = responseData['profile_picture'];
        final username = responseData['username'];
        final email = responseData['email'];
        final passwordHash = responseData['password_hash'];
        final token = responseData['token'];
        final status = responseData['status'];

        await Preferences.setUserId(userId);
        await Preferences.setPreferredLanguage(preferredlang);
        await Preferences.setProfilePicture(profilePicture);
        await Preferences.setUsername(username);
        await Preferences.setEmail(email);
        await Preferences.setPasswordHash(passwordHash);
        await Preferences.setToken(token);
        await Preferences.setStatus(status);
        ToastMessages.showToastMessages(
          language == "Magyar" ? "Sikeres bejelentkezés!" : "Successful login!",
          0.22,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );

        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatUI(),
          ),
        );
      } else if (responseData['message'] == 'Hibás email vagy jelszó!') {
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Hibás email vagy jelszó!"
              : "Incorrect email or password!",
          0.22,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else {
        ToastMessages.showToastMessages(
          language == "Magyar"
              ? "Hiba kód: ${response.statusCode}"
              : "Error code: ${response.statusCode}",
          0.22,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        language == "Magyar" ? "Kapcsolati hiba!" : "Connection error!",
        0.22,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log(e.toString());
    }
  }

//logOut logika --------------------------------------------------------------
  Future<void> logOut({required BuildContext context}) async {
    final userId = Preferences.getUserId();

    try {
      final Uri logoutUrl = Uri.parse(
          'http://10.0.2.2/ChatexProject/chatex_phps/auth/logout.php');
      final response = await http.post(
        logoutUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      final responseData = json.decode(response.body);

      if (responseData["success"] == true) {
        await Future.delayed(const Duration(seconds: 2));
        await Preferences.clearPreferences(); //TODO: NEM SZABAD
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginUI()),
          );
        }
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Kapcsolati hiba!"
            : "Connection error!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
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
          const Duration(seconds: 2),
          context,
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginUI(),
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
          const Duration(seconds: 2),
          context,
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
          const Duration(seconds: 2),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        language == "Magyar" ? "Kapcsolati hiba!" : "Connection error!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log(e.toString());
    }
  }
}
