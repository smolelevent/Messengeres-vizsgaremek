import 'package:flutter/material.dart';
import 'package:chatex/chat/sidebar.dart';

class ArchivedMessages extends StatefulWidget {
  const ArchivedMessages({super.key});

  @override
  State<ArchivedMessages> createState() => _ArchivedMessagesState();
}

class _ArchivedMessagesState extends State<ArchivedMessages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          elevation: 5,
        ),
        drawer: ChatSidebar(),
        body: Text("data"),
        // Stack(
        //   children: [
        //     _pages[_sidebarXController.selectedIndex], // Sidebar oldal
        //     _bottomNavPages[_bottomNavIndex], // Bottom NavBar oldal
        //   ],
        // ),
        //bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }
}
