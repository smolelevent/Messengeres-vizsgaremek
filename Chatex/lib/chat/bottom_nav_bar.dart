import 'package:flutter/material.dart';

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
            _bottomAppBarItem(Icons.chat, "Chatek", 0),
            _bottomAppBarItem(Icons.person, "Ismerősök", 1),
          ],
        ),
      ),
    );
  }

  Widget _bottomAppBarItem(IconData icon, String label, int index) {
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
