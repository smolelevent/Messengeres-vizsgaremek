import 'package:flutter/material.dart';
import 'package:chatex/chat/sidebar.dart';
import 'package:chatex/chat/bottom_nav_bar.dart';

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
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          elevation: 5,
        ),
        drawer: ChatSidebar(),
        body: Text("archived messages"),
        //bottomNavigationBar: BottomNavbarForChat(),
      ),
    );
  }
}
