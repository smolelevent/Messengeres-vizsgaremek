import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/application/components_of_chat/load_chats.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
import 'dart:developer';

class ManageFriends extends StatefulWidget {
  const ManageFriends({super.key});

  @override
  State<ManageFriends> createState() => _ManageFriendsState();
}

class _ManageFriendsState extends State<ManageFriends> {
  List<dynamic> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/ChatexProject/chatex_phps/friends/get/get_friends.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      final responseData = jsonDecode(response.body);
      if (responseData["success"] == true) {
        setState(() {
          _friends = responseData["friends"];
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load friends");
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        lang == "Magyar"
            ? "Kapcsolati hiba a barátok lekérésénél!"
            : "Connection error by getting friends!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: Text(
            lang == "Magyar" ? "Barátok kezelése" : "Manage Friends",
          ),
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          elevation: 10,
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildManageFriendsList()
      ),
    );
  }


void _showRemoveFriendDialog(int friendId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          lang == "Magyar" ? "Barát törlése" : "Remove friend",
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          lang == "Magyar"
              ? "Biztosan törölni szeretnéd ezt a barátot?"
              : "Are you sure you want to remove this friend?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text(lang == "Magyar" ? "Mégse" : "Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              lang == "Magyar" ? "Törlés" : "Remove",
              style: const TextStyle(color: Colors.redAccent),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _removeFriend(friendId);
            },
          ),
        ],
      );
    },
  );
}


Future<void> _removeFriend(int friendId) async {
  try {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/ChatexProject/chatex_phps/friends/set/remove_friend.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "friend_id": friendId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _friends.removeWhere((f) => f["id"] == friendId);
      });
      ToastMessages.showToastMessages(
        lang == "Magyar" ? "Barát törölve!" : "Friend removed!",
        0.2,
        Colors.green,
        Icons.check,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    } else {
      throw Exception("Failed to remove friend");
    }
  } catch (e) {
    ToastMessages.showToastMessages(
      lang == "Magyar"
          ? "Kapcsolati hiba a törlésnél!"
          : "Connection error when removing!",
      0.2,
      Colors.redAccent,
      Icons.error,
      Colors.black,
      const Duration(seconds: 2),
      context,
    );
  }
}



  Widget _buildManageFriendsList() {
  if (_friends.isEmpty) {
    return Center(
      child: Text(
        lang == "Magyar" ? "Nincsenek barátaid!" : "You have no friends!",
        style: const TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Center(
          child: Text(
            lang == "Magyar" ? "Jelenlegi barátaid" : "Your current friends",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: _friends.length,
          itemBuilder: (context, index) {
            final friend = _friends[index];
            final int friendId = friend["id"];
            final String username = friend["username"];
            final String? profilePicture = friend["profile_picture"];

            return Card(
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: ClipOval(
                  child: _buildProfilePicture(profilePicture),
                ),
                title: AutoSizeText(
                  username,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                  tooltip: lang == "Magyar" ? "Törlés" : "Remove",
                  onPressed: () => _showRemoveFriendDialog(friendId),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

}
