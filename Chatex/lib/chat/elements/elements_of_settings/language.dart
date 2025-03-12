import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSetting extends StatefulWidget {
  const LanguageSetting({super.key});

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  String _selectedLanguage = "Magyar"; // Alapértelmezett nyelv

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // Nyelv betöltése SharedPreferences-ből
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString("language") ?? "Magyar";
    });
  }

  // Nyelv mentése
  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", language);
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(),
        backgroundColor: Colors.grey[850],
        body: ListView(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          children: [
            _buildLanguageOption(
                context, "Magyar", Svg('assets/flags/hungary.svg')),
            _buildLanguageOption(context, "Angol", Svg('assets/flags/uk.svg')),
          ],
        ),
      ),
    );
  }

  _buildAppbar() {
    return AppBar(
      title: const Text("Nyelv Beállítása"),
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language, Svg flag) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image(image: flag),
        title: Text(
          language,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: _selectedLanguage == language
            ? const Icon(Icons.check,
                color: Colors
                    .green) // ✅ Ha ez a kiválasztott nyelv, mutassa a pipát
            : null,
        onTap: () async {
          await _saveLanguage(language);
          Navigator.pop(
              context, language); // Visszaküldjük a kiválasztott nyelvet
        },
      ),
    );
  }
}

  // // @override
  // // Widget build(BuildContext context) {
  // //   return SafeArea(
  // //     child: Scaffold(
  // //       appBar: _buildAppbar(),
  // //       backgroundColor: Colors.grey[850],
  // //       body: ListView(
  // //         padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
  // //         children: [
  // //           _buildLanguageOption(
  // //               //TODO: változtatások mentése gomb biztosan hogy akarod?
  // //               context,
  // //               "Magyar",
  // //               Svg('assets/flags/hungary.svg')),
  // //           _buildLanguageOption(context, "Angol", Svg('assets/flags/uk.svg')),
  // //         ],
  // //       ),
  // //     ),
  // //   );
  // // }

  // _buildAppbar() {
  //   return AppBar(
  //     title: const Text("Nyelv Beállítása"),
  //     backgroundColor: Colors.deepPurpleAccent,
  //     elevation: 5,
  //     centerTitle: true,
  //     titleTextStyle: TextStyle(
  //       color: Colors.white,
  //       fontSize: 22,
  //       fontWeight: FontWeight.bold,
  //       letterSpacing: 1,
  //     ),
  //   );
  // }

  // Widget _buildLanguageOption(BuildContext context, String language, Svg flag) {
  //   return Card(
  //     color: Colors.grey[800],
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: ListTile(
  //       leading: Image(image: flag),
  //       title: Text(
  //         language,
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //           letterSpacing: 1,
  //         ),
  //       ),
  //       trailing: const Icon(Icons.check,
  //           color: Colors.white), //TODO: selected vagy sem a nyelv
  //       onTap: () {
  //         // Itt lehet elmenteni a választott nyelvet
  //         print("Kiválasztott nyelv: $language");

  //         // Visszalépés a Beállítások képernyőre
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  // }
//}
