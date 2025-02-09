import 'package:chatex/chat.dart';
import 'package:chatex/main.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer'; //log miatt

import 'package:http/http.dart' as http;
import 'dart:convert';

class ToastMessages {
  FToast fToastInstance = FToast();

  void showToastMessages(String message, double percentage) {
    fToastInstance.init(flutterToastKey.currentContext!);
    fToastInstance.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.redAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: Colors.black,
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(message),
          ],
        ),
      ),
      //gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
      positionedToastBuilder: (context, child, gravity) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Positioned(
          bottom: screenHeight * percentage,
          left: 0,
          right: 0,
          child: Center(child: child),
        );
      },
    );
  }
}

class AuthService {
  //final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final ToastMessages _toastMessagesInstance = ToastMessages();

  // static const String serverUrl =
  //     bool.fromEnvironment('dart.vm.product') // Éles build esetén
  //         ? 'http://10.0.2.2' // Éles szerver
  //         : 'http://10.0.2.2'; // Fejlesztési szerver (emulátor)

  Future<void> register(
      {required TextEditingController username,
      required TextEditingController email,
      required TextEditingController password,
      required context}) async {
    final Uri registrationUrl =
        Uri.parse('http://10.0.2.2/ChatexProject/chatex_phps/register.php');
    try {
      final response = await http.post(
        registrationUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        // Sikeres regisztráció
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChatUI(),
          ),
        );
      } else {
        // Hiba történt
        _toastMessagesInstance.showToastMessages(
            "Hiba kód: ${response.statusCode}", 0.1);
      }
    } catch (e) {
      // Kapcsolati hiba
      _toastMessagesInstance.showToastMessages("Kapcsolati hiba!", 0.1);
      log(e.toString());
    }
  }
}

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