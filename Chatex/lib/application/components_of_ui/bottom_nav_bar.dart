import 'package:flutter/material.dart';
import 'package:chatex/logic/preferences.dart';

//BottomNavbarForChat OSZTÁLY ELEJE ---------------------------------------------------------------
class BottomNavbarForChat extends StatefulWidget {
  const BottomNavbarForChat({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  //melyik oldalon vagyunk ha sidebar elemei közül akkor a -1-en tehát ne legyen kiválasztva semmi különben pedig chatek és ismerősök közül
  final int selectedIndex;

  //_setScreen-t hívjuk meg a build_ui.dart-ban
  final Function(int) onItemTapped;

  @override
  State<BottomNavbarForChat> createState() => _BottomNavbarForChatState();
}

class _BottomNavbarForChatState extends State<BottomNavbarForChat> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Preferences.languageNotifier,
      builder: (context, locale, child) {
        return _buildBottomNavbar();
      },
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildBottomNavbar() {
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
              Icons.chat_rounded,
              Preferences.isHungarian ? "Chatek" : "Chats",
              0,
              const Key("chatNavBar"), // Unique key for the Chats tab
            ),
            _bottomAppBarItem(
              Icons.person_rounded,
              Preferences.isHungarian ? "Ismerősök" : "Friends",
              1,
              const Key("friendsNavBar"), // Unique key for the Friends tab
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomAppBarItem(IconData icon, String label, int index, Key key) {
    //elmentjük egy változóba a konstruktorból meghívott index-t ami egyenlő lett a metódus index-ével
    final bool isSelected = widget.selectedIndex == index;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
          key: key,
          minWidth: 0,
          onPressed: () => widget.onItemTapped(index),
          child: Column(
            //ikon és szöveg egymás alatt legyenek
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: isSelected ? Colors.deepPurpleAccent : Colors.white,
              ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.deepPurpleAccent : Colors.white,
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

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}
//BottomNavbarForChat OSZTÁLY VÉGE ----------------------------------------------------------------
