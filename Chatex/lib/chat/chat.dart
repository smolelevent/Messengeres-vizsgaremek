import 'package:chatex/chat/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:chatex/chat/bottom_nav_bar.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  int _bottomNavIndex = 0;

  final _pages = [
    null,
    //Center(child: Text("💬 Chatek", style: TextStyle(fontSize: 24))),
    Center(
        child: Text("📩 Engedélykérések",
            style: TextStyle(fontSize: 24, color: Colors.white))),
    Center(
        child: Text("📁 Archívum",
            style: TextStyle(fontSize: 24, color: Colors.white))),
    Center(
        child: Text("⚙️ Beállítások",
            style: TextStyle(fontSize: 24, color: Colors.white))),
  ];

//TODO: csak az ismerősöknek kell új oldal, valahogy megoldani
  final _bottomNavPages = [
    Center(
        child: Text("📋 Chatek",
            style: TextStyle(fontSize: 24, color: Colors.white))),
    Center(
        child: Text("⚙️ Ismerősök",
            style: TextStyle(fontSize: 24, color: Colors.white))),
  ];

  /// **Ez a függvény határozza meg, hogy melyik oldal látszódjon**
  // Widget _getBody() {
  //   if (_sidebarXController.selectedIndex == 0) {
  //     // Ha a Sidebar első (Chatek) eleme van kiválasztva, akkor az alsó nav alapján változik a tartalom
  //     return _bottomNavPages[_bottomNavIndex];
  //   } else {
  //     // Ha a Sidebar másik eleme van kiválasztva, azt jelenítjük meg
  //     return _pages[_sidebarXController.selectedIndex]!;
  //   }
  // }

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
        body: Text("chat"),
        // Stack(
        //   children: [
        //     _pages[_sidebarXController.selectedIndex], // Sidebar oldal
        //     _bottomNavPages[_bottomNavIndex], // Bottom NavBar oldal
        //   ],
        // ),
        bottomNavigationBar: BottomNavbarForChat.neves(selectedIndex: 0),
      ),
    );
  }

  // Widget _sideBar() {
  //   return SidebarX(
  //     showToggleButton: false,
  //     controller: _sidebarXController,
  //     headerBuilder: (context, isCollapsed) {
  //       return Column(
  //         children: [
  //           CircleAvatar(
  //             // TODO: felhasználó képe, ha nincs akkor a kis ember sziluett alapértelmezetten
  //             radius: 40,
  //             backgroundColor: Colors.grey[600],
  //             child: Icon(
  //               Icons.person,
  //               size: 40,
  //               color: Colors.white,
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Text(
  //             "felhasználónév", //TODO: felhasználó neve kell, ha túl hosszú akkor autosizetext
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 18,
  //               letterSpacing: 1,
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //     headerDivider: Divider(
  //       height: 50,
  //       thickness: 2,
  //       color: Colors.deepPurple[400],
  //     ),
  //     items: [
  //       SidebarXItem(
  //         label: "Chatek",
  //         iconBuilder: (context, isSelected) {
  //           return Icon(
  //             Icons.chat,
  //             color: Colors.deepPurple[400],
  //           );
  //         },
  //         onTap: () {
  //           setState(() {
  //             _sidebarXController.selectIndex(0);
  //           });
  //           Navigator.pop(context);
  //         },
  //       ),
  //       SidebarXItem(
  //         label: "Engedélykérések",
  //         iconBuilder: (context, isSelected) {
  //           return Icon(
  //             Icons.chat_outlined,
  //             color: Colors.yellow,
  //           );
  //         },
  //         onTap: () {
  //           setState(() {
  //             _sidebarXController.selectIndex(1);
  //           });
  //           Navigator.pop(context);
  //         },
  //       ),
  //       SidebarXItem(
  //         label: "Archívum",
  //         iconBuilder: (context, isSelected) {
  //           return Icon(
  //             Icons.archive,
  //             color: Colors.green,
  //           );
  //         },
  //         onTap: () {
  //           setState(() {
  //             _sidebarXController.selectIndex(2);
  //           });
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ],
  //     footerItems: [
  //       SidebarXItem(
  //         label: "Beállítások",
  //         iconBuilder: (context, isSelected) {
  //           return Icon(
  //             Icons.settings,
  //             color: Colors.blue,
  //           );
  //         },
  //         onTap: () {
  //           setState(() {
  //             _sidebarXController.selectIndex(3);
  //           });
  //           Navigator.pop(context);
  //         },
  //       ),
  //       SidebarXItem(
  //         label: "Kijelentkezés",
  //         iconBuilder: (context, isSelected) {
  //           return Icon(
  //             Icons.logout,
  //             color: Colors.red,
  //           );
  //         },
  //         onTap: () async {
  //           //TODO: biztosan ezt akarod stb..
  //           await AuthService().logOut(context: context);
  //         },
  //       ),
  //     ],
  //     theme: SidebarXTheme(
  //       width: 250, //TODO: olyan megoldás ami mindenhol úgy néz ki!!!!!!!!
  //       padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
  //       textStyle: TextStyle(
  //         //elem
  //         color: Colors.white,
  //         fontSize: 15,
  //         fontWeight: FontWeight.w500,
  //         letterSpacing: 1,
  //       ),
  //       selectedTextStyle: TextStyle(
  //         //elem kiválasztva
  //         color: Colors.white,
  //         fontSize: 15,
  //         fontWeight: FontWeight.w500,
  //         letterSpacing: 1,
  //       ),
  //       itemTextPadding: EdgeInsets.symmetric(
  //           horizontal: 20), // ikon, szöveg közötti távolság
  //       selectedItemTextPadding: EdgeInsets.symmetric(
  //           horizontal: 20), //icon, szöveg közötti távolság
  //       selectedItemDecoration: BoxDecoration(
  //         color: Colors.grey[800],
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[850],
  //         borderRadius: BorderRadius.only(
  //           topRight: Radius.circular(20),
  //           bottomRight: Radius.circular(20),
  //         ),
  //       ),
  //       iconTheme: IconThemeData(
  //         color: Colors.white,
  //         size: 25,
  //       ),
  //       selectedIconTheme: IconThemeData(
  //         color: Colors.white,
  //         size: 25,
  //       ),
  //     ),
  //   );
  // }

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
