import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/logic/auth.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
//import 'dart:developer';

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
  String? _selectedStatus = Preferences.getStatus() ?? "offline";

  @override
  void initState() {
    super.initState();
    _selectedStatus;
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
          center: true,
          rightPercentage: 0,
          leftPercentage: 0,
        );
      });
      imageWidget = CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[600],
        child: const Icon(
          Icons.person,
          size: 80,
          color: Colors.white,
        ),
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
                color: (_selectedStatus ?? "offline").toLowerCase() == "online"
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

  Widget _buildDropdownMenu() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: DropdownMenu<String>(
        initialSelection: _selectedStatus,
        label: Text(
          Preferences.getPreferredLanguage() == "Magyar" ? "Státusz" : "Status",
        ),
        onSelected: (newValue) async {
          if (newValue != _selectedStatus) {
            setState(() {
              _selectedStatus = newValue;
            });
          }

          final userId = Preferences.getUserId();
          try {
            final updateStatusUri = Uri.parse(
                "http://10.0.2.2/ChatexProject/chatex_phps/auth/update_status.php");

            final response = await http.post(
              updateStatusUri,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                "user_id": userId,
                "status": newValue,
              }),
            );

            final responseData = jsonDecode(response.body);
            if (responseData["message"] == "Státusz frissítve!" &&
                newValue != null) {
              await Preferences.setStatus(newValue);
              ToastMessages.showToastMessages(
                Preferences.getPreferredLanguage() == "Magyar"
                    ? "Sikeres változtatás!"
                    : "Successful change!",
                0.3,
                Colors.green,
                Icons.check,
                Colors.black,
                const Duration(seconds: 2),
                context,
                center: false,
                rightPercentage: 0.3,
                leftPercentage: 0,
              );
            } else {
              ToastMessages.showToastMessages(
                Preferences.getPreferredLanguage() == "Magyar"
                    ? "A változtatás nem sikerült!"
                    : "The change didn't happened!",
                0.3,
                Colors.orange,
                Icons.warning_rounded,
                Colors.black,
                const Duration(seconds: 2),
                context,
                center: true,
                rightPercentage: 0,
                leftPercentage: 0,
              );
            }
          } catch (e) {
            ToastMessages.showToastMessages(
              Preferences.getPreferredLanguage() == "Magyar"
                  ? "Kapcsolati hiba!"
                  : "Connection error!",
              0.3,
              Colors.redAccent,
              Icons.error,
              Colors.black,
              const Duration(seconds: 2),
              context,
              center: false,
              rightPercentage: 0.3,
              leftPercentage: 0,
            );
          }
        },
        dropdownMenuEntries: [
          DropdownMenuEntry(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            value: "online",
            label: "🟢 Online",
          ),
          DropdownMenuEntry(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            value: "offline",
            label: "⚫ Offline",
          ),
        ],
        trailingIcon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        selectedTrailingIcon: const Icon(
          Icons.arrow_drop_up,
          color: Colors.deepPurpleAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            letterSpacing: 1,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
          ),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey[900]),
          shadowColor: const WidgetStatePropertyAll(Colors.deepPurpleAccent),
          elevation: const WidgetStatePropertyAll(10),
        ),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    wordSpacing: 2,
                  ),
                ),
                _buildDropdownMenu(),
              ],
            );
          },
          headerDivider: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Center(
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          items: [
            SidebarXItem(
              label: locale == "Magyar" ? 'Chatek' : 'Chats',
              iconBuilder: (context, isSelected) {
                return const Icon(
                  Icons.chat,
                  color: Colors.deepPurpleAccent,
                  size: 30,
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
                  color: Colors.lightBlue,
                  size: 30,
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
                  color: Colors.teal,
                  size: 30,
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
                  color: Colors.redAccent,
                  size: 30,
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
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            itemTextPadding: const EdgeInsets.symmetric(horizontal: 20),
            selectedItemTextPadding: const EdgeInsets.symmetric(horizontal: 20),
            selectedItemDecoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}
