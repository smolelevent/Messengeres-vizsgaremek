import 'package:chatex/chat/chat_build_ui.dart';
import 'package:chatex/main.dart';
import 'package:flutter/material.dart';
import 'dart:developer'; //log miatt
import 'dart:convert'; //json kódolás miatt
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatex/chat/toast_message.dart';

class AuthService {
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

      final responseData = jsonDecode(response.body);
      if (responseData["message"] == "Sikeres regisztráció!") {
        // Sikeres regisztráció
        ToastMessages.showToastMessages(
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
      } else if (responseData["message"] ==
          "Ezzel az emailel már létezik felhasználó!") {
        ToastMessages.showToastMessages(
            //TODO: nem megfelelő logika mert megkéne nézni hogy tényleg vagy csak egy másik adattal
            "Ezzel az emailel már létezik felhasználó!",
            0.1,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else if (responseData["message"] == "Érvénytelen email cím!") {
        ToastMessages.showToastMessages(
            "Érvénytelen email cím!",
            0.1,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      //TODO: 73 és 50 másodperc volt a hibakód kiíratása amikor nem ment a szerver és úgy próbált meg valaki regisztrálni
      ToastMessages.showToastMessages("Kapcsolati hiba!", 0.1, Colors.redAccent,
          Icons.error, Colors.black, const Duration(seconds: 2));
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

//TODO: token emailbe vagy valahogy elküldeni a felhasználónak idk nem tudom mit csinál
      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        int userId = responseData['id']; // ID lekérése
        final prefs = await SharedPreferences
            .getInstance(); // Elmentjük a bejelentkezett user ID-ját
        await prefs.setInt('id', userId);
        ToastMessages.showToastMessages(
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
      } else if (responseData['message'] == 'Hibás email vagy jelszó!') {
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
            "Hiba kód: ${response.statusCode}",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      ToastMessages.showToastMessages("Kapcsolati hiba!", 0.2, Colors.redAccent,
          Icons.error, Colors.black, const Duration(seconds: 2));
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

      final responseData = jsonDecode(response.body);
      if (responseData["message"] == "Helyreállító e-mail elküldve.") {
        ToastMessages.showToastMessages(
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
        //TODO: megfelelőket lekezelni, lehet hogy az adat alapján kéne nem a status kód alapján azt csak mondjuk az exceptionba, else ágba
      } else if (responseData["message"] ==
          "Nincs ilyen email című felhasználó!") {
        ToastMessages.showToastMessages(
            "Nincs ilyen email című felhasználó!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else {
        ToastMessages.showToastMessages(
            "Hiba kód: ${response.statusCode}",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      }
    } catch (e) {
      ToastMessages.showToastMessages("Kapcsolati hiba!", 0.2, Colors.redAccent,
          Icons.error, Colors.black, const Duration(seconds: 2));
      log(e.toString());
    }
  }
}
