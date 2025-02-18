//import 'package:chatex/main.dart';
import 'package:flutter/material.dart';
import 'package:chatex/auth.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:form_builder_validators/form_builder_validators.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

//final _formKey = GlobalKey<FormBuilderState>();

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final _sidebarXController =
      SidebarXController(selectedIndex: 0, extended: true);

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              'Chat',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 35,
              ),
            ),
            _logOut(context),
          ],
        ),
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
              radius: 40,
              backgroundImage: AssetImage(
                  "assets/profile.jpg"), // TODO: felhasználó képe, ha nincs akkor a kis ember sziluett alapértelmezetten
            ),
            SizedBox(height: 10),
            Text(
              "lorem ipsum", //TODO: felhasználó neve kell, ha túl hosszú akkor autosizetext
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      },
      headerDivider: Text("divider"), //TODO: csík dividert
      items: [
        SidebarXItem(
          label: "Chatek",
          icon: Icons.chat,
        ),
        SidebarXItem(
          label: "Engedélykérések",
          icon: Icons.chat_outlined,
        ),
        SidebarXItem(
          label: "Archívum",
          icon: Icons.archive,
        ),
      ],
      footerItems: [
        SidebarXItem(
          label: "Beállítások",
          icon: Icons.settings,
        ),
        SidebarXItem(
          label: "Kijelentkezés",
          iconBuilder: (context, isSelected) {
            return Icon(
              Icons.logout,
              color: Colors.red,
            );
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
          color: Colors.grey[700],
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

  Widget _logOut(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().logOut(context: context);
      },
      child: const Text("Sign Out"),
    );
  }
}
