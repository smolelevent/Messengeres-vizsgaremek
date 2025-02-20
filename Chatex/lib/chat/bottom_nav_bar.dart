import 'package:chatex/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:chatex/chat/people.dart';

class BottomNavbarForChat extends StatefulWidget {
  const BottomNavbarForChat({super.key});
  final int _selectedIndex = 0;

  @override
  State<BottomNavbarForChat> createState() => _BottomNavbarForChatState();
}

class _BottomNavbarForChatState extends State<BottomNavbarForChat> {
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    ChatUI(),
    People(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = _currentIndex == 0 ? ChatUI() : People();
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _bottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.deepPurple[400],
        unselectedItemColor: Colors.white,
        currentIndex: _bottomNavIndex,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chatek",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Ismerősök",
          ),
        ],
      ),
    );
  }
}
