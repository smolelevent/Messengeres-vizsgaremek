import 'package:flutter/material.dart';
import 'dart:convert'; //encode, decode
import 'dart:developer'; //log miatt
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadedChatData extends StatefulWidget {
  const LoadedChatData({super.key});
  @override
  LoadedChatDataState createState() => LoadedChatDataState();
}

//TODO: nem tölti be a pfp-ket a chatekre
class LoadedChatDataState extends State<LoadedChatData> {
  late Future<List<dynamic>> _chatList =
      Future.value([]); // Üres lista, így nem lesz lateInitError

  @override
  void initState() {
    super.initState();
    _getCorrectChatList();
  }

  Future<void> _getCorrectChatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    if (userId == null) {
      log("Hiba: Nincs elmentve user_id");
      return;
    }
    setState(() {
      _chatList = fetchChatListFromDatabase(userId);
    });
  }

  Future<List<dynamic>> fetchChatListFromDatabase(int userId) async {
    final Uri chatFetchUrl = Uri.parse(
        "http://10.0.2.2/ChatexProject/chatex_phps/chat/get_chatlist.php");
    final response = await http.post(
      chatFetchUrl,
      body: jsonEncode({"id": userId}),
      headers: {
        "Content-Type": "application/json"
      }, //TODO: ha nincs senki bejelentkezve akkor is ugyanazokat a chateket tölti be
    );

    //log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log(response.statusCode.toString());
      ToastMessages.showToastMessages(
        "Valami hiba, dögölj meg!",
        0.1,
        Colors.red,
        Icons.error_outline,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      throw Exception("Nem sikerült betölteni a chatlistát");
    }
  }

//TODO: nincs chat akkor ne egy üres képernyő legyen
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _chatList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //ha az adatokat még tölti
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.deepPurpleAccent,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Hiba történt az adatok betöltésekor"));
        } else {
          final retrievedChatList = snapshot.data!;
          return ListView.builder(
            itemCount: retrievedChatList.length,
            itemBuilder: (context, index) {
              final friend = retrievedChatList[index];
              return ChatTile(
                name: friend["friend_name"] ?? "Ismeretlen név",
                lastMessage: friend["last_message"] ?? "Nincs üzenet",
                time: friend["last_message_time"] ?? "nincs üzenet idő",
                profileImage:
                    friend["friend_profile_picture"] ?? "assets/logo.jpg",
                onTap: () {
                  log("Megnyitva: ${friend["friend_name"]}");
                },
              );
            },
          );
        }
      },
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final String profileImage;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.profileImage,
    required this.onTap,
  });

  Widget _buildProfileImage(String imageString) {
    try {
      if (imageString.startsWith("data:image/svg+xml;base64,")) {
        final svgBytes = base64Decode(imageString.split(",")[1]);
        return SvgPicture.memory(svgBytes,
            width: 60, height: 60, fit: BoxFit.cover);
      } else if (imageString.startsWith("data:image/")) {
        final base64Data = imageString.split(",")[1];
        return Image.memory(base64Decode(base64Data),
            width: 60, height: 60, fit: BoxFit.cover);
      } else if (imageString.startsWith("http")) {
        return Image.network(imageString,
            width: 60, height: 60, fit: BoxFit.cover);
      } else {
        return Image.asset("assets/logo.jpg",
            width: 60, height: 60, fit: BoxFit.cover);
      }
    } catch (e) {
      return Image.asset("assets/logo.jpg",
          width: 60, height: 60, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[300],
          child: ClipOval(
            child: _buildProfileImage(profileImage),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
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
          time,
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
        onTap: () {
          print("dögölj meg");
        },
      ),
    );
  }
}
