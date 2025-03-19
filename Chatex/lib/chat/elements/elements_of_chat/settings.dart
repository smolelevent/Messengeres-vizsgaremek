import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/chat/elements/elements_of_settings/language.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/chat/elements/elements_of_settings/account.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";
  String _selectedLanguage = Preferences.getPreferredLanguage();

  @override
  void initState() {
    _selectedLanguage = Preferences.getPreferredLanguage();
    super.initState();
  }

  Future<void> _savePreferredLanguage(String language) async {
    await Preferences.setPreferredLanguage(language);
    setState(() {
      _selectedLanguage = language;
    });
  }

  List<Map<String, dynamic>> getSettings() {
    return [
      {
        "category": Preferences.getPreferredLanguage() == "Magyar"
            ? "Általános"
            : "General",
        "items": [
          {
            "title": Preferences.getPreferredLanguage() == "Magyar"
                ? "Nyelv"
                : "Language",
            "subtitle": _selectedLanguage,
            "icon": Icons.language,
            "onTap": () async {
              final newLanguage = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LanguageSetting()),
              );

              if (newLanguage != null) {
                await _savePreferredLanguage(newLanguage);
              }
            },
          },
          {
            "title": Preferences.getPreferredLanguage() == "Magyar"
                ? "Értesítések"
                : "Notifications",
            "subtitle":
                Preferences.getPreferredLanguage() == "Magyar" ? "Be" : "On",
            "icon": Icons.notifications,
            "onTap": () => print("értesítés"),
          },
        ],
      },
      {
        "category":
            Preferences.getPreferredLanguage() == "Magyar" ? "Fiók" : "Account",
        "items": [
          {
            "title": Preferences.getPreferredLanguage() == "Magyar"
                ? "Fiók"
                : "Account",
            "subtitle": "",
            "icon": Icons.person,
            "onTap": () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountSetting()));
            },
          },
          {
            "title": Preferences.getPreferredLanguage() == "Magyar"
                ? "Jelszó módosítása"
                : "Change password",
            "subtitle": "",
            "icon": Icons.password,
            "onTap": () => print("jelszó"),
          },
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settings = getSettings();

    final filteredSettings = settings
        .map(
          (category) {
            final filteredItems = (category["items"] as List)
                .where((item) => item["title"]
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();

            return filteredItems.isNotEmpty
                ? {"category": category["category"], "items": filteredItems}
                : null;
          },
        )
        .whereType<Map<String, dynamic>>()
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          const SizedBox(height: 15),
          _buildSearchField(),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: filteredSettings.expand((category) {
                final items = category["items"] as List;
                return [
                  _buildCategoryTitle(category["category"]),
                  ...items.map((item) => _buildSettingCard(
                        item["icon"],
                        Colors.white,
                        item["title"],
                        item["subtitle"],
                        item["onTap"],
                      )),
                  if (category != filteredSettings.last) _buildDivider(),
                ];
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        key: const Key("settingsSearch"),
        name: "settings_search",
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (query) => setState(() => _searchQuery = query ?? ""),
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: _searchFocusNode.hasFocus
              ? null
              : Preferences.getPreferredLanguage() == "Magyar"
                  ? "Beállítások keresése..."
                  : "Search settings...",
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
          labelText: _searchFocusNode.hasFocus
              ? Preferences.getPreferredLanguage() == "Magyar"
                  ? "Beállítások keresése..."
                  : "Search settings..."
              : null,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 28),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white70, width: 2.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(IconData icon, Color iconColor, String title,
      String subtitle, VoidCallback onTap) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle, style: TextStyle(color: Colors.grey[400]))
            : null,
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.deepPurpleAccent, thickness: 2);
  }
}
