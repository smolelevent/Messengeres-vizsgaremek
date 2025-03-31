import 'package:chatex/application/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
//import 'package:chatex/application/chat/chat_screen.dart';
import 'dart:convert';
import 'dart:developer';

class LoadedChatData extends StatefulWidget {
  const LoadedChatData({super.key});

  @override
  LoadedChatDataState createState() => LoadedChatDataState();
}

class LoadedChatDataState extends State<LoadedChatData> {
  late Future<List<dynamic>> _chatList = Future.value([]);

  @override
  void initState() {
    super.initState();
    _getCorrectChatList();
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
                lastMessage: chat["last_message"] ??
                        Preferences.getPreferredLanguage() == "Magyar"
                    ? "Nincs még üzenet"
                    : "No message yet",
                time: chat["last_message_time"] ?? "",
                profileImage: chat["friend_profile_picture"] ?? "",
                onTap: () {
                  log("Megnyitva: ${chat["friend_name"]}");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatName: chat["friend_name"],
                        profileImage: chat["friend_profile_picture"] ?? "",
                        lastSeen: chat["friend_last_seen"],
                      ),
                    ),
                  );
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
  });

  final String chatName;
  final String lastMessage;
  final String time;
  final String profileImage;
  final VoidCallback onTap;

  Widget _buildProfileImage(String imageString) {
    try {
      if (imageString.startsWith("data:image/svg+xml;base64,")) {
        final svgBytes = base64Decode(imageString.split(",")[1]);
        return SvgPicture.memory(
          svgBytes,
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        );
      } else if (imageString.startsWith("data:image/")) {
        final base64Data = base64Decode(imageString.split(",")[1]);
        return Image.memory(
          base64Data,
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        );
      } else {
        return const CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 30,
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
        );
      }
    } catch (e) {
      return const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 30,
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: ClipOval(child: _buildProfileImage(profileImage)),
        title: AutoSizeText(
          maxLines: 1,
          chatName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        trailing: Text(
          //TODO: stack használata hogy az idő ne foglaljon annyi helyet
          time,
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
