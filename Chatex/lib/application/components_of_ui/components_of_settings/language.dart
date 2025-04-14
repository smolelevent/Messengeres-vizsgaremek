import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatex/logic/preferences.dart';

class LanguageSetting extends StatefulWidget {
  const LanguageSetting({super.key});

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  String _selectedLanguage = Preferences.getPreferredLanguage();

  @override
  void initState() {
    super.initState();
    _loadPreferredLanguage();
  }

  Future<void> _loadPreferredLanguage() async {
    setState(() {
      _selectedLanguage = Preferences.getPreferredLanguage();
    });
  }

  Future<void> _saveLanguage(String language) async {
    await Preferences.setPreferredLanguage(
        language); //TODO: olyan logika ami kijelentkezéskor elmenti a beállításokos preferenceket, mert clear-eljük a preferenceket
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
            _buildLanguageOption(context, "Magyar", "assets/flags/hungary.svg"),
            _buildLanguageOption(context, "English", "assets/flags/uk.svg"),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Nyelvek"
            : "Languages",
      ),
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 10,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String language, String flagPath) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: _selectedLanguage == language
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : null,
        onTap: () async {
          await _saveLanguage(language);
          if (context.mounted) {
            Navigator.pop(context, language);
          }
        },
      ),
    );
  }
}
