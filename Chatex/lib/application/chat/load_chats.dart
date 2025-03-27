import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/application/chat/chat_screen.dart';
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

//final int? userId = Preferences.getUserId();
    // if (userId == null) {
    //   log("Hiba: A felhasználó nincs bejelentkezve");
    //   return;
    // }

    setState(() {
      _chatList = fetchChatListFromDatabase(userId);
    });
  }

  Future<List<dynamic>> fetchChatListFromDatabase(int userId) async {
    try {
      final Uri chatFetchUrl = Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_chatlist.php");
      final response = await http.post(
        chatFetchUrl,
        body: jsonEncode({"id": userId}),
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

//TODO: ha nincs php akkor ne exception legyen
//TODO: nincs chat akkor ne egy üres képernyő legyen
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
          } else {
            final retrievedChatList = snapshot.data ?? [];
            if (retrievedChatList.isEmpty) {
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
              itemCount: retrievedChatList.length,
              itemBuilder: (context, index) {
                final friend = retrievedChatList[index];
                return ChatTile(
                  name: friend["friend_name"] ?? "Ismeretlen név",
                  lastMessage: friend["last_message"] ?? "Nincs üzenet",
                  time: friend["last_message_time"] ?? "nincs üzenet idő",
                  profileImage: friend["friend_profile_picture"],
                  onTap: () {
                    log("Megnyitva: ${friend["friend_name"]}");
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

//Chat kártya kinézete --------------------------------------------------------------------------------------
class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.profileImage,
    required this.onTap,
  });

  final String name;
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
        final base64Data = imageString.split(",")[1];
        return Image.memory(
          base64Decode(base64Data),
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        );
      } else {
        return const CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60,
          child: Icon(Icons.person),
        );
      }
    } catch (e) {
      return const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60,
        child: Icon(Icons.person),
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
          name,
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
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChatScreen()));
        },
      ),
    );
  }
}
