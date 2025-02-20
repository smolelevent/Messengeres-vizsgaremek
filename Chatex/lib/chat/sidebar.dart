import 'package:chatex/chat/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/auth.dart';
import 'package:chatex/chat/chat.dart';
import 'package:chatex/chat/message_requests.dart';
import 'package:chatex/chat/archived_messages.dart';
import 'package:chatex/chat/settings.dart';

class ChatSidebar extends StatefulWidget {
  const ChatSidebar({super.key});

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  final _sidebarXController =
      SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
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
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.chat,
              color: Colors.deepPurple[400],
            );
          },
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BottomNavbarForChat.neves(selectedIndex: 0)));
            //Navigator.pop(context);
          },
        ),
        SidebarXItem(
          label: "Engedélykérések",
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.chat_outlined,
              color: Colors.yellow,
            );
          },
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MessageRequests()));
            //Navigator.pop(context);
          },
        ),
        SidebarXItem(
          label: "Archívum",
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.archive,
              color: Colors.green,
            );
          },
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ArchivedMessages()));
            //Navigator.pop(context);
            // setState(() {
            //   _sidebarXController.selectIndex(2);
            // });
            //Navigator.pushReplacement(context, Archive());
            //Navigator.pop(context);
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
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Settings()));
            //Navigator.pop(context);
            // setState(() {
            //   _sidebarXController.selectIndex(3);
            // });
            //Navigator.pushReplacement(context, Settings());
            //Navigator.pop(context);
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
}
