import 'package:chatex/chat/archived_messages.dart';
import 'package:chatex/chat/message_requests.dart';
import 'package:chatex/chat/settings.dart';
import 'package:chatex/chat/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:chatex/chat/bottom_nav_bar.dart';
import 'package:chatex/chat/chat.dart';
import 'package:chatex/chat/people.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  int _selectedIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  final List<Widget> _pages = [
    Text("valami"),
    People(),
    MessageRequests(),
    Settings(),
    ArchivedMessages(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        elevation: 5,
      ),
      drawer: ChatSidebar(), // ✅ Megmarad a sidebar!
      body: PageStorage(
        bucket: _bucket,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavbarForChat(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// import 'package:chatex/chat/sidebar.dart';
// import 'package:flutter/material.dart';
// import 'package:chatex/chat/bottom_nav_bar.dart';

// class ChatUI extends StatefulWidget {
//   const ChatUI({super.key});

//   @override
//   State<ChatUI> createState() => _ChatUIState();
// }

// class _ChatUIState extends State<ChatUI> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.grey[850],
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple[400],
//         elevation: 5,
//       ),
//       drawer: ChatSidebar(),
//       body: Text("chat"), //TODO: csak ezzel jó nem nem
//       //bottomNavigationBar: BottomNavbarForChat(),
//     );
//   }
// }
