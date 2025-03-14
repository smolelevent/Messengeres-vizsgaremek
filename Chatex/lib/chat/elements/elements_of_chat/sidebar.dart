import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/logic/auth.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';

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
  final String _username = Preferences.getUsername();
  String? _profileImageUrl = Preferences.getProfilePicture();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildProfileImage() {
    if (_profileImageUrl == null || _profileImageUrl!.isEmpty) {
      return _defaultAvatar();
    }

    // Ha az SVG előtag hiányzik, hozzáadjuk
    if (!_profileImageUrl!.startsWith("data:image/svg+xml;base64,")) {
      _profileImageUrl = "data:image/svg+xml;base64,$_profileImageUrl";
    }

    // Ha az adat egy Base64 kódolt SVG kép
    if (_profileImageUrl!.startsWith("data:image/svg+xml;base64,")) {
      try {
        final svgBytes = base64Decode(_profileImageUrl!.split(",")[1]);
        return ClipOval(
          child: SvgPicture.memory(svgBytes, width: 80, height: 80),
        );
      } catch (e) {
        log("Hiba az SVG dekódolásakor: $e");
        return _defaultAvatar();
      }
    }

    // Ha az adat egy Base64 kódolt PNG/JPG kép
    try {
      final imageBytes = base64Decode(_profileImageUrl!);
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[600],
        backgroundImage: MemoryImage(imageBytes),
      );
    } catch (e) {
      log("Hiba a PNG/JPG dekódolásakor: $e");
      return _defaultAvatar();
    }
  }

  Widget _defaultAvatar() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.grey[600],
      child: Icon(Icons.person, size: 40, color: Colors.white),
    );
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
                _buildProfileImage(),
                SizedBox(height: 20),
                Text(
                  _username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 1,
                    wordSpacing: 2,
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
