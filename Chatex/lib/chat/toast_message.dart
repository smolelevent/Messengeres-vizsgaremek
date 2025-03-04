import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chatex/main.dart';

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
