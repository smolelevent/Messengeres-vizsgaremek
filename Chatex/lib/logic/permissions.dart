import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:developer';

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

//ez a Dart azért felel hogy a felhasználó minden funkcióhoz hozzáférhessen és használhassa,
//de ezekhez engedélyeket kell adni! (értesítések, letöltések) Így az engedélykérést látja el a permissions.dart

//EGYÉB METÓDUSOK ELEJE ---------------------------------------------------------------------------

Future<int> _getAndroidSdkVer() async {
  //ez felel a verzió lekéréséért!
  try {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.sdkInt;
  } catch (e) {
    log("Nem sikerült lekérni az Android SDK verziót: ${e.toString()}");
    return 0;
  }
}

//ha az engedély meg van tagadva, akkor az engedély típusát átadva toast üzenetet jelenítünk meg
void _showToastWhenDenied(BuildContext context, String typeOfPermission) {
  ToastMessages.showToastMessages(
    Preferences.isHungarian
        ? "A $typeOfPermission használatához\nengedély szükséges!"
        : "Permission required for $typeOfPermission!",
    0.3,
    Colors.redAccent,
    Icons.warning_rounded,
    Colors.black,
    const Duration(seconds: 3),
    context,
  );
}

//ha az engedély le van tiltva, akkor is így járunk el csak más üzenettel
void _showToastWhenPermanentlyDenied(
    BuildContext context, String typeOfPermission) {
  ToastMessages.showToastMessages(
    Preferences.isHungarian
        ? "A(z) $typeOfPermission engedély tiltva van!\nÁtírányítás a beállításokba..."
        : "The $typeOfPermission permission is denied!\nRedirecting to the settings...",
    0.3,
    Colors.redAccent,
    Icons.warning_rounded,
    Colors.black,
    const Duration(seconds: 3),
    context,
  );
}

//EGYÉB METÓDUSOK VÉGE ----------------------------------------------------------------------------

//ENGEDÉLYT KÉRŐ METÓDUSOK ELEJE ------------------------------------------------------------------

//értesítésekhez szükséges engedély (Android 13+)
Future<void> requestNotificationPermission(BuildContext context) async {
  //ez a metódus engedélyt kér az értesítések fogadásához
  final notificationPermissionStatus = await Permission.notification.status;

  if (notificationPermissionStatus.isPermanentlyDenied) {
    //ha a telefon beállításaiban már le van tíltva a Chatex értesítés küldése akkor ez történik:
    _showToastWhenPermanentlyDenied(
        context, Preferences.isHungarian ? "értesítések" : "notifications");
    await Future.delayed(const Duration(seconds: 4));
    openAppSettings(); //toast üzenet után nyissa meg az alkalmazás beállításait a telefonon
    return;
  }

  //ha viszont nem történt ilyen akkor kérjen engedélyt
  final notificationUsageRequest = await Permission.notification.request();
  if (!notificationUsageRequest.isGranted) {
    //ha az engedély lelett tiltva akkor ezt a választ adja vissza a felhasználónak
    _showToastWhenDenied(
        context, Preferences.isHungarian ? "értesítések" : "notifications");
  }
}

//letöltésekhez szükséges engedély
//(Android 10 és alatta, mivel Android 11-től már "Scoped Storage" néven kezelik a telefonok amihez nem kell engedélyt adni)
Future<void> requestDownloadPermission(BuildContext context) async {
  //lekérjük az android verziót device_info_plus csomaggal
  final androidVersion = await _getAndroidSdkVer();

  //ne csináljon semmit ha a legalább eléri a 30-as api-t
  if (androidVersion >= 30) {
    log("Scoped storage használata, nincs szükség engedélyre! (letöltés miatt)");
    return;
  }

  final storagePermissionStatus = await Permission.storage.status;
  if (storagePermissionStatus.isGranted) return;

  if (storagePermissionStatus.isPermanentlyDenied) {
    _showToastWhenPermanentlyDenied(
        context, Preferences.isHungarian ? "letöltés" : "download");
    await Future.delayed(const Duration(seconds: 4));
    openAppSettings(); //ismét megnyitjuk a beállítását az alkalmazásnak
    return;
  }

  //Első kérés előtt tájékoztatjuk a felhasználót,
  _showToastWhenDenied(
      context, Preferences.isHungarian ? "letöltés" : "download");
  await Future.delayed(const Duration(seconds: 4));

  //majd kérést indítunk!
  final storageUsageRequest = await Permission.storage.request();
  if (!storageUsageRequest.isGranted) {
    _showToastWhenDenied(
        context, Preferences.isHungarian ? "letöltés" : "download");
  }
}

//ENGEDÉLYT KÉRŐ METÓDUSOK VÉGE -------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
