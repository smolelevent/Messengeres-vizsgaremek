import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer'; //log miatt
import 'package:http/http.dart' as http;
import 'package:chatex/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadedChatData extends StatefulWidget {
  const LoadedChatData({super.key});
  @override
  LoadedChatDataState createState() => LoadedChatDataState();
}

class LoadedChatDataState extends State<LoadedChatData> {
  late Future<List<dynamic>> _chatList;
  final ToastMessages _toastMessagesInstance = ToastMessages();

  @override
  void initState() {
    super.initState();
    //_chatList = fetchChatListFromDatabase();
    _getCorrectChatList();
  }

  Future<void> _getCorrectChatList() async {
    SharedPreferencesWithCache prefs = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions());
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
    final Uri chatFetchUrl =
        Uri.parse("http://10.0.2.2/ChatexProject/chatex_phps/get_chatlist.php");
    final response = await http.post(
      chatFetchUrl,
      body: jsonEncode({"id": userId}),
      headers: {"Content-Type": "application/json"}, //TODO: innen folyt köv
    );

    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log(response.statusCode.toString());
      _toastMessagesInstance.showToastMessages(
          "Valami hiba, dögölj meg!",
          0.1,
          Colors.red,
          Icons.error_outline,
          Colors.black,
          const Duration(seconds: 2));
      throw Exception("Nem sikerült betölteni a chatlistát");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _chatList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //ha az adatokat még tölti
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Hiba történt az adatok betöltésekor"));
        } else {
          final retrievedChatList = snapshot.data!;
          return ListView.builder(
            itemCount: retrievedChatList.length,
            itemBuilder: (context, index) {
              final friend = retrievedChatList[index];
              return ChatTile(
                name: friend["name"],
                lastMessage: friend["lastMessage"],
                time: friend["time"],
                profileImage: friend["profileImage"],
                onTap: () {
                  log("Megnyitva: ${friend["name"]}");
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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage("assets/sample_0.jpg"),
          backgroundColor: Colors.grey[300],
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
