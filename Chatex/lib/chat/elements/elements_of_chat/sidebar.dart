import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/logic/auth.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatSidebar extends StatefulWidget {
  final SidebarXController sidebarXController;
  final Function(int, {bool isSidebarPage}) onSelectPage;

  const ChatSidebar({
    super.key,
    required this.onSelectPage,
    required this.sidebarXController,
  });

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  String _username = "";
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/sidebar/get_user_info.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": Preferences.getUserId()}), //userId
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"]) {
        setState(() {
          _username = data["username"] ?? "Ismeretlen";
          _profileImageUrl = data[
              "profile_picture"]; //TODO: amint beállítom a pfp-t akkor error
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Preferences.languageNotifier,
      builder: (context, locale, child) {
        return SidebarX(
          showToggleButton: false,
          controller: widget.sidebarXController,
          headerBuilder: (context, extended) {
            return Column(
              children: [
                CircleAvatar(
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
                  _username,
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
              label: locale == "Magyar" ? 'Chatek' : 'Chats',
              iconBuilder: (context, isSelected) {
                return Icon(
                  Icons.chat,
                  color: Colors.deepPurple[400],
                );
              },
              onTap: () {
                widget.sidebarXController.selectIndex(0);
                widget.onSelectPage(0, isSidebarPage: false);
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              label: locale == "Magyar" ? 'Csoportok' : 'Groups',
              iconBuilder: (context, isSelected) {
                return Icon(
                  Icons.group,
                  color: Colors.yellow,
                );
              },
              onTap: () {
                widget.sidebarXController.selectIndex(2);
                widget.onSelectPage(2, isSidebarPage: true);
                Navigator.pop(context);
              },
            ),
          ],
          footerItems: [
            SidebarXItem(
              label: locale == "Magyar" ? 'Beállítások' : 'Settings',
              iconBuilder: (context, isSelected) {
                return Icon(
                  Icons.settings,
                  color: Colors.blue,
                );
              },
              onTap: () {
                widget.sidebarXController.selectIndex(3);
                widget.onSelectPage(3, isSidebarPage: true);
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              label: Preferences.getPreferredLanguage() == "Magyar"
                  ? "Kijelentkezés"
                  : "Logout",
              iconBuilder: (context, isSelected) {
                return Icon(
                  Icons.logout,
                  color: Colors.red,
                );
              },
              onTap: () async {
                await AuthService().logOut(context: context);
              },
            ),
          ],
          theme: SidebarXTheme(
            width: 250,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            selectedTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            itemTextPadding: EdgeInsets.symmetric(horizontal: 20),
            selectedItemTextPadding: EdgeInsets.symmetric(horizontal: 20),
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
      },
    );
  }
}
