import 'package:flutter/material.dart';
import 'package:chatex/logic/preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  Widget _buildIcons(Color color, String hunTooltip, String engTooltip,
      IconData icon, VoidCallback onPressed) {
    return IconButton(
      color: color,
      focusColor: Colors.deepPurpleAccent,
      tooltip: Preferences.getPreferredLanguage() == "Magyar"
          ? hunTooltip
          : engTooltip,
      icon: Icon(
        icon,
        size: 26, //alap ikon méret 24
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.deepPurpleAccent,
            shadowColor: Colors.deepPurpleAccent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            elevation: 10,
            titleSpacing: 0,
            leadingWidth: 55,
            title: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  radius: 24,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Felhasználónévdddddd", //kifér 20 karakter
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Elérhetődddddddddddd",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildIcons(
                  Colors.deepPurpleAccent,
                  "Információ a felhasználóról",
                  "User Information",
                  Icons.info,
                  () {},
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BottomAppBar(
            color: Colors.black,
            height: 70,
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
            child: Row(
              children: [
                _buildIcons(Colors.white, "Fájl feltöltése", "File upload",
                    Icons.file_upload_outlined, () {}),
                _buildIcons(Colors.white, "Kamera", "Camera",
                    Icons.camera_enhance, () {}),
                _buildIcons(Colors.white, "Galéria", "Gallery",
                    Icons.photo_library_rounded, () {}),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[800], //TODO: kerete lehetne lila
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: Preferences.getPreferredLanguage() == "Magyar"
                            ? "Kezdj el írni..."
                            : "Start writing...",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                _buildIcons(
                  Colors.deepPurpleAccent,
                  "Emoji gomb",
                  "Emoji button",
                  Icons.thumb_up_rounded,
                  () {
                    print("object");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
