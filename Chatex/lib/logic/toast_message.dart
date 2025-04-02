import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessages {
  static final FToast _fToastInstance = FToast();

  // Inicializálás, ezt csak egyszer kell meghívni!
  static void init(BuildContext context) {
    _fToastInstance.init(context);
  }

  static void showToastMessages(
    String message,
    double verticalPercentage,
    Color bgColor,
    IconData icon,
    Color iconColor,
    Duration duration,
    BuildContext context, {
    double? leftPercentage,
    double? rightPercentage,
    bool center = true,
  }) {
    if (!context.mounted) return;
    final fToast = FToast();
    fToast.init(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        return Positioned(
          bottom: screenHeight * verticalPercentage,
          left: center
              ? 0
              : (leftPercentage != null ? screenWidth * leftPercentage : null),
          right: center
              ? 0
              : (rightPercentage != null
                  ? screenWidth * rightPercentage
                  : null),
          child: center ? Center(child: child) : child,
        );
      },
    );
  }
}
