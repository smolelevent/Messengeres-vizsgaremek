//import 'package:chatex/main.dart';
import 'package:flutter/material.dart';
import 'package:chatex/auth.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final _sidebarXController =
      SidebarXController(selectedIndex: 0, extended: true);

  int _bottomNavIndex = 0;

  final _pages = [
    Center(child: Text("💬 Chatek", style: TextStyle(fontSize: 24))),
    Center(child: Text("📩 Engedélykérések", style: TextStyle(fontSize: 24))),
    Center(child: Text("📁 Archívum", style: TextStyle(fontSize: 24))),
    Center(child: Text("⚙️ Beállítások", style: TextStyle(fontSize: 24))),
  ];

  final _bottomNavPages = [
    Center(
        child: Text("📋 Lista",
            style: TextStyle(
                fontSize:
                    24))), //TODO: csak az ismerősöknek kell új oldal, valahogy megoldani
    Center(child: Text("⚙️ Profil", style: TextStyle(fontSize: 24))),
  ];

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
        drawer: _sideBar(),
        body: Stack(
          children: [
            _pages[_sidebarXController.selectedIndex], // Sidebar oldal
            _bottomNavPages[_bottomNavIndex], // Bottom NavBar oldal
          ],
        ),
        bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }

  Widget _sideBar() {
    return SidebarX(
      showToggleButton: false,
      controller: _sidebarXController,
      headerBuilder: (context, isCollapsed) {
        return Column(
          children: [
            CircleAvatar(
              // TODO: felhasználó képe, ha nincs akkor a kis ember sziluett alapértelmezetten
              radius: 40,
              backgroundColor: Colors.grey[600],
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "felhasználónév", //TODO: felhasználó neve kell, ha túl hosszú akkor autosizetext
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        );
      },
      headerDivider: Divider(
        height: 50,
        thickness: 2,
        color: Colors.deepPurple[400],
      ),
      items: [
        SidebarXItem(
          label: "Chatek",
          icon: Icons.chat,
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.chat,
              color: Colors.deepPurple[400],
            );
          },
          onTap: () {
            setState(() {
              _sidebarXController.selectIndex(0);
            });
          },
        ),
        SidebarXItem(
          label: "Engedélykérések",
          icon: Icons.chat_outlined,
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.chat_outlined,
              color: Colors.yellow,
            );
          },
          onTap: () {
            setState(() {
              _sidebarXController.selectIndex(1);
            });
          },
        ),
        SidebarXItem(
          label: "Archívum",
          icon: Icons.archive,
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.archive,
              color: Colors.green,
            );
          },
          onTap: () {
            setState(() {
              _sidebarXController.selectIndex(2);
            });
          },
        ),
      ],
      footerItems: [
        SidebarXItem(
          label: "Beállítások",
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.settings,
              color: Colors.blue,
            );
          },
          onTap: () {
            setState(() {
              _sidebarXController.selectIndex(3);
            });
          },
        ),
        SidebarXItem(
          label: "Kijelentkezés",
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.logout,
              color: Colors.red,
            );
          },
          onTap: () async {
            //TODO: biztosan ezt akarod stb..
            await AuthService().logOut(context: context);
          },
        ),
      ],
      theme: SidebarXTheme(
        width: 250, //TODO: olyan megoldás ami mindenhol úgy néz ki!!!!!!!!
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        textStyle: TextStyle(
          //elem
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        selectedTextStyle: TextStyle(
          //elem kiválasztva
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        itemTextPadding: EdgeInsets.symmetric(
            horizontal: 20), // ikon, szöveg közötti távolság
        selectedItemTextPadding: EdgeInsets.symmetric(
            horizontal: 20), //icon, szöveg közötti távolság
        selectedItemDecoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 25,
        ),
        selectedIconTheme: IconThemeData(
          color: Colors.white,
          size: 25,
        ),
      ),
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
