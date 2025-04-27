import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//TESZTELÉSHEZ SZÜKSÉGES

class ToastService {
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }
}
