import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatex/application/components_of_chat/components_of_load_chats/chat_tile.dart';
import 'package:chatex/application/components_of_chat/chat_screen.dart';
import 'package:chatex/logic/permissions.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';
import 'dart:developer';

//LoadedChatData OSZTÁLY ELEJE --------------------------------------------------------------------
class LoadedChatData extends StatefulWidget {
  const LoadedChatData({super.key});

  @override
  LoadedChatDataState createState() => LoadedChatDataState();
}

class LoadedChatDataState extends State<LoadedChatData> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  late Future<List<dynamic>> _chatList = Future.value([]);
  late WebSocketChannel _channel;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    //szükséges a Future.delayed mivel meg kell hogy várja a kis folyamatokat hogy végezzenek
    Future.delayed(Duration.zero, () async {
      await requestNotificationPermission(context);
      await requestDownloadPermission(context);
    });
    _connectToWebSocket();
    _getCorrectChatList();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(
          "ws://10.0.2.2:8080"), //csatlakozunk a websocket szerverhez hogy fél-valós időben frissüljenek az adatok
    );

    _channel.stream.listen((message) {
      //figyelünk minden üzenetet (üzenet = bármilyen adat) ami a websocket szerverre érkezik
      final decodedMessage = jsonDecode(message);
      final type = decodedMessage['type'] ?? 'text';
      final data = decodedMessage['data'] ?? decodedMessage;

      // Csak azokat a chateket frissítse le amik a megfelelő user_id-t tartalmazzák
      if (type == 'message' && data['receiver_id'] == Preferences.getUserId()) {
        _getCorrectChatList(); // újrahívja a chat listát
      }
    });
  }

  Future<void> _getCorrectChatList() async {
    setState(() {
      _chatList = _getChatList(Preferences.getUserId());
    });

    await _chatList;
  }

  Future<List<dynamic>> _getChatList(int? userId) async {
    try {
      final Uri fetchChatsUrl = Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_chats.php");

      final response = await http.post(
        fetchChatsUrl,
        body: jsonEncode({"user_id": userId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Nem sikerült betölteni a chat listát!"
              : "Couldn't load the chat list!",
          0.3,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
        return [];
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a chatek lekérésénél!"
            : "Connection error while getting chats!",
        0.3,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Hiba a chatek lekérése közben: ${e.toString()}");
      return [];
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: _buildChatList(),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildEmptyChatList() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
          ),
          children: [
            TextSpan(
              text: Preferences.isHungarian
                  ? "Még nincs egyetlen csevegésed sem.\nKezdj el egyet a "
                  : "You don't have any chats yet.\nStart one clicking on the ",
            ),
            const WidgetSpan(
              child: Icon(
                Icons.add_comment,
                size: 20,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: Preferences.isHungarian ? " ikonra kattintva!" : " icon!",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return FutureBuilder<List<dynamic>>(
      //_chatList alapján felépítjük a Cardokat
      future: _chatList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //amíg tölt addig karika
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.deepPurpleAccent,
            ),
          );
        }

        final dataFromChatList = snapshot.data ?? [];

        if (dataFromChatList.isEmpty) {
          return _buildEmptyChatList();
        }

        return RefreshIndicator(
          color: Colors.deepPurpleAccent,
          backgroundColor: Colors.black,
          //a manuális chat frissítést engedélyez a RefreshIndicator (fentről való lehúzással)
          onRefresh: _getCorrectChatList,
          child: ListView.builder(
            itemCount: dataFromChatList.length,
            itemBuilder: (context, index) {
              final chat = dataFromChatList[index];

              final String rawMessage =
                  chat["last_message"]?.toString().trim() ?? "";
              final int? lastSenderId = chat["last_sender_id"];
              final int currentUserId = Preferences.getUserId() ?? -1;

              String prefix = "";
              if (lastSenderId == currentUserId) {
                prefix = Preferences.isHungarian ? "Te: " : "You: ";
              }

              String lastMessage;
              if (rawMessage == "[FILE]") {
                lastMessage = prefix +
                    (Preferences.isHungarian
                        ? "📎 Fájl csatolva"
                        : "📎 File attached");
              } else if (rawMessage == "[IMAGE]") {
                lastMessage = prefix +
                    (Preferences.isHungarian
                        ? "🖼️ Kép küldve"
                        : "🖼️ Image sent");
              } else if (rawMessage.isEmpty) {
                lastMessage = Preferences.isHungarian
                    ? "Nincs még üzenet"
                    : "No message yet";
              } else {
                lastMessage = prefix + rawMessage;
              }

              return ChatTile(
                chatName: chat["friend_name"],
                profileImage: chat["friend_profile_picture"] ?? "",
                lastMessage: lastMessage,
                time: chat["last_message_time"] ?? "",
                isOnline: chat["status"],
                signedIn: chat["signed_in"],
                unreadCount: chat["unread_count"] ?? 0,
                onTap: () async {
                  final shouldRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverId: chat["friend_id"],
                        chatName: chat["friend_name"],
                        profileImage: chat["friend_profile_picture"] ?? "",
                        lastSeen: chat["friend_last_seen"],
                        isOnline: chat["status"],
                        signedIn: chat["signed_in"],
                        chatId: chat["chat_id"],
                      ),
                    ),
                  );
                  //Csak akkor frissít, ha szükséges
                  if (shouldRefresh == true) {
                    _getCorrectChatList();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}
//LoadedChatData OSZTÁLY VÉGE ---------------------------------------------------------------------
