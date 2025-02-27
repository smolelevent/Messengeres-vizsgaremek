import 'package:flutter/material.dart';
import 'package:chatex/chat/sidebar.dart';
import 'package:chatex/chat/bottom_nav_bar.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        elevation: 5,
      ),
      drawer: ChatSidebar(),
      body: Text("ismerősök"),
      //bottomNavigationBar: BottomNavbarForChat(selectedIndex: 1), //TODO: kifagy ha ezeket megadom, chatre is igaz
    );
  }
}
