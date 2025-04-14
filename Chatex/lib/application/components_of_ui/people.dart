import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/application/components_of_ui/components_of_people/friend_requests.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';
import 'dart:async';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  final TextEditingController _userSearchController = TextEditingController();
  final FocusNode _userSearchFocusNode = FocusNode();
  bool _isUserSearchFocused = false;

  final _formKey = GlobalKey<FormBuilderState>();

  List<dynamic> _userSearchResults = [];
  Timer? _timer;

  int _friendRequestCount = 0;

  final Map<int, String> _friendStatusMap = {};

  @override
  void initState() {
    super.initState();
    _userSearchFocusNode.addListener(() {
      setState(() {
        _isUserSearchFocused = _userSearchFocusNode.hasFocus;
      });
    });
    _loadFriendRequestCount();
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    _userSearchFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

//TODO: appbar nem lehet mert duplán jelenne meg
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: ListView(
                children: [
                  _buildFriendRequestsCard(
                    Icons.people_alt,
                    Colors.white,
                    Preferences.getPreferredLanguage() == "Magyar"
                        ? "Barát jelölések"
                        : "Friend requests",
                    () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FriendRequests(),
                        ),
                      );
                      _loadFriendRequestCount();
                    },
                  ),
                ],
              ),
            ),
            _userSearchInputWidget(),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: _searchResultsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRequestsCard(
      IconData icon, Color iconColor, String title, VoidCallback onTap) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        trailing: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            if (_friendRequestCount > 0)
              Positioned(
                right: 30,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '$_friendRequestCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _loadFriendRequestCount() async {
    final int? userId = Preferences.getUserId();

    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/friends/get/get_friend_request_count.php"),
      body: jsonEncode({"user_id": userId}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"]) {
        setState(() {
          _friendRequestCount = data["count"];
        });
      }
    }
  }

  Widget _userSearchInputWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        key: (const Key("userName")),
        name: "username",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.minLength(
            3,
            errorText: Preferences.getPreferredLanguage() == "Magyar"
                ? "A felhasználónév túl rövid! (min 3)"
                : "The username is too short! (min 3)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.maxLength(
            20,
            errorText: Preferences.getPreferredLanguage() == "Magyar"
                ? "A felhasználónév túl hosszú! (max 20)"
                : "The username is too long! (max 20)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.required(
            errorText: Preferences.getPreferredLanguage() == "Magyar"
                ? "A felhasználónév nem lehet üres!"
                : "The username cannot be empty!",
            checkNullOrEmpty: false,
          ),
        ]),
        focusNode: _userSearchFocusNode,
        controller: _userSearchController,
        onChanged: (query) {
          if (query == null ||
              query.isEmpty ||
              query.length < 3 ||
              query.length > 20) {
            setState(() {
              _userSearchResults = [];
            });
          } else {
            _searchUsers(query);
          }
        },
        keyboardType: TextInputType.name,
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: _isUserSearchFocused
              ? null
              : Preferences.getPreferredLanguage() == "Magyar"
                  ? "Add meg a felhasználónevet!"
                  : "Enter the username!",
          labelText: _isUserSearchFocused
              ? Preferences.getPreferredLanguage() == "Magyar"
                  ? "Add meg a felhasználónevet!"
                  : "Enter the username!"
              : null,
          focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.deepPurpleAccent, width: 2.5)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.5)),
          suffixIcon: _userSearchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    _userSearchController.clear();
                    setState(() {
                      _userSearchResults = [];
                    });
                  },
                )
              : null,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          helperStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            letterSpacing: 1.0,
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  void _searchUsers(String query) {
    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(
      const Duration(milliseconds: 500),
      () async {
        if (query.isEmpty || query.length < 3) {
          setState(() {
            _userSearchResults = [];
          });
          return;
        }

        final response = await http.post(
          Uri.parse(
              "http://10.0.2.2/ChatexProject/chatex_phps/friends/get/search_users.php"),
          body: jsonEncode({"query": query}),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          List<dynamic> results = json.decode(response.body);
          final String currentUsername = Preferences.getUsername();

          // Saját felhasználó kizárása
          results = results.where((user) {
            return user["username"] != currentUsername;
          }).toList();

          setState(() {
            _userSearchResults = results;
          });
        } else {
          setState(() {
            _userSearchResults = [];
          });
        }
      },
    );
  }

  Future<String> _checkFriendStatus(int friendId) async {
    if (_friendStatusMap.containsKey(friendId)) {
      return _friendStatusMap[friendId]!;
    }

    final int? userId = Preferences.getUserId();
    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/friends/get/check_friend_status.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "friend_id": friendId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String status = responseData["message"];
      _friendStatusMap[friendId] = status;
      return status;
    } else {
      _friendStatusMap[friendId] = "error";
      return "error";
    }
  }

  Widget _searchResultsWidget() {
    if (_userSearchResults.isEmpty) {
      return Center(
        child: Text(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Nincs találat"
              : "No results",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: _userSearchResults.length,
      itemBuilder: (context, index) {
        final user = _userSearchResults[index];
        final int friendId = user["id"];
        final String? profilePicture = user["profile_picture"];
        final String username = user["username"];

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
              backgroundColor: Colors.grey[600],
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            );
          }
        } else {
          profileImage = CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[600],
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListTile(
              leading: ClipOval(child: profileImage),
              title: AutoSizeText(
                maxLines: 1,
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              trailing: FutureBuilder(
                future: _checkFriendStatus(friendId),
                builder: (context, snapshot) {
                  final status = snapshot.data.toString();

                  if (status == "already_friends") {
                    return Text(
                      Preferences.getPreferredLanguage() == "Magyar"
                          ? "Barát"
                          : "Friend",
                      style: const TextStyle(
                          color: Colors.greenAccent, fontSize: 14),
                    );
                  } else if (status == "pending_request") {
                    return Text(
                      Preferences.getPreferredLanguage() == "Magyar"
                          ? "Függőben"
                          : "Pending",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      onPressed: () => _sendFriendRequest(friendId),
                      child: Text(
                        Preferences.getPreferredLanguage() == "Magyar"
                            ? "Jelölés"
                            : "Add",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              )),
        );
      },
    );
  }

  Future<void> _sendFriendRequest(int friendId) async {
    final int? userId = Preferences.getUserId();
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/friends/set/send_friend_request.php"),
        body: jsonEncode({
          "user_id": userId,
          "friend_id": friendId,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = jsonDecode(response.body);

      if (responseData["message"] == "Barátjelölés elküldve!") {
        setState(() {
          _friendStatusMap[friendId] = "pending_request";
        });
        _searchUsers(_userSearchController.text);

        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Barátjelölés elküldve!"
              : "Friend request sent!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else if (responseData["message"] ==
          "Hiba történt a barátjelölés során!") {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Hiba történt a barátjelölés során!"
              : "Error occurred while sending the friend request!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else if (responseData["message"] == "Már küldtél barátjelölést!") {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Már küldtél barátjelölést!"
              : "You have already sent a friend request!",
          0.2,
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
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }
}
