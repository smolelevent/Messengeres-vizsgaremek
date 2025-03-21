import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
import 'dart:developer';

class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  List<dynamic> _friendRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriendRequests();
  }

//TODO: amikor jön bejövő barátkérés akkor annak az illetőnek ne tudj küldeni barátkérést
  Future<void> _fetchFriendRequests() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/get_requests.php'),
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
        }),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = jsonDecode(response.body);
      if (responseData["success"] == true) {
        setState(() {
          _friendRequests = responseData['requests'];
          _isLoading = false;
        });
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Kapcsolati hiba!"
            : "Connection error!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(int requestId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/accept_request.php'),
        body: jsonEncode({'request_id': requestId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Barát kérés sikeresen elfogadva!🎊"
              : "Friend request accepted!🎊",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        setState(() {
          _friendRequests.removeWhere((req) => req['id'] == requestId);
        });
      } else {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Hiba történt az elfogadás során!"
              : "An error occured while accepting!",
          0.2,
          Colors.red,
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
        0.2,
        Colors.red,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }

  Future<void> _declineRequest(int requestId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/decline_request.php'),
        body: jsonEncode({'request_id': requestId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Barát kérés sikeresen elutasítva!"
              : "Friend request declined!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        setState(() {
          _friendRequests.removeWhere((req) => req['id'] == requestId);
        });
      } else {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Hiba történt az elutasítás során!"
              : "An error occured while declining",
          0.2,
          Colors.red,
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
        0.2,
        Colors.red,
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _friendRequests.isEmpty
                ? _noRequestsWidget()
                : _friendRequestsList(),
      ),
    );
  }

  Widget _noRequestsWidget() {
    return Center(
      child: Text(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Nincsenek új jelölések"
            : "No new friend requests",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _friendRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      itemCount: _friendRequests.length,
      itemBuilder: (context, index) {
        final request = _friendRequests[index];
        return _buildFriendRequestCard(request);
      },
    );
  }

  Widget _buildProfileImage(String? profilePicture) {
    if (profilePicture == null || profilePicture.isEmpty) {
      return _defaultAvatar();
    }

    try {
      if (profilePicture.startsWith("data:image/svg+xml;base64,")) {
        final svgBytes = base64Decode(profilePicture.split(",")[1]);
        return ClipOval(
          child: SvgPicture.memory(
            svgBytes,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ); //TODO: nem jelenik meg jól a .jpg
      } else if (profilePicture.startsWith("data:image/png;base64,") ||
          profilePicture.startsWith("data:image/jpeg;base64,") ||
          profilePicture.startsWith("data:image/jpg;base64,")) {
        final imageAsBytes = base64Decode(profilePicture.split(",")[1]);
        return CircleAvatar(
          radius: 30,
          backgroundImage: MemoryImage(imageAsBytes),
        );
      } else {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Ismeretlen MIME-típus a profilképnél!"
              : "An unknown MIME type has been detected!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        log("An unknown MIME type has been detected: $profilePicture");
        return _defaultAvatar();
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Hiba a kép dekódolásakor!"
            : "Error in picture decoding!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Error in picture decoding: $e");
      return _defaultAvatar();
    }
  }

  Widget _defaultAvatar() {
    return const CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey,
      child: Icon(Icons.person, size: 30, color: Colors.white),
    );
  }

  Widget _buildFriendRequestCard(dynamic request) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: _buildProfileImage(request["profile_picture"]),
        title: AutoSizeText(
          maxLines: 1,
          request['username'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Barát jelölés🤓"
              : "Friend request🤓",
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _acceptRequest(request['id']),
            ),
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _declineRequest(request['id']),
            ),
          ],
        ),
      ),
    );
  }

  _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Jelölések"
            : "Friend Requests",
      ),
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 5,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }
}
