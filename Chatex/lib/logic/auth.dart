import 'package:chatex/chat/chat_build_ui.dart';
import 'package:chatex/main.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';

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
        if (language == "magyar") {
          ToastMessages.showToastMessages(
              "Sikeres regisztráció!",
              0.1,
              Colors.green,
              Icons.check,
              Colors.black,
              const Duration(seconds: 2));
        } else {
          ToastMessages.showToastMessages(
              "Successful registration!",
              0.1,
              Colors.green,
              Icons.check,
              Colors.black,
              const Duration(seconds: 2));
        }
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginUI(),
          ),
        );
      } else if (responseData["message"] ==
          "Ezzel az emailel már létezik felhasználó!") {
        if (language == "magyar") {
          ToastMessages.showToastMessages(
              "Ezzel az emailel már létezik felhasználó!",
              0.1,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        } else {
          ToastMessages.showToastMessages(
              "User already exists with this email!",
              0.1,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        }
      } else if (responseData["message"] == "Érvénytelen email cím!") {
        if (language == "magyar") {
          ToastMessages.showToastMessages(
              "Érvénytelen email cím!",
              0.1,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        } else {
          ToastMessages.showToastMessages(
              "Invalid email address!",
              0.1,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        }
      }
    } catch (e) {
      if (language == "magyar") {
        ToastMessages.showToastMessages(
            "Kapcsolati hiba!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
        log(e.toString());
      } else {
        ToastMessages.showToastMessages(
            "Connection error!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
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

        await Preferences.setUserId(userId);
        await Preferences.setToken(token);
        await Preferences.setPreferredLanguage(preferredlang);
        await Preferences.setEmail(email);
        await Preferences.setPasswordHash(passwordHash);
        if (language == "magyar") {
          ToastMessages.showToastMessages(
              "Sikeres bejelentkezés!",
              0.2,
              Colors.green,
              Icons.check,
              Colors.black,
              const Duration(seconds: 2));
        } else {
          ToastMessages.showToastMessages(
              "Successful login!",
              0.2,
              Colors.green,
              Icons.check,
              Colors.black,
              const Duration(seconds: 2));
        }
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChatUI(),
          ),
        );
      } else if (responseData['message'] == 'Hibás email vagy jelszó!') {
        if (language == "magyar") {
          ToastMessages.showToastMessages(
            "Hibás email vagy jelszó!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2),
          );
        } else {
          ToastMessages.showToastMessages(
            "Incorrect email or password!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2),
          );
        }
      } else {
        if (language == "magyar") {
          ToastMessages.showToastMessages(
              "Hiba kód: ${response.statusCode}",
              0.2,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        } else {
          ToastMessages.showToastMessages(
              "Error code: ${response.statusCode}",
              0.2,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        }
      }
    } catch (e) {
      if (language == "magyar") {
        ToastMessages.showToastMessages(
            "Kapcsolati hiba!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
        log(e.toString());
      } else {
        ToastMessages.showToastMessages(
            "Connection error!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
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
        if (language == "magyar") {
          ToastMessages.showToastMessages(
              "A jelszó helyreállító emailt elküldtük!",
              0.2,
              Colors.green,
              Icons.check,
              Colors.black,
              const Duration(seconds: 2));
        } else {
          ToastMessages.showToastMessages(
              "Password recovery email sent!",
              0.2,
              Colors.green,
              Icons.check,
              Colors.black,
              const Duration(seconds: 2));
        }
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginUI(),
          ),
        );
      } else if (responseData["message"] ==
          "Nincs ilyen email című felhasználó!") {
        if (language == "magyar") {
          ToastMessages.showToastMessages(
              "Nincs ilyen email című felhasználó!",
              0.2,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        } else {
          ToastMessages.showToastMessages(
              "There is no user with this email address!",
              0.2,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        }
      } else {
        if (language == "magyar") {
          ToastMessages.showToastMessages(
              "Hiba kód: ${response.statusCode}",
              0.2,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        } else {
          ToastMessages.showToastMessages(
              "Error code: ${response.statusCode}",
              0.2,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2));
        }
      }
    } catch (e) {
      if (language == "magyar") {
        ToastMessages.showToastMessages(
            "Kapcsolati hiba!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
        log(e.toString());
      } else {
        ToastMessages.showToastMessages(
            "Connection error!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    }
  }
}
