import 'package:chatex/chat.dart';
import 'package:chatex/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  //final FirebaseFirestore _databaseInstance = FirebaseFirestore.instance;
  late FToast fToastInstance;

// Future<bool> isEmailRegistered(String email) async {
//   try {
//     final SignInMethods = await _auth.fetchSignInMethodsForEmail(email);
//   }
// }

  Future<void> register(
      {required TextEditingController email,
      required TextEditingController password,
      required context}) async {
    try {
      // final QuerySnapshot result = await _databaseInstance
      //     .collection('users')
      //     .where('email', isEqualTo: email.text.trim())
      //     .get();

      // if (result.docs.isNotEmpty) {
      //   print("van ilyen");
      // }

      await _authInstance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // await _databaseInstance
      //     .collection('users')
      //     .doc(_authInstance.currentUser?.uid)
      //     .set({
      //   'email': email.text.trim(),
      //   'password': password.text.trim(),
      //   'uid': _authInstance.currentUser!.uid,
      // });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChatUI(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "Ez az email cím már használatban van.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        //TODO: megnézni az összes hiba lehetőséget és le kezelni a doksin
        message = 'Hiba történt: $e';
        print(message);
      }
    }
  }

  Future<void> logIn(
      {required TextEditingController email,
      required TextEditingController password,
      required context}) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChatUI(),
        ),
      );
    } on FirebaseAuthException catch (e) {
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
    }
  }

  Future<void> logOut({required context}) async {
    await _authInstance.signOut();
    await Future.delayed(const Duration(seconds: 1)); //kell loading
    if (context.mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginUI()));
    }
  }
}
