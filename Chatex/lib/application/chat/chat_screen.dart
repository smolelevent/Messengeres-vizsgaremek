import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';
import 'dart:developer';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatName,
    required this.profileImage,
    required this.isOnline,
    required this.lastSeen,
    required this.signedIn,
    required this.chatId,
  });

  final String chatName;
  final String profileImage;
  final String isOnline;
  final String lastSeen;
  final int signedIn;
  final int chatId;
//TODO: valósidőbe való átvitel

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isInputFocused = false;
  bool _isWriting = false;

  late WebSocketChannel _channel;
  List<Map<String, dynamic>> _messages = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _connectToWebSocket();
    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });
    });

    _messageController.addListener(() {
      setState(() {
        _isWriting = _messageController.text.trim().isNotEmpty;
        _isInputFocused = _isWriting;
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _messageController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_messages.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"chat_id": widget.chatId}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> messagesFromResponse =
          List<Map<String, dynamic>>.from(responseData["messages"]);

      setState(() {
        _messages = messagesFromResponse;
      });

      log("_messages miután elmentette a responseData-t: ${_messages.toString()}");
    }
  }

  void _connectToWebSocket() {
    /*
    INDÍTÁS ELŐTT FUTTATNI KELL A PHP-T: xampp_server\htdocs\ChatexProject\chatex_phps> php server_run.php,   
    A terminálba Ctrl + Shift + C-t nyomva lehet írni read-only terminálba!
    */
    _channel = WebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8080"),
    );

    log("WebSocket connected");

    _channel.stream.listen((message) {
      final decoded = jsonDecode(message);
      log("decoded: ${decoded.toString()}");
      final data = Map<String, dynamic>.from(decoded);
      log("data: ${data.toString()}");

      if (data['chat_id'] == widget.chatId) {
        setState(() {
          _messages.add(data);
        });
        _scrollToBottom();
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final message = {
      "sender_id": Preferences.getUserId(),
      "chat_id": widget.chatId,
      "message_text":
          _messageController.text.trim(), //egyenlőre trimmeljük lehet nem kell
    };

    _channel.sink.add(jsonEncode(message));

    //Azonnali megjelenítés saját felületen
    setState(() {
      _messages.add({
        "sender_id": Preferences.getUserId(),
        "message_text": _messageController.text.trim(),
        "sent_at": DateTime.now().toIso8601String(),
      } as Map<String, dynamic>);
    });
    _scrollToBottom();

    _messageController.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
      } else if (difference.inDays == 1) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "Tegnap"
            : "Yesterday";
      } else if (difference.inDays == 2) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "Tegnap előtt"
            : "The day before yesterday";
      } else {
        final formattedDate =
            "${lastSeen.year}.${lastSeen.month.toString().padLeft(2, '0')}.${lastSeen.day.toString().padLeft(2, '0')} "
            "${lastSeen.hour.toString().padLeft(2, '0')}:${lastSeen.minute.toString().padLeft(2, '0')}:${lastSeen.second.toString().padLeft(2, '0')}";
        return formattedDate;
      }
    } catch (_) {
      return Preferences.getPreferredLanguage() == "Magyar"
          ? "Hiba!"
          : "Error!";
    }
  }

//TODO: nincs chat előzmény, folytonossá tenni a load_chats.dart-ot, people.dart-ot
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          Preferences.getPreferredLanguage() == "Magyar"
                              ? "Ez a beszélgetés még üres."
                              : "The chat is empty.",
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        log("a _messages hossza: ${_messages.length.toString()}");
                        final message = _messages[index];
                        final isSender =
                            message['sender_id'] == Preferences.getUserId();
                        return ChatBubble(
                          messageText: message['message_text'] ?? "",
                          sentAt: formatLastSeen(message['sent_at'] ?? ""),
                          isSender: isSender,
                          profileImage: isSender ? null : widget.profileImage,
                        );
                      },
                    ),
            ),
          ],
        ),
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

  Widget buildProfileImage(String imageString, String isOnline, int signedIn) {
    Widget imageWidget;

    if (imageString.startsWith("data:image/svg+xml;base64,")) {
      final svgBytes = base64Decode(imageString.split(",")[1]);
      imageWidget = SvgPicture.memory(
        svgBytes,
        width: 48,
        height: 48,
        fit: BoxFit.fill,
      );
    } else if (imageString.startsWith("data:image/")) {
      final base64Data = base64Decode(imageString.split(",")[1]);
      imageWidget = Image.memory(
        base64Data,
        width: 48,
        height: 48,
        fit: BoxFit.fill,
      );
    } else {
      imageWidget = const Icon(
        Icons.person,
        size: 30,
        color: Colors.white,
      );
    }

    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[800],
              child: ClipOval(
                child: imageWidget,
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isOnline == "online" && signedIn == 1
                    ? Colors.green
                    : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
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
            buildProfileImage(
                widget.profileImage, widget.isOnline, widget.signedIn),
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
                    widget.isOnline == "online" && widget.signedIn == 1
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
                  _sendMessage();
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

//ChatBubble osztály kezdete -----------------------------------------------------------------------
// class ChatBubble extends StatelessWidget {
//   const ChatBubble({
//     super.key,
//     required this.messageText,
//     required this.isSender,
//     required this.sentAt,
//   });

//   final String messageText;
//   final bool isSender;
//   final String sentAt;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment:
//           isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Text(
//               sentAt,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontStyle: FontStyle.italic,
//                 letterSpacing: 0.5,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: isSender ? Colors.deepPurpleAccent : Colors.blueAccent,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Text(
//             messageText,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               wordSpacing: 0,
//               letterSpacing: 1,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.messageText,
    required this.isSender,
    required this.sentAt,
    this.profileImage,
  });

  final String messageText;
  final bool isSender;
  final String sentAt;
  final String? profileImage;

  Widget buildProfileImageFromString(String? imageString) {
    if (imageString == null || imageString.isEmpty) {
      return const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      );
    }

    try {
      if (imageString.startsWith("data:image/svg+xml;base64,")) {
        final svgBytes = base64Decode(imageString.split(",")[1]);
        return CircleAvatar(
          radius: 18,
          backgroundColor: Colors.transparent,
          child: SvgPicture.memory(svgBytes, width: 36, height: 36),
        );
      } else if (imageString.startsWith("data:image/")) {
        final base64Data = base64Decode(imageString.split(",")[1]);
        return CircleAvatar(
          radius: 18,
          backgroundImage: MemoryImage(base64Data),
          backgroundColor: Colors.grey[800],
        );
      } else if (imageString.endsWith(".png") ||
          imageString.endsWith(".jpg") ||
          imageString.endsWith(".jpeg") ||
          imageString.endsWith(".svg")) {
        // Fájl név vagy URL eset
        return CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(imageString),
          backgroundColor: Colors.grey[800],
        );
      }
    } catch (_) {
      // Ha valami hiba történik, fallback
      return const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      );
    }

    // Fallback minden másra
    return const CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey,
      child: Icon(Icons.person, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Profilkép csak akkor jelenik meg, ha a másik félről van szó
          if (!isSender)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: buildProfileImageFromString(profileImage),
            ),
          if (!isSender) const SizedBox(width: 8),

          // Üzenet buborék
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        isSender ? Colors.deepPurpleAccent : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    messageText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      wordSpacing: 0,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sentAt,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
