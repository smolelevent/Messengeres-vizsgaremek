import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/chat/elements/elements_of_people/friend_requests.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:async'; // Debounce-hoz
//import 'dart:developer';

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

  // Widget _buildTitle() {
  //   return Text(
  //     Preferences.getPreferredLanguage() == "Magyar"
  //         ? 'Ismerősök hozzáadása'
  //         : 'Add friends',
  //     textAlign: TextAlign.center,
  //     style: const TextStyle(
  //       color: Colors.white,
  //       fontWeight: FontWeight.bold,
  //       letterSpacing: 1,
  //       fontSize: 25,
  //     ),
  //   );
  // }

  Widget _buildSettingCard(
      IconData icon, Color iconColor, String title, VoidCallback onTap) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
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
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: FormBuilder(
        //TODO: appbar nem lehet mert duplán jelenne meg
        key: _formKey,
        child: Column(
          children: [
            // const SizedBox(
            //   height: 25,
            // ),
            //_buildTitle(),
            SizedBox(
              height: 70,
              child: ListView(
                children: [
                  _buildSettingCard(
                    Icons.people_alt,
                    Colors.white,
                    Preferences.getPreferredLanguage() == "Magyar"
                        ? "Barát jelölések"
                        : "Friend requests",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FriendRequests(),
                        ),
                      );
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

  void _searchUsers(String query) {
    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty || query.length < 3) {
        setState(() {
          _userSearchResults =
              []; // Ha törlik a keresést, ürítjük az eredményeket
        });
        return;
      }

      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/friends/search_users.php"),
        body: jsonEncode({"query": query}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> results = json.decode(response.body);
        String currentUsername =
            Preferences.getUsername(); // Jelenlegi felhasználó

        // Saját felhasználó kizárása
        results = results
            .where((user) => user["username"] != currentUsername)
            .toList();

        setState(() {
          _userSearchResults = results;
        });
      } else {
        setState(() {
          _userSearchResults = [];
        });
      }
    });
  }

  Future<void> _sendFriendRequest(int friendId) async {
    int? userId = Preferences.getUserId(); // Bejelentkezett felhasználó ID-ja

    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/friends/send_friend_request.php"),
      body: jsonEncode({
        "user_id": userId, // A bejelentkezett felhasználó ID-ja
        "friend_id": friendId // A kiválasztott felhasználó ID-ja
      }),
      headers: {"Content-Type": "application/json"},
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
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
    } else {
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? data["message"] // API válaszából vett hibaüzenet
            : "Error occurred while sending the friend request!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }

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
              _userSearchResults = []; // Törléskor alapállapotba kerül
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
                      _userSearchResults = []; // Az eredményeket törli
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
    String currentUsername =
        Preferences.getUsername(); // Bejelentkezett felhasználó neve

    if (_userSearchResults.isEmpty) {
      return Center(
        child: Text(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Nincs találat"
              : "No results",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: _userSearchResults.length,
      itemBuilder: (context, index) {
        final user = _userSearchResults[index];
        String? profilePicture = user["profile_picture"];
        String username = user["username"];
        int friendId = user["id"]; // A keresési találat user ID-ja

        // MIME előtag hozzáadása, ha nincs
        if (profilePicture != null && profilePicture.isNotEmpty) {
          if (!profilePicture.contains(",")) {
            profilePicture = "data:image/svg+xml;base64,$profilePicture";
          }
        }

        Widget profileImage;
        if (profilePicture != null && profilePicture.isNotEmpty) {
          if (profilePicture.startsWith("data:image/svg+xml;base64,")) {
            final svgString =
                utf8.decode(base64Decode(profilePicture.split(",")[1]));
            profileImage = SvgPicture.string(
              svgString,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            );
          } else if (profilePicture.startsWith("data:image/")) {
            profileImage = Image.memory(
              base64Decode(profilePicture.split(",")[1]),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            );
          } else if (profilePicture.startsWith("http")) {
            profileImage = Image.network(
              profilePicture,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            );
          } else {
            profileImage = SvgPicture.asset(
              "assets/default_avatar.svg",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            );
          }
        } else {
          profileImage = SvgPicture.asset(
            "assets/default_avatar.svg",
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          );
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[600],
            radius: 30,
            child: ClipOval(child: profileImage),
          ),
          title: Text(
            username,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          trailing: username != currentUsername
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent),
                  onPressed: () =>
                      _sendFriendRequest(friendId), // API hívás itt
                  child: Text(
                    Preferences.getPreferredLanguage() == "Magyar"
                        ? "Jelölés"
                        : "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : null, // Ha saját magát találja meg, ne legyen gomb
        );
      },
    );
  }

  // Widget _searchResultsWidget() {
  //   //működik, régi
  //   String currentUsername =
  //       Preferences.getUsername(); // Bejelentkezett felhasználó neve

  //   // Ellenőrizzük, hogy a keresési eredményben csak a felhasználó saját maga szerepel-e
  //   bool onlySelfFound = _userSearchResults.length == 1 &&
  //       _userSearchResults[0]["username"] == currentUsername;

  //   if (_userSearchResults.isEmpty) {
  //     return Center(
  //       child: Text(
  //         Preferences.getPreferredLanguage() == "Magyar"
  //             ? "Nincs találat"
  //             : "No results",
  //         style: TextStyle(color: Colors.white70, fontSize: 18),
  //       ),
  //     );
  //   } else if (onlySelfFound) {
  //     // Ha csak saját maga szerepel az eredmények között, akkor kiírjuk az üzenetet
  //     return Center(
  //       child: Text(
  //         Preferences.getPreferredLanguage() == "Magyar"
  //             ? "Saját magadat nem jelölheted be!"
  //             : "You cannot add yourself as a friend!",
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           color: Colors.redAccent,
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     );
  //   } else {
  //     // Ha más is szerepel a keresési eredmények között, akkor megjelenítjük a listát
  //     return ListView.builder(
  //       itemCount: _userSearchResults.length,
  //       itemBuilder: (context, index) {
  //         final user = _userSearchResults[index];
  //         String? profilePicture = user["profile_picture"];
  //         String username = user["username"];

  //         // MIME előtag hozzáadása, ha nincs
  //         if (profilePicture != null && profilePicture.isNotEmpty) {
  //           if (!profilePicture.contains(",")) {
  //             profilePicture = "data:image/svg+xml;base64,$profilePicture";
  //           }
  //         }

  //         Widget profileImage;
  //         if (profilePicture != null && profilePicture.isNotEmpty) {
  //           if (profilePicture.startsWith("data:image/svg+xml;base64,")) {
  //             final svgString =
  //                 utf8.decode(base64Decode(profilePicture.split(",")[1]));
  //             profileImage = SvgPicture.string(
  //               svgString,
  //               width: 60,
  //               height: 60,
  //               fit: BoxFit.cover,
  //             );
  //           } else if (profilePicture.startsWith("data:image/")) {
  //             profileImage = Image.memory(
  //               base64Decode(profilePicture.split(",")[1]),
  //               width: 60,
  //               height: 60,
  //               fit: BoxFit.cover,
  //             );
  //           } else if (profilePicture.startsWith("http")) {
  //             profileImage = Image.network(
  //               profilePicture,
  //               width: 60,
  //               height: 60,
  //               fit: BoxFit.cover,
  //             );
  //           } else {
  //             profileImage = SvgPicture.asset(
  //               "assets/default_avatar.svg",
  //               width: 60,
  //               height: 60,
  //               fit: BoxFit.cover,
  //             );
  //           }
  //         } else {
  //           profileImage = SvgPicture.asset(
  //             "assets/default_avatar.svg",
  //             width: 60,
  //             height: 60,
  //             fit: BoxFit.cover,
  //           );
  //         }

  //         return ListTile(
  //           leading: CircleAvatar(
  //             backgroundColor: Colors.grey[600],
  //             radius: 30,
  //             child: ClipOval(child: profileImage),
  //           ),
  //           title: Text(
  //             username,
  //             style: const TextStyle(color: Colors.white, fontSize: 20),
  //           ),
  //           trailing: username != currentUsername
  //               ? ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.deepPurpleAccent),
  //                   onPressed: () => _sendFriendRequest(user["id"]),
  //                   child: Text(
  //                     Preferences.getPreferredLanguage() == "Magyar"
  //                         ? "Jelölés"
  //                         : "Add",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 )
  //               : null, // Ha saját magát találja meg, ne legyen gomb
  //         );
  //       },
  //     );
  //   }
  // }
}
