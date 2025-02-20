import 'package:chatex/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:chatex/chat/people.dart';

class BottomNavbarForChat extends StatefulWidget {
  BottomNavbarForChat(
      {super.key}); //TODO: VALAMI DURVA HIBA 20+ ERROR NEM FUT LE!!!! VIDEÓBÓL REVERSE
  BottomNavbarForChat.neves({super.key, required this.selectedIndex});
  int selectedIndex = 0;

  @override
  State<BottomNavbarForChat> createState() => _BottomNavbarForChatState();
}

class _BottomNavbarForChatState extends State<BottomNavbarForChat> {
  int _currentIndex = 0;

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: BottomAppBar(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        setState(() {
                          currentScreen = ChatUI();
                          _currentIndex = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: _currentIndex == 0
                                ? Colors.deepPurple[400]
                                : Colors.grey[400],
                          ),
                          Text(
                            'Chatek',
                            style: TextStyle(
                              color: _currentIndex == 0
                                  ? Colors.deepPurple[400]
                                  : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        setState(() {
                          currentScreen = People();
                          _currentIndex = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: _currentIndex == 1
                                ? Colors.deepPurple[400]
                                : Colors.grey[400],
                          ),
                          Text(
                            'Ismerősök',
                            style: TextStyle(
                              color: _currentIndex == 1
                                  ? Colors.deepPurple[400]
                                  : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _bottomNavBar() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.grey[700],
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //       ),
  //     ),
  //     child: BottomAppBar(
  //       child: Container(
  //         child: Row(
  //           children: [
  //             MaterialButton(
  //               minWidth: 50,
  //               onPressed: () {
  //                 setState(() {
  //                   currentScreen = ChatUI();
  //                   _currentIndex = 0;
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
