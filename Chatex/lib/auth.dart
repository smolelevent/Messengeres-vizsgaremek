import 'package:chatex/chat/chat.dart';
import 'package:chatex/main.dart';
import 'package:flutter/material.dart';
import 'dart:developer'; //log miatt
import 'dart:convert'; //json kódolás miatt
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatex/chat/toast_message.dart';

class AuthService {
  final ToastMessages _toastMessagesInstance = ToastMessages();

  // static const String serverUrl = //TODO: megoldani hogy rendes telefonon fusson
  //     bool.fromEnvironment('dart.vm.product') // Éles build esetén
  //         ? 'http://10.0.2.2' // Éles szerver
  //         : 'http://10.0.2.2'; // Fejlesztési szerver (emulátor)

//register logika --------------------------------------------------------------
  Future<void> register(
      {required TextEditingController username,
      required TextEditingController email,
      required TextEditingController password,
      required context}) async {
    try {
      final Uri registrationUrl = Uri.parse(
          'http://10.0.2.2/ChatexProject/chatex_phps/auth/register.php');
      final response = await http.post(
        registrationUrl,
        body: jsonEncode(<String, String>{
          'username': username.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
        }),
      );

      log(response.statusCode.toString());
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Sikeres regisztráció
        _toastMessagesInstance.showToastMessages(
            "Sikeres regisztráció!",
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
      } else if (response.statusCode == 409) {
        // Felhasználó már létezik, Conflict = hiba kód
        _toastMessagesInstance.showToastMessages(
            //TODO: nem megfelelő logika mert megkéne nézni hogy tényleg vagy csak egy másik adattal
            "Ezzel az emailel már létezik felhasználó!",
            0.1,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else if (response.statusCode == 400) {
        _toastMessagesInstance.showToastMessages(
            "Nem megfelelő kérés! Hiba kód: ${response.statusCode}",
            0.1,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else if (response.statusCode == 404) {
        _toastMessagesInstance.showToastMessages(
            "Elérési hiba! Hiba kód: ${response.statusCode}",
            0.1,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      //TODO: 73 és 50 másodperc volt a hibakód kiíratása amikor nem ment a szerver és úgy próbált meg valaki regisztrálni
      _toastMessagesInstance.showToastMessages(
          "Kapcsolati hiba!",
          0.1,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
      log(e.toString());
    }
  }

//logIn logika --------------------------------------------------------------
  Future<void> logIn(
      {required TextEditingController email,
      required TextEditingController password,
      required context}) async {
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
      log("eddig jó");
      log(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(
            response.body); //vissza kell adni a válaszba azt hogy success
        if (responseData['success'] == true) {
          int userId = responseData['id']; // ID lekérése
          log(userId.toString());
          // Elmentjük a bejelentkezett user ID-ját
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('id', userId);
          _toastMessagesInstance.showToastMessages(
              "Sikeres bejelentkezés!",
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
        } else {
          log("hibás adat!");
        }
        //TODO: token emailbe vagy valahogy elküldeni a felhasználónak idk nem tudom mit csinál
      } else if (response.statusCode == 401) {
        // nem megfelelő adatok
        _toastMessagesInstance.showToastMessages(
            "Hibás email vagy jelszó!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else {
        _toastMessagesInstance.showToastMessages(
            "Hiba kód: ${response.statusCode}",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      _toastMessagesInstance.showToastMessages(
          "Kapcsolati hiba!",
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

//forgotPassword logika --------------------------------------------------------------
  Future<void> forgotPassword(
      {required TextEditingController email, required context}) async {
    try {
      final Uri forgotPasswordUrl = Uri.parse(
          'http://10.0.2.2/ChatexProject/chatex_phps/reset_password/reset_password.php');
      final response = await http.post(
        forgotPasswordUrl,
        body: jsonEncode(<String, String>{
          'email': email.text.trim(),
        }),
      );

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        _toastMessagesInstance.showToastMessages(
            "A jelszó helyreállító emailt elküldtük!",
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
        //TODO: megfelelőket lekezelni
      } else if (response.statusCode == 401) {
        _toastMessagesInstance.showToastMessages(
            "Hibás email vagy jelszó!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else {
        _toastMessagesInstance.showToastMessages(
            "Hiba kód: ${response.statusCode}",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      _toastMessagesInstance.showToastMessages(
          "Kapcsolati hiba!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
      log(e.toString());
    }
  }
}
