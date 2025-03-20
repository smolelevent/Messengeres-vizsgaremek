import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/logic/preferences.dart';

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

  /// **Barátjelölések lekérése az API-ból**
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _friendRequests = data['requests'];
          _isLoading = false;
        });
      } else {
        throw Exception('Sikertelen lekérés');
      }
    } catch (e) {
      print('Hiba történt: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// **Barátjelölés elfogadása**
  Future<void> _acceptRequest(int requestId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/accept_request.php'),
        body: jsonEncode({'request_id': requestId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          _friendRequests.removeWhere((req) => req['id'] == requestId);
        });
      } else {
        throw Exception('Hiba történt az elfogadás során');
      }
    } catch (e) {
      print("Elfogadás hiba: $e");
    }
  }

  /// **Barátjelölés elutasítása**
  Future<void> _declineRequest(int requestId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/decline_request.php'),
        body: jsonEncode({'request_id': requestId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          _friendRequests.removeWhere((req) => req['id'] == requestId);
        });
      } else {
        throw Exception('Hiba történt az elutasítás során');
      }
    } catch (e) {
      print("Elutasítás hiba: $e");
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

  /// **Jelölések listájának megjelenítése**
  Widget _friendRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _friendRequests.length,
      itemBuilder: (context, index) {
        final request = _friendRequests[index];
        return _buildFriendRequestCard(request);
      },
    );
  }

  /// **Jelölés kártya UI**
  Widget _buildFriendRequestCard(dynamic request) {
    //TODO: innen folyt köv, design elrendezése
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(request['profile_picture']),
        ),
        title: Text(
          request['username'],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Barátjelölés érkezett"
              : "Friend request received",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _acceptRequest(request['id']),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _declineRequest(request['id']),
            ),
          ],
        ),
      ),
    );
  }

  /// **Ha nincs jelölés**
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
