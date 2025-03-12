// import 'package:flutter/material.dart';

// class BottomNavbarForChat extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//   final String language; // Nyelv hozzáadása

//   const BottomNavbarForChat({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//     required this.language,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(15),
//         topRight: Radius.circular(15),
//       ),
//       child: BottomAppBar(
//         color: Colors.grey[800],
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _bottomAppBarItem(Icons.chat, language == "Magyar" ? "Chatek" : "Chats", 0),
//             _bottomAppBarItem(Icons.person, language == "Magyar" ? "Ismerősök" : "Friends", 1),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _bottomAppBarItem(IconData icon, String label, int index) {
//     return MaterialButton(
//       onPressed: () => onItemTapped(index),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 30, color: selectedIndex == index ? Colors.deepPurple[400] : Colors.white),
//           Text(label, style: TextStyle(color: selectedIndex == index ? Colors.deepPurple[400] : Colors.white)),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:chatex/logic/preferences.dart';

class BottomNavbarForChat extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavbarForChat({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<BottomNavbarForChat> createState() => _BottomNavbarForChatState();
}

class _BottomNavbarForChatState extends State<BottomNavbarForChat> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: BottomAppBar(
        color: Colors.grey[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomAppBarItem(
                Icons.chat,
                Preferences.getPreferredLanguage() == "Magyar"
                    ? "Chatek"
                    : "Chats",
                0,
                Key("chatNavBar")),
            _bottomAppBarItem(
                Icons.person,
                Preferences.getPreferredLanguage() == "Magyar"
                    ? "Ismerősök"
                    : "Friends",
                1,
                Key("friendsNavBar")),
          ],
        ),
      ),
    );
  }

  Widget _bottomAppBarItem(IconData icon, String label, int index, Key key) {
    final bool isSelected = widget.selectedIndex == index;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
          minWidth: 0,
          onPressed: () => widget.onItemTapped(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: isSelected ? Colors.deepPurple[400] : Colors.white,
              ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.deepPurple[400] : Colors.white,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
