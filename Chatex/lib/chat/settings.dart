import 'package:flutter/material.dart';
import 'package:chatex/chat/sidebar.dart';
import 'package:chatex/chat/bottom_nav_bar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
        body: Text("settings"),
        //bottomNavigationBar: BottomNavbarForChat(),
      ),
    );
  }
}
