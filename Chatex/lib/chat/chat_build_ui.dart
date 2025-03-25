import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/chat/chat_load.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/chat/elements/elements_of_chat/sidebar.dart';
import 'package:chatex/chat/elements/elements_of_chat/bottom_nav_bar.dart';
import 'package:chatex/chat/elements/elements_of_chat/people.dart';
import 'package:chatex/chat/elements/elements_of_chat/groups.dart';
import 'package:chatex/chat/elements/elements_of_chat/settings.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  late SidebarXController _sidebarController;
  int _selectedIndex = 0;
  final bool _widgetFromSidebar = false;

  @override
  void initState() {
    super.initState();
    _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  }

  void _setScreen(int index, {bool isSidebarPage = false}) {
    setState(() {
      _selectedIndex = index;
      if (isSidebarPage) {
        _sidebarController.selectIndex(index);
      } else if (index == 0) {
        _sidebarController.selectIndex(0);
      } else {
        _sidebarController.selectIndex(-1);
      }
    });
  }

  Widget _getScreen() {
    switch (_selectedIndex) {
      case 0:
        return const LoadedChatData();
      case 1:
        return const People();
      case 2:
        return const Groups();
      case 3:
        return const Settings();
      default:
        return const LoadedChatData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Preferences.languageNotifier,
      builder: (context, value, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[850],
            appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent,
              elevation: 5,
              actions: _selectedIndex == 0
                  ? [
                      IconButton(
                        icon: const Icon(Icons.add_comment),
                        color: Colors.white,
                        tooltip:
                            "Új chat indítása", //TODO: tooltip még jó lehet
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StartChat()),
                          );
                        },
                      ),
                    ]
                  : null,
            ),
            drawer: ChatSidebar(
              onSelectPage: _setScreen,
              sidebarXController: _sidebarController,
            ),
            body: _getScreen(),
            bottomNavigationBar: BottomNavbarForChat(
              selectedIndex: _widgetFromSidebar ? -1 : _selectedIndex,
              onItemTapped: (index) => _setScreen(index, isSidebarPage: false),
            ),
          ),
        );
      },
    );
  }
}

//StartChat osztály kezdete ---------------------------------------------------------------------------
class StartChat extends StatefulWidget {
  const StartChat({super.key});

  @override
  State<StartChat> createState() => _StartChatState();
}

class _StartChatState extends State<StartChat> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";
  //TODO: minden keresés a programban legyen olyan hogy az első karakter az feleljen meg az eredmény első karakterjével
  List<dynamic> _friends = [];
  final Set<int> _selectedFriendIds = {};
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
              ? "Nem sikerült betölteni a barátokat!"
              : "Couldn't load the friend list!",
          0.3,
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
        0.3,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }

  void _toggleSelection(int friendId) {
    setState(() {
      if (_selectedFriendIds.contains(friendId)) {
        _selectedFriendIds.remove(friendId);
      } else {
        _selectedFriendIds.add(friendId);
      }
    });
  }

  void _startChat() {
    if (_selectedFriendIds.isEmpty) return;

    // TODO: chat létrehozás logika (pl. POST PHP-ra), majd átirányítás
    ToastMessages.showToastMessages(
      Preferences.getPreferredLanguage() == "Magyar"
          ? "Chat létrehozva ${_selectedFriendIds.length} személlyel!"
          : "Chat created with ${_selectedFriendIds.length} people",
      0.2,
      Colors.green,
      Icons.check,
      Colors.black,
      const Duration(seconds: 2),
      context,
    );
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
                          color: Colors.deepPurpleAccent))
                  : _buildFriendList(),
            ),
          ],
        ),
        bottomNavigationBar: _selectedFriendIds.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _startChat,
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white),
                  label: Text(
                    Preferences.getPreferredLanguage() == "Magyar"
                        ? "Chat létrehozása"
                        : "Start Chat",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildFriendList() {
    final filtered = _friends.where((friend) {
      final username = (friend["username"] as String).toLowerCase();
      return username.contains(_searchQuery.toLowerCase());
    }).toList();

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
            profileImage = SvgPicture.string(svgString,
                width: 60, height: 60, fit: BoxFit.cover);
          } else if (profilePicture.startsWith("data:image/")) {
            profileImage = Image.memory(
              base64Decode(profilePicture.split(",")[1]),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            );
          } else {
            profileImage =
                const Icon(Icons.person, size: 60, color: Colors.white);
          }
        } else {
          profileImage =
              const Icon(Icons.person, size: 60, color: Colors.white);
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[600],
            radius: 30,
            child: ClipOval(child: profileImage),
          ),
          title: Text(
            username,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          trailing: Checkbox(
            value: _selectedFriendIds.contains(friendId),
            onChanged: (_) => _toggleSelection(friendId),
            activeColor: Colors.deepPurpleAccent,
          ),
          onTap: () => _toggleSelection(friendId),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Chat kezdése"
            : "Start chat",
      ),
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 5,
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
