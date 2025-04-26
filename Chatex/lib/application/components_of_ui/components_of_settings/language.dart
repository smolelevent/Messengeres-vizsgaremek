import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:developer';
import 'dart:convert';

//LanguageSetting OSZTÁLY ELEJE -------------------------------------------------------------------
class LanguageSetting extends StatefulWidget {
  const LanguageSetting({super.key});

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //azért szükséges mert megjelenítünk egy pipát amelyik éppen ki van választva
  String _selectedLanguage = Preferences.getPreferredLanguage();

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  Future<void> _saveLanguage(BuildContext context, String language) async {
    //ezzel a metódussal mind lokálisan, mind az adatbázisban (következő bejelentkezéskor is) elmentjük a nyelvet
    await Preferences.setPreferredLanguage(language);

    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/settings/language/update_language.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
          "language": language,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["success"] == true) {
        //megjelenítjük a pipát, és a felhasználónak visszajelzést, ha sikeres volt
        _selectedLanguage = language;
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "A nyelv sikeresen frissítve!"
              : "Updating language was successful!",
          0.2,
          Colors.green,
          Icons.check_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt a\nnyelv frissítése közben!"
              : "Error while\nupdating language!",
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nnyelv frissítése közben!"
            : "Connection error while\nupdating language!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a nyelv frissítésekor! ${e.toString()}");
    }

    if (context.mounted) {
      //Visszaadjuk a választott nyelvet
      Navigator.pop(context, language);
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(),
        backgroundColor: Colors.grey[850],
        body: ListView(
          //tekerhető, mert a jövőben lehet annyi hogy nem fér ki
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          children: [
            _buildLanguageOption(context, "Magyar", "assets/flags/hungary.svg"),
            _buildLanguageOption(context, "English", "assets/flags/uk.svg"),
          ],
        ),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.isHungarian ? "Nyelvek" : "Languages",
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 10,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String language, String flagPath) {
    //megjeleníti a választható nyelveket
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        leading: SvgPicture.asset(
          flagPath,
          width: 60,
          height: 60,
        ),
        title: Text(
          language,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: _selectedLanguage == language
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : null,
        onTap: () async {
          //koppintásra elmenti a változtatást, és onnantól azon a nyelven lesz az alkalmazás
          await _saveLanguage(context, language);
        },
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//LanguageSetting OSZTÁLY VÉGE --------------------------------------------------------------------
