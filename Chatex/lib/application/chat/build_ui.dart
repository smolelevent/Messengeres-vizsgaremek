import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/application/chat/load_chats.dart';
import 'package:chatex/application/elements/elements_of_chat/sidebar.dart';
import 'package:chatex/application/elements/elements_of_chat/bottom_nav_bar.dart';
import 'package:chatex/application/elements/elements_of_chat/people.dart';
import 'package:chatex/application/elements/elements_of_chat/groups.dart';
import 'package:chatex/application/elements/elements_of_chat/settings.dart';
import 'package:chatex/application/chat/start_chat.dart';

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
