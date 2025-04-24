import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chatex/logic/preferences.dart';

import 'package:chatex/logic/toast_message.dart';
import 'dart:developer';


// Értesítésekhez szükséges engedély (Android 13+)
Future<void> requestNotificationPermission(BuildContext context) async {
  final notificationPermissionStatus = await Permission.notification.status;

  if (notificationPermissionStatus.isPermanentlyDenied) {
    _showToastWhenPermanentlyDenied(
        context, Preferences.isHungarian ? "értesítések" : "Notifications");
    await Future.delayed(const Duration(seconds: 4));
    openAppSettings();
    return;
  }

  final notificationUsageRequest = await Permission.notification.request();
  if (!notificationUsageRequest.isGranted) {
    _showToastWhenDenied(
        context, Preferences.isHungarian ? "értesítések" : "notifications");
  }
}

// Letöltésekhez szükséges engedély (Android 10 és alatt)
Future<void> requestDownloadPermission(BuildContext context) async {
  final androidVersion = await _getAndroidSdkVer();

// Scoped Storage (Android 11+): nincs szükség plusz engedélyre
  if (androidVersion >= 30) {
    log("Scoped storage no need for permission");
    return;
  }

  final storagePermissionStatus = await Permission.storage.status;
  if (storagePermissionStatus.isGranted) return;

  if (storagePermissionStatus.isPermanentlyDenied) {
    _showToastWhenPermanentlyDenied(
        context, Preferences.isHungarian ? "letöltés" : "Download");
    await Future.delayed(const Duration(seconds: 4));
    openAppSettings();
    return;
  }

// Első kérés előtt tájékoztatjuk
  _showToastWhenDenied(context, Preferences.isHungarian ? "letöltés" : "download");
  await Future.delayed(const Duration(seconds: 4));

  final storageUsageRequest = await Permission.storage.request();
  if (!storageUsageRequest.isGranted) {
    _showToastWhenDenied(context, Preferences.isHungarian ? "letöltés" : "download");
  }
}

Future<int> _getAndroidSdkVer() async {
  try {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.sdkInt;
  } catch (e) {
    log("Nem sikerült lekérni az Android SDK verziót: $e");
    return 0;
  }
}

//ha az engedély megvan tagadva
void _showToastWhenDenied(BuildContext context, String typeOfPermission) {
  ToastMessages.showToastMessages(
    Preferences.isHungarian
        ? "A $typeOfPermission használatához\nengedély szükséges!"
        : "Permission required for $typeOfPermission!",
    0.3,
    Colors.redAccent,
    Icons.warning,
    Colors.black,
    const Duration(seconds: 2),
    context,
  );
}

//ha az engedély levan tiltva
void _showToastWhenPermanentlyDenied(
    BuildContext context, String typeOfPermission) {
  ToastMessages.showToastMessages(
    Preferences.isHungarian
        ? "A(z) $typeOfPermission engedély tiltva van!\nÁtírányítás a beállításokba..."
        : "The $typeOfPermission permission is denied!\nRedirecting to the settings...",
    0.3,
    Colors.redAccent,
    Icons.warning,
    Colors.black,
    const Duration(seconds: 3),
    context,
  );
}
