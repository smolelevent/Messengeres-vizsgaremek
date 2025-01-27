import 'package:chatex/Homepage.dart';
import 'package:chatex/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(
      //saját method
      {required TextEditingController email,
      required TextEditingController password,
      required context}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "an account already exists for that email.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "The password provided is too weak.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        //TODO: megnézni az összes hiba lehetőséget és le kezelni
        message = 'Hiba történt: $e';
        print(message);
      }
    }
  }

  //nem sajátok (copy paste)
  Future<void> signup(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "The password provided is too weak.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "an account already exists for that email.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    }
  }

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context.mounted) {
        //TODO: Don't use 'BuildContext's across async gaps. <- emiatt kell ez a kód, és nincs warning
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          ),
        );
      }
      // Navigate to home page or perform other actions on successful sign-in
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        Fluttertoast.showToast(
          msg: "no user found for that email.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else if (e.code == 'invalid-credential') {
        Fluttertoast.showToast(
          msg: "Wrong password provided for that email.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginUI()));
    }
  }
}
