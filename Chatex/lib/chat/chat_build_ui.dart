import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/chat/chat_load.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/chat/elements/elements_of_chat/sidebar.dart';
import 'package:chatex/chat/elements/elements_of_chat/bottom_nav_bar.dart';
import 'package:chatex/chat/elements/elements_of_chat/people.dart';
import 'package:chatex/chat/elements/elements_of_chat/groups.dart';
import 'package:chatex/chat/elements/elements_of_chat/settings.dart';

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
        return LoadedChatData();
      case 1:
        return const People();
      case 2:
        return const Groups();
      case 3:
        return const Settings();
      default:
        return LoadedChatData();
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

class StartChat extends StatefulWidget {
  const StartChat({super.key});

  @override
  State<StartChat> createState() => _StartChatState();
}

class _StartChatState extends State<StartChat> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";

  _buildAppbar() {
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
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
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 28),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white70, width: 2.5),
          ),
        ),
      ),
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
              //TODO: azokat megjeleníteni akik a barátaid, csoport opció is, alul gomb hogy chat létrehozása, miután kész a chat akkor egyből dobjon oda
              padding: EdgeInsets.symmetric(vertical: 15),
              child: _buildSearchField(),
            ),
          ],
        ),
      ),
    );
  }
}
