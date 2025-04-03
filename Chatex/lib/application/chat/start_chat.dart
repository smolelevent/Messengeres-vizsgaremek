import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/application/chat/chat_screen.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
//import 'dart:developer';

class StartChat extends StatefulWidget {
  const StartChat({super.key});

  @override
  State<StartChat> createState() => _StartChatState();
}

class _StartChatState extends State<StartChat> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";
  List<dynamic> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      final int? userId = Preferences.getUserId();

      if (userId == null) return;

      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_friend_list.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _friends = responseData;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Nem sikerült betölteni a barátaid!"
              : "Couldn't load your friends!",
          0.1,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Kapcsolati hiba!"
            : "Connection error!",
        0.1,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(),
        backgroundColor: Colors.grey[850],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: _buildSearchField(),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      ),
                    )
                  : _buildFriendList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendList() {
    final filtered = _friends.where(
      (friend) {
        final username = (friend["username"] as String).toLowerCase();
        return username.startsWith(_searchQuery.toLowerCase());
      },
    ).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Nincs találat"
              : "No results",
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final user = filtered[index];
        final friendId = user["id"];
        final username = user["username"];
        final String? profilePicture = user["profile_picture"];

        Widget profileImage;
        if (profilePicture != null && profilePicture.isNotEmpty) {
          if (profilePicture.startsWith("data:image/svg+xml;base64,")) {
            final svgString =
                utf8.decode(base64Decode(profilePicture.split(",")[1]));
            profileImage = SvgPicture.string(
              svgString,
              width: 60,
              height: 60,
              fit: BoxFit.fill,
            );
          } else if (profilePicture.startsWith("data:image/")) {
            profileImage = Image.memory(
              base64Decode(profilePicture.split(",")[1]),
              width: 60,
              height: 60,
              fit: BoxFit.fill,
            );
          } else {
            profileImage = CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            );
          }
        } else {
          profileImage = CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: ClipOval(child: profileImage),
            title: Text(
              username,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () => _startChatWith(friendId),
          ),
        );
      },
    );
  }

  void _startChatWith(int friendId) async {
    try {
      final int? senderId = Preferences.getUserId();

      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/chat/set/start_chat.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "sender_id": senderId,
          "receiver_id": friendId,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["message"] == "Chat létrehozva!") {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Chat létrehozva!"
              : "Chat created!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatName: responseData["friend_name"],
              profileImage: responseData["friend_profile_picture"] ?? "",
              lastSeen: responseData["last_seen"],
              isOnline: responseData["status"],
              signedIn: responseData["signed_in"],
              chatId: responseData["chat_id"],
            ),
          ),
        ); //TODO: miután bedob a chatbe és vissza nyíl akkor jelenjen meg a chat - aka valós időbe
      } else if (responseData["message"] == "Már létezik a chat!") {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Már létezik chated ezzel a felhasználóval!"
              : "The chat with this user already exist!",
          0.1,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Kapcsolati hiba!"
            : "Connection error!",
        0.1,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Chat kezdése"
            : "Start chat",
      ),
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 10,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        wordSpacing: 2,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        key: const Key("chatStartSearch"),
        name: "chat_start_search",
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (query) => setState(() => _searchQuery = query ?? ""),
        keyboardType: TextInputType.name,
        style: const TextStyle(color: Colors.white, fontSize: 17.0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: _searchFocusNode.hasFocus
              ? null
              : Preferences.getPreferredLanguage() == "Magyar"
                  ? "Ismerősök keresése..."
                  : "Search friends...",
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
          labelText: _searchFocusNode.hasFocus
              ? Preferences.getPreferredLanguage() == "Magyar"
                  ? "Ismerősök keresése..."
                  : "Search friends..."
              : null,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 17.0),
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 28),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                const BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white70, width: 2.5),
          ),
        ),
      ),
    );
  }
}
