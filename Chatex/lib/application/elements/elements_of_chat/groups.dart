import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
//import 'package:chatex/application/chat/chat_screen.dart';
import 'dart:convert';
//import 'dart:developer';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  late Future<List<dynamic>> _groupList = Future.value([]);

  @override
  void initState() {
    super.initState();
    _getCorrectGroupList();
  }

  Future<void> _getCorrectGroupList() async {
    final int userId = Preferences.getUserId()!;

    setState(() {
      _groupList = fetchGroupListFromDatabase(userId);
    });
  }

  Future<List<dynamic>> fetchGroupListFromDatabase(int userId) async {
    try {
      final Uri groupFetchUrl = Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_group_chats.php");

      final response = await http.post(
        groupFetchUrl,
        body: jsonEncode({"user_id": userId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Nem sikerült betölteni a csoportjaidat!"
              : "Couldn't load your groups!",
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
        future: _groupList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.deepPurpleAccent,
              ),
            );
          }

          final groupList = snapshot.data ?? [];

          if (groupList.isEmpty) {
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
                          ? "Még nem vagy tagja egyetlen csoportnak sem.\nCsinálj egyet a "
                          : "You aren't in any group chats.\nCreate one by clicking on the ",
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.groups_rounded,
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
            itemCount: groupList.length,
            itemBuilder: (context, index) {
              final group = groupList[index];
              return GroupTile(
                groupName: group["group_name"] ??
                    "a felhasználók nevei", //TODO: ha null akkor felhasználók nevei
                lastMessage: group["last_message"] ??
                        Preferences.getPreferredLanguage() == "Magyar"
                    ? "Nincs még üzenet"
                    : "No message yet",
                time: group["last_message_time"] ??
                    "", //azért van szükség ezekre mivel az alapértelmezett értékük null
                profileImage: group["group_profile_picture"] ?? "",
                onTap: () {
                  // TODO: Navigálás a GroupScreen-re
                },
              );
            },
          );
        },
      ),
    );
  }
}

//Group kártya kinézete --------------------------------------------------------------------------------------
class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.groupName,
    required this.lastMessage,
    required this.time,
    required this.profileImage,
    required this.onTap,
  });

  final String groupName;
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
            Icons.groups,
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
          Icons.groups,
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
          groupName,
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
