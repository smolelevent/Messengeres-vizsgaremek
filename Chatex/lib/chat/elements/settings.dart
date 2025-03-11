import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/chat/elements/elements_of_settings/language.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final settings = [
      {
        "category": "Általános",
        "items": [
          {
            "title": "Nyelv",
            "subtitle": "Magyar",
            "icon": Icons.language,
            "onTap": () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageSetting()),
                ),
          },
          {
            "title": "Értesítések",
            "subtitle": "Be",
            "icon": Icons.notifications,
            "onTap": () => print("értesítés"),
          },
        ],
      },
      {
        "category": "Fiók",
        "items": [
          {
            "title": "Fiók adatok",
            "subtitle": "",
            "icon": Icons.person,
            "onTap": () => print("fiók"),
          },
          {
            "title": "Jelszó módosítása",
            "subtitle": "",
            "icon": Icons.password,
            "onTap": () => print("jelszó"),
          },
        ],
      },
    ];

    // 🔍 Szűrés keresési feltétel szerint
    final filteredSettings = settings
        .map((category) {
          final filteredItems = (category["items"] as List)
              .where((item) => item["title"]
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();

          return filteredItems.isNotEmpty
              ? {"category": category["category"], "items": filteredItems}
              : null;
        })
        .whereType<Map<String, dynamic>>()
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          const SizedBox(height: 15),
          _buildSettingsTitle(),
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

  Widget _buildSettingsTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'Beállítások',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
          decorationThickness: 2,
          decorationStyle: TextDecorationStyle.solid,
        ),
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
          hintText:
              _searchFocusNode.hasFocus ? null : "Beállítások keresése...",
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
          labelText: _searchFocusNode.hasFocus ? "Beállítások keresése" : null,
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

  Widget _buildSettingCard(
    IconData icon,
    Color iconColor,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

// class _SettingsState extends State<Settings> {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   List<Map<String, dynamic>> filteredSettings = [];

//    @override
//   void initState() {
//     super.initState();
//     filteredSettings = List.from(allSettings);
//   }

//   List<Map<String, dynamic>> allSettings = [
//     {
//       "category": "Általános",
//       "items": [
//         {
//           "title": "Nyelv",
//           "subtitle": "Magyar",
//           "icon": Icons.language,
//           "onTap": (BuildContext context) {
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => LanguageSetting()));
//           }
//         },
//         {
//           "title": "Értesítések",
//           "subtitle": "Be",
//           "icon": Icons.notifications,
//           "onTap": () => print("értesítés")
//         }
//       ],
//     },
//     {
//       "category": "Fiók",
//       "items": [
//         {
//           "title": "Fiók adatok",
//           "subtitle": "",
//           "icon": Icons.person,
//           "onTap": () => print("fiók")
//         },
//         {
//           "title": "Jelszó módosítása",
//           "subtitle": "",
//           "icon": Icons.password,
//           "onTap": () => print("jelszó")
//         }
//       ],
//     }
//   ];

//   void _searchSetting(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredSettings = List.from(allSettings);
//       } else {
//         filteredSettings = allSettings
//             .map<Map<String, dynamic>>((category) {
//               if (category["items"] is List) {
//                 var filteredItems = (category["items"] as List<dynamic>)
//                     .where((item) =>
//                         item is Map<String, dynamic> &&
//                         item.containsKey("title") &&
//                         (item["title"] is String) &&
//                         (item["title"] as String)
//                             .toLowerCase()
//                             .contains(query.toLowerCase()))
//                     .toList();

//                 if (filteredItems.isNotEmpty) {
//                   return {
//                     "category": category["category"],
//                     "items": filteredItems
//                   };
//                 }
//               }
//               return {};
//             })
//             .where((category) => category.isNotEmpty)
//             .toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[850],
//       body: Column(
//         children: [
//           const SizedBox(height: 15),
//           _buildSettingsTitle(),
//           const SizedBox(height: 15),
//           _buildSearchField(),
//           const SizedBox(height: 15),
//           Expanded(child: _buildSettingsList()),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsTitle() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       decoration: BoxDecoration(
//         color: Colors.deepPurpleAccent,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: const Text(
//         'Beállítások',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           letterSpacing: 1,
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
//       child: FormBuilderTextField(
//         key: const Key("settingsSearch"),
//         name: "settings_search",
//         controller: _searchController,
//         focusNode: _searchFocusNode,
//         onChanged: (query) => _searchSetting(query ?? ""),
//         keyboardType: TextInputType.text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 17.0,
//         ),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.grey[800],
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//           hintText:
//               _searchFocusNode.hasFocus ? null : "Beállítások keresése...",
//           hintStyle: TextStyle(
//             color: Colors.grey[400],
//             fontStyle: FontStyle.italic,
//             fontWeight: FontWeight.bold,
//             fontSize: 17.0,
//           ),
//           labelText: _searchFocusNode.hasFocus ? "Beállítások keresése" : null,
//           labelStyle: const TextStyle(
//             color: Colors.white,
//             fontSize: 17.0,
//           ),
//           prefixIcon: const Icon(Icons.search, color: Colors.white, size: 28),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(color: Colors.white70, width: 2.5),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingsList() {
//     return ListView(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       children: filteredSettings.expand<Widget>((category) {
//         return [
//           _buildCategoryTitle(category["category"]),
//           ...category["items"].map<Widget>((item) => _buildSettingCard(
//                 item["icon"],
//                 Colors.white,
//                 item["title"],
//                 item["subtitle"],
//                 () => item["onTap"](context),
//               )),
//           _buildDivider(),
//         ];
//       }).toList(),
//     );
//   }

//   Widget _buildSettingCard(IconData icon, Color iconColor, String title,
//       String subtitle, VoidCallback onTap) {
//     return Card(
//       color: Colors.grey[800],
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         leading: Icon(icon, color: iconColor),
//         title: Text(title, style: const TextStyle(color: Colors.white)),
//         subtitle: subtitle.isNotEmpty
//             ? Text(subtitle, style: TextStyle(color: Colors.grey[400]))
//             : null,
//         trailing:
//             const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }

//   Widget _buildCategoryTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, bottom: 5),
//       child: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           letterSpacing: 1,
//         ),
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return const Divider(color: Colors.deepPurpleAccent, thickness: 2);
//   }
// }
