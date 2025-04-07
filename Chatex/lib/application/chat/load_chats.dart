import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatex/application/chat/chat_screen.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';

class LoadedChatData extends StatefulWidget {
  const LoadedChatData({super.key});

  @override
  LoadedChatDataState createState() => LoadedChatDataState();
}

class LoadedChatDataState extends State<LoadedChatData> {
  late Future<List<dynamic>> _chatList = Future.value([]);

  late WebSocketChannel _channel;
  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8080"),
    );

    _channel.stream.listen((message) {
      final decoded = jsonDecode(message);
      final type = decoded['type'] ?? 'message';
      final data = decoded['data'] ?? decoded;

      final int userId = Preferences.getUserId()!;

      // Csak akkor frissítsen, ha a chat_id szerepel a listában
      if (type == 'message' && data['receiver_id'] == userId) {
        _getCorrectChatList(); // újrahívja a Future-t
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
    _getCorrectChatList();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  Future<void> _getCorrectChatList() async {
    final int userId = Preferences.getUserId()!;

    setState(() {
      _chatList = fetchChatListFromDatabase(userId);
    });
  }

  Future<List<dynamic>> fetchChatListFromDatabase(int userId) async {
    try {
      final Uri chatFetchUrl = Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_chats.php");

      final response = await http.post(
        chatFetchUrl,
        body: jsonEncode({"user_id": userId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Nem sikerült betölteni a chat listát!"
              : "Couldn't load the chat list!",
          0.3,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        return [];
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
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: FutureBuilder<List<dynamic>>(
        future: _chatList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.deepPurpleAccent,
              ),
            );
          }

          final chatList = snapshot.data ?? [];

          if (chatList.isEmpty) {
            return Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                      text: Preferences.getPreferredLanguage() == "Magyar"
                          ? "Még nincs egyetlen csevegésed sem.\nKezdj el egyet a "
                          : "You don't have any chats yet.\nStart one clicking on the ",
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.add_comment,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: Preferences.getPreferredLanguage() == "Magyar"
                          ? " ikonra kattintva!"
                          : " icon!",
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              final chat = chatList[index];

              return ChatTile(
                chatName: chat["friend_name"],
                profileImage: chat["friend_profile_picture"] ?? "",
                lastMessage: chat["last_message"] ??
                    (Preferences.getPreferredLanguage() == "Magyar"
                        ? "Nincs még üzenet"
                        : "No message yet"),
                time: chat["last_message_time"] ?? "",
                isOnline: chat["status"],
                signedIn: chat["signed_in"],
                unreadCount: chat["unread_count"] ?? 0,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverId: chat["friend_id"],
                        chatName: chat["friend_name"],
                        profileImage: chat["friend_profile_picture"] ?? "",
                        lastSeen: chat["friend_last_seen"],
                        isOnline: chat["status"],
                        signedIn: chat["signed_in"],
                        chatId: chat["chat_id"],
                      ),
                    ),
                  );
                  _getCorrectChatList();
                },
              );
            },
          );
        },
      ),
    );
  }
}

//Chat kártya kinézete --------------------------------------------------------------------------------------
class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chatName,
    required this.lastMessage,
    required this.time,
    required this.profileImage,
    required this.onTap,
    required this.isOnline,
    required this.signedIn,
    required this.unreadCount,
  });

  final String chatName;
  final String lastMessage;
  final String time;
  final String profileImage;
  final VoidCallback onTap;
  final String isOnline;
  final int signedIn;
  final int unreadCount;

  Widget _buildProfileImage(String imageString, String isOnline, int signedIn) {
    Widget imageWidget;

    if (imageString.startsWith("data:image/svg+xml;base64,")) {
      final svgBytes = base64Decode(imageString.split(",")[1]);
      imageWidget = SvgPicture.memory(
        svgBytes,
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      );
    } else if (imageString.startsWith("data:image/")) {
      final base64Data = base64Decode(imageString.split(",")[1]);
      imageWidget = Image.memory(
        base64Data,
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      );
    } else {
      imageWidget = const Icon(
        Icons.person,
        size: 40,
        color: Colors.white,
      );
    }

    return SizedBox(
      //eltávolítása exception-t ad
      width: 66,
      height: 66,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[800],
              child: ClipOval(child: imageWidget),
            ),
          ),
          Positioned(
            bottom: -6,
            right: 10,
            child: Container(
              width: 15,
              height: 15,
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

  String formatMessageTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "Épp most"
            : "Just now";
      } else if (difference.inMinutes < 60) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "${difference.inMinutes} perce"
            : "${difference.inMinutes} minute(s) ago";
      } else if (difference.inHours < 24 && now.day == dateTime.day) {
        return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } else if (difference.inHours < 48 && now.day - dateTime.day == 1) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "Tegnap"
            : "Yesterday";
      } else {
        return "${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      }
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = unreadCount > 0;

    return Card(
      color: Colors.black45,
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: hasUnread
            ? const BorderSide(color: Colors.white, width: 2)
            : BorderSide.none,
      ),
      elevation: 5,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        leading: _buildProfileImage(profileImage, isOnline, signedIn),
        title: AutoSizeText(
          maxLines: 1,
          chatName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        //TODO: letesztelni az animációt!
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: hasUnread ? Colors.white : Colors.grey[400],
                ),
              ),
            ),
            if (hasUnread)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Container(
                  key: ValueKey<int>(
                    unreadCount,
                  ),
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        trailing: Text(
          formatMessageTime(time),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
