import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatex/logic/auth.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
import 'dart:developer';

class ChatSidebar extends StatefulWidget {
  const ChatSidebar({
    super.key,
    required this.onSelectPage,
    required this.sidebarXController,
  });

  final SidebarXController sidebarXController;
  final Function(int, {bool isSidebarPage}) onSelectPage;

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  final String _username = Preferences.getUsername();
  final String? _profileImageUrl = Preferences.getProfilePicture();
  final String? _isOnline = Preferences.getOnlineStatus();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildProfileImage() {
    //TODO: az ismétlődő kódokat egy külön dart-ba kell bevínni
    Widget imageWidget;
    if (_profileImageUrl!.startsWith("data:image/svg+xml;base64,")) {
      final svgString =
          utf8.decode(base64Decode(_profileImageUrl!.split(",")[1]));
      imageWidget = SvgPicture.string(
        svgString,
        width: 120,
        height: 120,
        fit: BoxFit.fill,
      );
    } else if (_profileImageUrl!.startsWith("data:image/")) {
      final imageBytes = base64Decode(_profileImageUrl!.split(",")[1]);
      imageWidget = Image.memory(
        imageBytes,
        width: 120, //(width, height)*2 = radius
        height: 120,
        fit: BoxFit.fill,
      );
    } else {
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Ismeretlen MIME-típus a profilképnél!"
            : "An unknown MIME type has been detected!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("An unknown MIME type has been detected: $_profileImageUrl");
      imageWidget = CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[600],
        child: const Icon(Icons.person, size: 40, color: Colors.white),
      );
    }

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[800],
              child: ClipOval(
                child: imageWidget,
              ),
            ),
          ),
          Positioned(
            bottom: -1,
            right: 15,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: (_isOnline ?? "").toLowerCase() == "online"
                    ? Colors.green
                    : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
            ),
          ),
        ],
      ),
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
                const SizedBox(height: 20),
                Text(
                  _username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
                return const Icon(
                  Icons.groups,
                  color: Colors.blue,
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
                return const Icon(
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
              //TODO: showDialog a kijelentkezés megerősítéséhez
              label: Preferences.getPreferredLanguage() == "Magyar"
                  ? "Kijelentkezés"
                  : "Logout",
              iconBuilder: (context, isSelected) {
                return const Icon(
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
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            itemTextPadding: const EdgeInsets.symmetric(horizontal: 20),
            selectedItemTextPadding: const EdgeInsets.symmetric(horizontal: 20),
            selectedItemDecoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 25,
            ),
            selectedIconTheme: const IconThemeData(
              color: Colors.white,
              size: 25,
            ),
          ),
        );
      },
    );
  }
}
