import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async'; // Debounce-hoz
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';

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

  List<dynamic> _userSearchResults = []; // A keresési eredmények listája
  Timer? _timer; // Debounce időzítő a keresési lekérésekhez

  @override
  void initState() {
    super.initState();
    _userSearchFocusNode.addListener(() {
      setState(() {
        _isUserSearchFocused = _userSearchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    _userSearchFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              Preferences.getPreferredLanguage() == "Magyar"
                  ? 'Ismerősök hozzáadása'
                  : 'Add friends',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _userSearchInputWidget(),
            const SizedBox(height: 10),
            Expanded(child: _searchResultsWidget()),
          ],
        ),
      ),
    );
  }

  void _searchUsers(String query) {
    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 3) return; // Ne keressen, ha túl rövid

      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/friends/search_users.php"),
        body: jsonEncode({"query": query}),
        headers: {"Content-Type": "application/json"},
      );
      //log(response.statusCode.toString());
      if (response.statusCode == 200) {
        setState(() {
          _userSearchResults = json.decode(response.body);
        });
      } else {
        setState(() {
          _userSearchResults = [];
        });
      }
    });
  }

//TODO: megcsinálni a friend requestet
  Future<void> _sendFriendRequest(int userId) async {
    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/send_friend_request.php"),
      body: jsonEncode({"friend_id": userId}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Barátjelölés elküldve!"
              : "Friend request sent!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2));
    } else {
      ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Hiba történt a barátjelölés közben!"
              : "Error occurred while sending the friend request!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
    }
  }

//TODO: kód újrahasznosítása
  Widget _userSearchInputWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        key: (Key("userName")),
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
              checkNullOrEmpty: false),
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
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
            borderSide: BorderSide(
              color: Colors.deepPurpleAccent,
              width: 2.5,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.5,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          helperStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            letterSpacing: 1.0,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _searchResultsWidget() {
    return _userSearchResults.isEmpty
        ? Center(
            child: Text(
              Preferences.getPreferredLanguage() == "Magyar"
                  ? "Nincs találat"
                  : "No results",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: _userSearchResults.length,
            itemBuilder: (context, index) {
              final user = _userSearchResults[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: ListTile(
                  horizontalTitleGap: 10,
                  leading: CircleAvatar(
                    backgroundImage: user["profile_picture"] != null
                        ? NetworkImage(user["profile_picture"])
                        : const AssetImage("assets/logo.jpg") as ImageProvider,
                    radius: 30,
                  ),
                  title: Text(
                    user["username"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  // subtitle: Text(user["status"],
                  //     style: const TextStyle(color: Colors.grey)),
                  trailing: ElevatedButton(
                    key: Key("addFriend"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    onPressed: () => _sendFriendRequest(user["id"]),
                    child: Text(
                      Preferences.getPreferredLanguage() == "Magyar"
                          ? "Jelölés"
                          : "Add",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
