import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/application/components_of_chat/build_ui.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:developer';
import 'dart:convert';

//ChatInfoScreen OSZTÁLY ELEJE -----------------------------------------------------------------
class ChatInfoScreen extends StatelessWidget {
  const ChatInfoScreen({
    super.key,
    required this.chatId,
  });

  final int chatId;

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  Future<void> _deleteChat(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/chat/set/delete_chat.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "chat_id": chatId, //ezek alapján azonosítjuk a törlést
          "user_id": Preferences.getUserId(),
        }),
      );

      final responseData = jsonDecode(response.body);
      if (responseData["success"] == true) {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "A beszélgetés sikeresen törölve lett!"
              : "Chat deleted successfully!",
          0.2,
          Colors.green,
          Icons.check_rounded,
          Colors.black,
          const Duration(seconds: 4),
          context,
        );

        //a sikeres törlés után visszatérünk a chat listához
        Future.delayed(const Duration(seconds: 4), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ChatUI()),
            (route) => false, // minden route-ot töröl
          );
        });
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt a törlés során!"
              : "Failed to delete chat!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 4),
          context,
        );
        log("Chat törlés sikertelen: ${response.body}");
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a chat törlése közben!"
            : "Connection error while deleting chat!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Kapcsolati hiba a chat törlése közben! $e");
      return;
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: _buildAppBar(),
      body: _buildDeleteChatButton(context),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 10,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      title: Text(
        Preferences.isHungarian ? "Chat információi" : "Chat information",
      ),
    );
  }

  Widget _buildDeleteChatButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
        icon: const Icon(
          Icons.delete,
          size: 40,
        ),
        label: Text(
          Preferences.isHungarian ? "Chat törlése" : "Delete chat",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _deleteChat(context),
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//ChatInfoScreen OSZTÁLY VÉGE ------------------------------------------------------------------
