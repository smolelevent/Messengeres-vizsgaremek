import 'package:flutter/material.dart';
import 'package:chatex/chat/sidebar.dart';
import 'package:chatex/chat/bottom_nav_bar.dart';
import 'package:chatex/chat/people.dart';
import 'package:chatex/chat/message_requests.dart';
import 'package:chatex/chat/archived_messages.dart';
import 'package:chatex/chat/settings.dart';
import 'package:sidebarx/sidebarx.dart';

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
        // Ha az "Chatek" van kiválasztva (index = 1), akkor ne maradjon kijelölve sigma
        _sidebarController.selectIndex(0);
      } else {
        // Ha az "Ismerősök" van kiválasztva (index = 1), akkor ne maradjon kijelölve semmi
        _sidebarController.selectIndex(-1);
      }
    });
  }

  Widget _getScreen() {
    switch (_selectedIndex) {
      case 0:
        return const Text("CHAT");
      case 1:
        return const People();
      case 2:
        return const MessageRequests();
      case 3:
        return const ArchivedMessages();
      case 4:
        return const Settings();
      default:
        return const Text("CHAT");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          elevation: 5,
        ),
        drawer: ChatSidebar(
            onSelectPage: _setScreen, sidebarXController: _sidebarController),
        body: _getScreen(),
        bottomNavigationBar: BottomNavbarForChat(
          selectedIndex: _widgetFromSidebar ? -1 : _selectedIndex,
          onItemTapped: (index) => _setScreen(index, isSidebarPage: false),
        ),
      ),
    );
  }
}
