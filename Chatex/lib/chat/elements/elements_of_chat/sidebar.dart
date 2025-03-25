import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/logic/auth.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
  }

// Widget _buildProfileImage(String imageString) {
//     try {
//       if (imageString.startsWith("data:image/svg+xml;base64,")) {
//         final svgBytes = base64Decode(imageString.split(",")[1]);
//         return SvgPicture.memory(svgBytes,
//             width: 60, height: 60, fit: BoxFit.fill);
//       } else if (imageString.startsWith("data:image/")) {
//         final base64Data = imageString.split(",")[1];
//         return Image.memory(base64Decode(base64Data),
//             width: 60, height: 60, fit: BoxFit.fill);
//       }
//       // else if (imageString.startsWith("http")) {
//       //   return Image.network(imageString,
//       //       width: 60, height: 60, fit: BoxFit.cover);
//       // }
//       else {
//         return const CircleAvatar(
//           backgroundColor: Colors.transparent,
//           radius: 60,
//           child: Icon(Icons.person),
//         );
//       }
//     } catch (e) {
//       return const CircleAvatar(
//         backgroundColor: Colors.transparent,
//         radius: 60,
//         child: Icon(Icons.person),
//       );
//     }
//   }


  Widget _buildProfileImage() { //TODO: átírni a _buildProfileImage-eket
    if (_profileImageUrl == null || _profileImageUrl!.isEmpty) {
      return _defaultAvatar();
    }

    try {
      // MIME-típus alapján ellenőrzés
      if (_profileImageUrl!.startsWith("data:image/svg+xml;base64,")) {
        // Base64 kódolt SVG
        final svgBytes = base64Decode(_profileImageUrl!.split(",")[1]);
        return ClipOval(
          child: SvgPicture.memory(svgBytes, width: 80, height: 80),
        );
      } else if (_profileImageUrl!.startsWith("data:image/jpeg;base64,") ||
          _profileImageUrl!.startsWith("data:image/jpg;base64,") ||
          _profileImageUrl!.startsWith("data:image/png;base64,")) {
        // Base64 kódolt PNG/JPG
        final imageBytes = base64Decode(_profileImageUrl!.split(",")[1]);
        return CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[600],
          backgroundImage: MemoryImage(imageBytes),
        );
      } else {
        log("Ismeretlen képformátum: $_profileImageUrl");
        return _defaultAvatar();
      }
    } catch (e) {
      log("Hiba a kép dekódolásakor: $e");
      return _defaultAvatar();
    }
  }

  Widget _defaultAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey[600],
      child: const Icon(Icons.person, size: 40, color: Colors.white),
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
