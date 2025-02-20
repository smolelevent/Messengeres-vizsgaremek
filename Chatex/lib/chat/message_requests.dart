import 'package:flutter/material.dart';
import 'package:chatex/chat/sidebar.dart';
import 'package:chatex/chat/bottom_nav_bar.dart';

class MessageRequests extends StatefulWidget {
  const MessageRequests({super.key});

  @override
  State<MessageRequests> createState() => _MessageRequestsState();
}

class _MessageRequestsState extends State<MessageRequests> {
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
        body: Text("message requests"),
        // Stack(
        //   children: [
        //     _pages[_sidebarXController.selectedIndex], // Sidebar oldal
        //     _bottomNavPages[_bottomNavIndex], // Bottom NavBar oldal
        //   ],
        // ),
        bottomNavigationBar: BottomNavbarForChat(),
      ),
    );
  }
}
