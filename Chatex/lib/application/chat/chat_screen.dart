import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    //required this.chatId,
    required this.chatName,
    required this.profileImage,
    //required this.isGroup,
    this.isOnline = false,
    required this.lastSeen,
  });

  //final int chatId;
  final String chatName;
  final String profileImage;
  //final bool isGroup;
  final bool
      isOnline; //TODO: frissítés kijelentkezéskor, lekezelni ha online (buborékok zöld, szürke), valósidőbe való átvitel
  final String lastSeen;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isInputFocused = false;
  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });

      _messageController.addListener(() {
        setState(() {
          _isWriting = _messageController.text.trim().isNotEmpty;
          _isInputFocused = _isWriting;
        });
      });
    });
  }

  String formatLastSeen(String lastSeenString) {
    try {
      final lastSeen = DateTime.parse(lastSeenString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(lastSeen);

      if (difference.inMinutes < 1) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "Épp most"
            : "Just now";
      } else if (difference.inMinutes < 60) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "${difference.inMinutes} perce"
            : "${difference.inMinutes} minute(s) ago";
      } else if (difference.inHours < 24) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "${difference.inHours} órája"
            : "${difference.inHours} hour(s) ago";
      } else {
        // Dátum: ÉÉÉÉ.HH.NN ÓÓ:PP
        final formattedDate =
            "${lastSeen.year}.${lastSeen.month.toString().padLeft(2, '0')}.${lastSeen.day.toString().padLeft(2, '0')} "
            "${lastSeen.hour.toString().padLeft(2, '0')}:${lastSeen.minute.toString().padLeft(2, '0')}";

        return formattedDate;
      }
    } catch (_) {
      return Preferences.getPreferredLanguage() == "Magyar"
          ? "Ismeretlen"
          : "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: _buildAppBar(),
        bottomSheet: _buildBottomBar(),
      ),
    );
  }

  Widget _buildIcon({
    required Color color,
    required String hunTooltip,
    required String engTooltip,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      color: color,
      focusColor: Colors.deepPurpleAccent,
      tooltip: Preferences.getPreferredLanguage() == "Magyar"
          ? hunTooltip
          : engTooltip,
      icon: Icon(
        icon,
        size: 26,
      ), //alap ikon méret 24
      onPressed: onPressed,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.deepPurpleAccent,
        shadowColor: Colors.deepPurpleAccent,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        titleSpacing: 0,
        leadingWidth: 55,
        title: Row(
          children: [
            ClipOval(
              child: Builder(
                builder: (context) {
                  final image = widget.profileImage;
                  if (image.startsWith("data:image/svg+xml;base64,")) {
                    final svgBase64 = image.split(',')[1];
                    final svgBytes = base64Decode(svgBase64);
                    return SvgPicture.memory(
                      svgBytes,
                      width: 48,
                      height: 48,
                      fit: BoxFit.fill,
                    );
                  } else if (image.startsWith("data:image/")) {
                    final base64Data = image.split(',')[1];
                    return Image.memory(
                      base64Decode(base64Data),
                      width: 48,
                      height: 48,
                      fit: BoxFit.fill,
                    );
                  } else {
                    return Container(
                      width: 48,
                      height: 48,
                      color: Colors.transparent,
                      child: const Icon(Icons.person, color: Colors.white),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.isOnline
                        ? (Preferences.getPreferredLanguage() == "Magyar"
                            ? "Elérhető"
                            : "Online")
                        : (Preferences.getPreferredLanguage() == "Magyar"
                            ? "Utoljára elérhető: ${formatLastSeen(widget.lastSeen)}" //TODO: chaten valósidőbe kezelni az adatokat, last seen, online, üzenet stb...
                            : "Last seen: ${formatLastSeen(widget.lastSeen)}"),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            _buildIcon(
              color: Colors.deepPurpleAccent,
              hunTooltip: "Információ a felhasználóról",
              engTooltip: "User Information",
              icon: Icons.info,
              onPressed: () {
                //TODO: felhasználó információi
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return ClipRRect(
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
            if (_isInputFocused)
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Vissza",
                engTooltip: "Back",
                icon: Icons.arrow_back,
                onPressed: () {
                  setState(() {
                    _isInputFocused = false;
                  });
                },
              )
            else ...[
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Fájl feltöltése",
                engTooltip: "File upload",
                icon: Icons.file_upload_outlined,
                onPressed: () {},
              ),
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Kamera",
                engTooltip: "Camera",
                icon: Icons.camera_enhance,
                onPressed: () {},
              ),
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Galéria",
                engTooltip: "Gallery",
                icon: Icons.photo_library_rounded,
                onPressed: () {},
              ),
            ],
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _inputFocusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: Preferences.getPreferredLanguage() == "Magyar"
                        ? "Kezdj el írni..."
                        : "Start writing...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            _buildIcon(
              //TODO: ikonok megírása, php-k
              color: Colors.deepPurpleAccent,
              hunTooltip: _isWriting ? "Üzenet küldése" : "Emoji gomb",
              engTooltip: _isWriting ? "Send message" : "Emoji button",
              icon: _isWriting ? Icons.send_rounded : Icons.thumb_up_rounded,
              onPressed: () {
                if (_isWriting) {
                  // Küldés logika itt
                  //print("Küldés: ${_messageController.text}");
                  _messageController.clear();
                } else {
                  //print("Like vagy emoji gomb megnyomva");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
