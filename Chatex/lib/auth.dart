import 'package:chatex/chat.dart';
import 'package:chatex/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer'; //log miatt
import 'dart:convert'; //json kódolás miatt
import 'package:http/http.dart' as http;

class ToastMessages {
  FToast fToastInstance = FToast();

  void showToastMessages(String message, double whereToPercentage,
      Color bgcolor, IconData icon, Color iconcolor, Duration duration) {
    fToastInstance.init(flutterToastKey.currentContext!);
    fToastInstance.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: bgcolor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconcolor,
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(message),
          ],
        ),
      ),
      toastDuration: duration,
      positionedToastBuilder: (context, child, gravity) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Positioned(
          bottom: screenHeight * whereToPercentage,
          left: 0,
          right: 0,
          child: Center(child: child),
        );
      },
    );
  }
}

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
      final Uri registrationUrl =
          Uri.parse('http://10.0.2.2/ChatexProject/chatex_phps/register.php');
      final response = await http.post(
        registrationUrl,
        body: jsonEncode(<String, String>{
          'username': username.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
        }),
      );

      log(response.statusCode.toString());
      if (response.statusCode == 201) {
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
            "Nem megfelelő kérés!",
            0.1,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2));
      } else {
        _toastMessagesInstance.showToastMessages(
            "Hiba kód: ${response.statusCode}",
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
          Uri.parse('http://10.0.2.2/ChatexProject/chatex_phps/login.php');
      final response = await http.post(
        loginUrl,
        body: jsonEncode(<String, String>{
          'email': email.text.trim(),
          'password': password.text.trim(),
        }),
      );

      //final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //String token = data["token"];
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
}


//TODO: KÓD MENTÉS
// final FirebaseAuth _authInstance = FirebaseAuth.instance;
  // final ToastMessages _toastMessagesInstance = ToastMessages();

  // Future<void> register(
  //     {required TextEditingController email,
  //     required TextEditingController password,
  //     required context}) async {
  //   try {
  //     await _authInstance.createUserWithEmailAndPassword(
  //       email: email.text.trim(),
  //       password: password.text.trim(),
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => ChatUI(),
  //       ),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       _toastMessagesInstance.showToastMessages(
  //           "Az email cím már használatban van!", 0.1);
  //     } else if (e.code == 'operation-not-allowed') {
  //       _toastMessagesInstance.showToastMessages(
  //           "A regisztráció jelenleg nem elérhető!", 0.1);
  //     } else if (e.code == 'too-many-requests') {
  //       _toastMessagesInstance.showToastMessages(
  //           "Jelenleg túl sok kérésre válaszol a szerver. Várj egy kicsit!",
  //           0.1);
  //     } else if (e.code == 'user-token-expired') {
  //       _toastMessagesInstance.showToastMessages(
  //           "A felhasználó kijelentkeztetve mivel lejárt a Token-je!", 0.1);
  //     } else if (e.code == 'network-request-failed') {
  //       _toastMessagesInstance.showToastMessages(
  //           "Nem vagy hálózathoz csatlakoztatva!", 0.1);
  //     } else {
  //       log(e.code); //TODO: az email nézése hogy .com vagy mire végződik
  //     }
  //   }
  // }

  // Future<void> logIn(
  //     {required TextEditingController email,
  //     required TextEditingController password,
  //     required context}) async {
  //   try {
  //     await _authInstance.signInWithEmailAndPassword(
  //       email: email.text.trim(),
  //       password: password.text.trim(),
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => ChatUI(),
  //       ),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-disabled') {
  //       _toastMessagesInstance.showToastMessages(
  //           "A fiók törölve, vagy kikapcsolva!", 0.2);
  //     } else if (e.code == 'user-not-found') {
  //       _toastMessagesInstance.showToastMessages("A fiók nem található!", 0.2);
  //     } else if (e.code == 'wrong-password') {
  //       _toastMessagesInstance.showToastMessages(
  //           "Az email és a jelszó nem egyezik!", 0.2);
  //     } else if (e.code == 'too-many-requests') {
  //       _toastMessagesInstance.showToastMessages(
  //           "Túl sok kérés a bejelentkezéshez. Várj egy kicsit!", 0.2);
  //     } else if (e.code == 'user-token-expired') {
  //       _toastMessagesInstance.showToastMessages(
  //           "A felhasználó kijelentkeztetve mivel lejárt a Token-je!", 0.2);
  //     } else if (e.code == 'network-request-failed') {
  //       _toastMessagesInstance.showToastMessages(
  //           "Nem vagy hálózathoz csatlakoztatva!", 0.2);
  //     } else if (e.code == 'operation-not-allowed') {
  //       _toastMessagesInstance.showToastMessages(
  //           "A regisztráció jelenleg nem elérhető!", 0.2);
  //     } else if (e.code == 'invalid-credential') {
  //       _toastMessagesInstance.showToastMessages(
  //           "A megadott email jelszó párral nincs fiók!", 0.2);
  //     } else {
  //       log(e
  //           .code); //TODO: az email nézése hogy .com vagy mire végződik <- invalid-email
  //     }
  //   }
  // }

  // Future<void> logOut({required context}) async {
  //   await _authInstance.signOut();
  //   await Future.delayed(const Duration(seconds: 1)); //TODO: kell loading
  //   if (context.mounted) {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (BuildContext context) => LoginUI()));
  //   }
  // }