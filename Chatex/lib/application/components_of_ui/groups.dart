import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/application/components_of_chat/load_chats.dart';
import 'package:chatex/application/components_of_ui/components_of_groups/dummy_group.dart';
import 'package:chatex/application/components_of_ui/components_of_groups/group_tile.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
import 'dart:developer';

//Groups OSZTÁLY ELEJE ----------------------------------------------------------------------------
class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //ebben a listában tároljuk a csoportokat, mint a _messages lista a load_chats.dart-ban
  late Future<List<dynamic>> _groupList = Future.value([]);

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getCorrectGroupList();
  }

  Future<void> _getCorrectGroupList() async {
    setState(() {
      _groupList = fetchGroupListFromDatabase(
          userId); //eltároljuk az adott felhasználó csoportjait
    });
  }

  Future<List<dynamic>> fetchGroupListFromDatabase(int? userId) async {
    try {
      final Uri groupFetchUrl = Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_group_chats.php");

      final response = await http.post(
        groupFetchUrl,
        body: jsonEncode({
          "user_id": userId
        }), //szintén userId alapján lekérjük a csoportokat
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(
            response.body); //visszatérünk az adatokkal és _groupList-nek adjuk
      } else {
        ToastMessages.showToastMessages(
          lang == "Magyar"
              ? "Nem sikerült betölteni a csoportjaidat!"
              : "Couldn't load your groups!",
          0.3,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        return [];
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        lang == "Magyar"
            ? "Kapcsolati hiba a csoportok betöltésénél!"
            : "Connection error while getting group chats!",
        0.3,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Kapcsolati hiba a csoportok betöltése közben! ${e.toString()}");
      return [];
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: _buildGroupList(),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildEmptyGroups() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
          ),
          children: [
            //TextSpan és WidgetSpan kombinációval a felhasználóknak egyértelmű hogy mit kell csinálniuk ha csoportot akarnak csinálni
            TextSpan(
              text: lang == "Magyar"
                  ? "Még nem vagy tagja egyetlen csoportnak sem.\nCsinálj egyet a "
                  : "You aren't in any group chats.\nCreate one by clicking on the ",
            ),
            const WidgetSpan(
              child: Icon(
                Icons.groups_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: lang == "Magyar" ? " ikonra kattintva!" : " icon!",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupList() {
    return FutureBuilder<List<dynamic>>(
      future:
          _groupList, //a _groupList szerint építjük fel a body-t azért Future mind a kettő
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.deepPurpleAccent,
            ),
          );
        }

        final groupList =
            snapshot.data ?? []; //lokálisan átvesszük a _groupList adatait

        if (groupList.isEmpty) {
          return _buildEmptyGroups();
        }

        return ListView.builder(
          //ha van tartalma a groupList listának akkor buildeljük a csoportokat
          itemCount: groupList.length,
          itemBuilder: (context, index) {
            final group =
                groupList[index]; //group változóval hivatkozunk a listára
            return GroupTile(
              //a GroupTile osztállyal építjük fel a csoportok kártyáit
              groupName: group["group_name"] ?? "a felhasználók nevei",
              lastMessage: group["last_message"] ?? "Nincs még üzenet",
              time: group["last_message_time"] ?? "",
              profileImage: group["group_profile_picture"] ?? "",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DummyGroup(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//Groups OSZTÁLY VÉGE -----------------------------------------------------------------------------
