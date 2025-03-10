import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class ChatSidebar extends StatefulWidget {
  //TODO: kell e minden dart fájlba stateful widget, vizsga leadás előtt optimalizálni ahogy lehet!
  final SidebarXController sidebarXController;
  final Function(int, {bool isSidebarPage}) onSelectPage;

  const ChatSidebar(
      {super.key,
      required this.onSelectPage,
      required this.sidebarXController});

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  final SidebarXController _controller =
      SidebarXController(selectedIndex: 0, extended: true);
//TODO: visszatérni ide de előtte settingsbe profil kép feltöltés
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  String _username = "Betöltés...";
  String? _profileImageUrl;

  Future<void> _loadUserData() async {
    // 🔹 1. Felhasználó ID-jának lekérése SharedPreferences-ből
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    if (userId == null) {
      print("❌ Nincs bejelentkezett felhasználó.");
      return;
    }

    // 🔹 2. Lekérjük az adatokat az ID alapján
    var userData = await _fetchUserData(userId);
    if (userData != null) {
      setState(() {
        _username = userData["username"] ?? "Ismeretlen";
        _profileImageUrl = userData["profile_image"];
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchUserData(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/sidebar/get_user_info.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"]) {
          return {
            "username": data["username"],
            "profile_picture": data["profile_picture"],
          };
        }
      }
    } catch (e) {
      print("Hiba történt: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      showToggleButton: false,
      controller: widget.sidebarXController,
      headerBuilder: (context, extended) {
        return Column(
          children: [
            CircleAvatar(
              // TODO: felhasználó képe, ha nincs akkor a kis ember sziluett alapértelmezette
              radius: 40,
              backgroundColor: Colors.grey[600],
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : null,
              child: _profileImageUrl == null
                  ? Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
            ),
            SizedBox(height: 20),
            Text(
              _username, //TODO: felhasználó neve kell, ha túl hosszú akkor autosizetext
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        );
      },
      headerDivider: Divider(
        height: 50,
        thickness: 2,
        color: Colors.deepPurple[400],
      ),
      items: [
        SidebarXItem(
          label: 'Chatek',
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.chat,
              color: Colors.deepPurple[400],
            );
          },
          onTap: () {
            _controller.selectIndex(0);
            widget.onSelectPage(0, isSidebarPage: false);
            Navigator.pop(context);
          },
        ),
        SidebarXItem(
          label: 'Engedélykérések',
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.chat_outlined,
              color: Colors.yellow,
            );
          },
          onTap: () {
            _controller.selectIndex(2);
            widget.onSelectPage(2, isSidebarPage: true);
            Navigator.pop(context);
          },
        ),
        SidebarXItem(
          label: 'Archívum',
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.archive,
              color: Colors.green,
            );
          },
          onTap: () {
            _controller.selectIndex(3);
            widget.onSelectPage(3, isSidebarPage: true);
            Navigator.pop(context);
          },
        ),
      ],
      footerItems: [
        SidebarXItem(
          label: 'Beállítások',
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.settings,
              color: Colors.blue,
            );
          },
          onTap: () {
            _controller.selectIndex(4);
            widget.onSelectPage(4, isSidebarPage: true);
            Navigator.pop(context);
          },
        ),
        SidebarXItem(
          label: "Kijelentkezés",
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.logout,
              color: Colors.red,
            );
          },
          onTap: () async {
            //TODO: biztosan ezt akarod stb..
            await AuthService().logOut(context: context);
          },
        ),
      ],
      theme: SidebarXTheme(
        width: 250, //TODO: olyan megoldás ami mindenhol úgy néz ki!!!!!!!!
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        textStyle: TextStyle(
          //elem
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        selectedTextStyle: TextStyle(
          //elem kiválasztva
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        itemTextPadding: EdgeInsets.symmetric(
            horizontal: 20), // ikon, szöveg közötti távolság
        selectedItemTextPadding: EdgeInsets.symmetric(
            horizontal: 20), //icon, szöveg közötti távolság
        selectedItemDecoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 25,
        ),
        selectedIconTheme: IconThemeData(
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
