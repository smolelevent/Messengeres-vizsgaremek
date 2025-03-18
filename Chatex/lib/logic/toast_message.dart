import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessages {
  static final FToast _fToastInstance = FToast();

  /// Inicializálás, ezt csak egyszer kell meghívni!
  static void init(BuildContext context) {
    _fToastInstance.init(context);
  }

  /// Toast üzenet megjelenítése
  static void showToastMessages(
      String message,
      double whereToPercentage,
      Color bgColor,
      IconData icon,
      Color iconColor,
      Duration duration,
      BuildContext context) {
    final fToast = FToast();
    fToast.init(context);
    _fToastInstance.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: bgColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12.0),
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
