import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:image_picker/image_picker.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:chatex/logic/notifications.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatName,
    required this.profileImage,
    required this.isOnline,
    required this.lastSeen,
    required this.signedIn,
    required this.chatId,
    required this.receiverId,
  });

  final String chatName;
  final String profileImage;
  final String isOnline;
  final String lastSeen;
  final int signedIn;
  final int chatId;
  final int receiverId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

//TODO: mindig frissül a pfp a php miatt

//TODO: chat gpt-n a választ megcsinálni a NULL-os message_text-ekről hogy jól jelenjen meg a file mert jelenleg egy üres mezőt ad vissza és nem magát a fájlt de amúgy a file letöltás működött legutóbb és a szerver sem crashelt!

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isInputFocused = false;
  //bool _isWriting = false;

  bool get _shouldShowSendIcon {
    return _messageController.text.trim().isNotEmpty ||
        _attachedFiles.isNotEmpty;
  }

  late WebSocketChannel _channel;
  List<Map<String, dynamic>> _messages = <Map<String, dynamic>>[];

  bool _showScrollToBottom = false;

  final List<PlatformFile> _attachedFiles = [];

  Timer? _keepAliveTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _connectToWebSocket();
    _markMessagesAsRead();
    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });
    });

    _messageController.addListener(() {
      setState(() {
        //_isWriting = _messageController.text.trim().isNotEmpty;
        //_isInputFocused = _isWriting;
        _isInputFocused = _messageController.text.trim().isNotEmpty;
      });
    });

    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final distanceFromBottom =
          _scrollController.position.maxScrollExtent - _scrollController.offset;

      // Ha eltávolodott a lista aljától egy bizonyos arányban, mutassuk a gombot
      const thresholdRatio = 0.25; // alsó százalék hogy hol jelenjen meg a gomb
      final shouldShow = distanceFromBottom >
          _scrollController.position.maxScrollExtent * thresholdRatio;

      if (_showScrollToBottom != shouldShow) {
        setState(() {
          _showScrollToBottom = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    _keepAliveTimer?.cancel();
    _channel.sink.close();
    _messageController.dispose();
    _inputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_messages.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"chat_id": widget.chatId}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<Map<String, dynamic>> loadedMessages = [];

      for (final message in responseData['messages']) {
        final messageType = message['message_type'];

        // Ha van csatolmány (új struktúra alapján)
        if (messageType == 'file' || messageType == 'image') {
          final attachments = message['attachments'] ?? [];

          final fileNames = <String>[];
          final downloadUrls = <String>[];

          for (final att in attachments) {
            fileNames.add(att['file_name']);
            downloadUrls.add(att['download_url']); //file_url volt
          }

          loadedMessages.add({
            ...message,
            'fileNames': fileNames,
            'downloadUrls': downloadUrls,
            'message_text': (message['message_text'] as String).trim().isEmpty
                ? null
                : message['message_text'], // ← EZT ADD HOZZÁ
          });
        } else {
          loadedMessages.add(message);
        }
      }

      setState(() {
        _messages = loadedMessages;
      });

      scrollToBottom();
    } else {
      log("❌ Hiba történt az üzenetek lekérésekor: ${response.body}");
    }
  }

  // void _connectToWebSocket() { mentés
  //   /*INDÍTÁS ELŐTT FUTTATNI KELL A PHP-T: xampp_server\htdocs\ChatexProject\chatex_phps> php server_run.php,
  //   A terminálba Ctrl + Shift + C-t nyomva lehet írni read-only terminálba!*/

  //   _channel = WebSocketChannel.connect(
  //     Uri.parse("ws://10.0.2.2:8080"),
  //   );

  //   log("Chat screen WebSocket connected");

  //   _channel.stream.listen((message) {
  //     final decoded = jsonDecode(message);

  //     final type = decoded['message_type'] ?? 'text';
  //     final data = decoded['data'] ?? decoded;

  //     if (data['chat_id'] != widget.chatId) return;

  //     final messageId = data['message_id'];
  //     final index =
  //         _messages.indexWhere((msg) => msg['message_id'] == messageId);

  //     switch (type) {
  //       case 'file':
  //       final attachments = data['attachments'] ?? [];
  // final fileNames = <String>[];
  // final downloadUrls = <String>[];

  // for (final att in attachments) {
  //   fileNames.add(att['file_name']);
  //   downloadUrls.add(att['file_url']);
  // }

  // setState(() {
  //   _messages.add({
  //     ...data,
  //     'fileNames': fileNames,
  //     'downloadUrls': downloadUrls,
  //   });
  // });

  // scrollToBottom();
  //       case 'image':
  //       case 'text':
  //         if (index == -1) {
  //           setState(() {
  //             _messages.add(data);
  //           });
  //         }

  //         final isForMe = data['receiver_id'] == Preferences.getUserId();
  //         if (isForMe) {
  //           Future.delayed(const Duration(milliseconds: 500), () {
  //             _channel.sink.add(jsonEncode({
  //               "message_type": "read_status_update",
  //               "chat_id": widget.chatId,
  //               "user_id": Preferences.getUserId(),
  //             }));
  //           });
  //         }
  //         scrollToBottom();
  //         break;

  //       case 'message_read':
  //         if (index != -1) {
  //           setState(() {
  //             _messages[index] = data;
  //           });
  //         }
  //         break;

  //       default:
  //         log("Ismeretlen websocket típus: $type");
  //     }
  //   });
  // }

  void _connectToWebSocket() {
    /*INDÍTÁS ELŐTT FUTTATNI KELL A PHP-T: xampp_server\htdocs\ChatexProject\chatex_phps> php server_run.php,
    A terminálba Ctrl + Shift + C-t nyomva lehet írni read-only terminálba!*/
    _channel = WebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8080"),
    );

    log("Chat screen WebSocket connected");

    _channel.stream.listen((message) {
      final decoded = jsonDecode(message);

      final type = decoded['message_type'] ?? 'text';
      final data = decoded['data'] ?? decoded;

      if (data['chat_id'] != widget.chatId) return;

      final messageId = data['message_id'];
      final index =
          _messages.indexWhere((msg) => msg['message_id'] == messageId);

      // 🔁 Ne duplikáljunk
      if (index != -1) return;

      // 👁‍🗨 Jelzés ha ez nekem szól
      final isForMe = data['receiver_id'] == Preferences.getUserId();
      if (isForMe) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _channel.sink.add(jsonEncode({
            "message_type": "read_status_update",
            "chat_id": widget.chatId,
            "user_id": Preferences.getUserId(),
          }));
        });
      }

      switch (type) {
        case 'file':
          final attachments = data['attachments'] ?? [];
          final fileNames = <String>[];
          final downloadUrls = <String>[];

          for (final att in attachments) {
            fileNames.add(att['file_name']);
            downloadUrls.add(att['download_url']);
          }

          setState(() {
            // Ha van szöveg, előbb egy szöveges buborék
            if ((data['message_text'] ?? '').toString().trim().isNotEmpty) {
              _messages.add({
                ...data,
                'message_type': 'text',
              });
            }

            // Majd egy külön fájl buborék
            _messages.add({
              ...data,
              'message_type': 'file',
              'fileNames': fileNames,
              'downloadUrls': downloadUrls,
              'message_text': null, // ne jelenjen meg még egyszer
            });
          });
          // // Ha van szöveg, előbb egy szöveges buborék
          // if ((data['message_text'] ?? '').toString().trim().isNotEmpty) {
          //   _messages.add({
          //     ...data,
          //     'message_type': 'text',
          //   });
          // }

          // // Majd egy külön fájl buborék
          // _messages.add({
          //   ...data,
          //   'message_type': 'file',
          //   'fileNames': fileNames,
          //   'downloadUrls': downloadUrls,
          //   'message_text': null, // ne jelenjen meg még egyszer
          // });

          //setState(() {});
          scrollToBottom();
          break;

        case 'text':
        case 'image':
          // TODO: Hasonló logika image-re, ha már implementálod
          setState(() {
            _messages.add(data);
          });
          scrollToBottom();
          break;

        case 'message_read':
          if (index != -1) {
            setState(() {
              _messages[index] = data;
            });
          }
          break;

        default:
          log("Ismeretlen websocket típus: $type");
      }
    });

    _keepAliveTimer?.cancel(); // ha már létezik
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      _channel.sink.add(jsonEncode({"message_type": "ping"}));
      log("Keep-alive ping sent");
    });
  }

  void _sendMessage() {
    final message = {
      "message_type": "text",
      "chat_id": widget.chatId,
      "sender_id": Preferences.getUserId(),
      "receiver_id": widget.receiverId,
      "message_text":
          _messageController.text.trim(), //egyenlőre trimmeljük lehet nem kell
    };

    _channel.sink.add(jsonEncode(message));
    scrollToBottom();
    _messageController.clear();
  }

  void _sendFiles() {
    if (_attachedFiles.isEmpty) return;

    final List<Map<String, dynamic>> files = _attachedFiles.map((file) {
      return {
        "file_name": file.name,
        "file_bytes": base64Encode(file.bytes!),
      };
    }).toList();

    final message = {
      "message_type": "file",
      "chat_id": widget.chatId,
      "sender_id": Preferences.getUserId(),
      "receiver_id": widget.receiverId,
      "message_text": _messageController.text.trim(),
      "files": files,
    };

    _channel.sink.add(jsonEncode(message));

    setState(() {
      _attachedFiles.clear();
      _messageController.clear();
    });

    scrollToBottom();
  }

  // Future<void> _sendImageFromGallery() async { //TODO: ezeket ha lehet
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);

  //   if (picked != null) {
  //     final bytes = await picked.readAsBytes();
  //     final base64Image = base64Encode(bytes);

  //     final message = {
  //       "message_type": "image",
  //       "chat_id": widget.chatId,
  //       "sender_id": Preferences.getUserId(),
  //       "receiver_id": widget.receiverId,
  //       "file_name": picked.name,
  //       "image_data": base64Image,
  //       "message_text": _messageController.text.trim(),
  //     };

  //     _channel.sink.add(jsonEncode(message));

  //     _messageController.clear();
  //     scrollToBottom();
  //   }
  // }

  // Future<void> _sendImageFromCamera() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.camera);

  //   if (picked != null) {
  //     final bytes = await picked.readAsBytes();
  //     final base64Image = base64Encode(bytes);

  //     final message = {
  //       "message_type": "image",
  //       "chat_id": widget.chatId,
  //       "sender_id": Preferences.getUserId(),
  //       "receiver_id": widget.receiverId,
  //       "file_name": picked.name,
  //       "image_data": base64Image,
  //       "message_text": _messageController.text.trim(),
  //     };

  //     _channel.sink.add(jsonEncode(message));

  //     _messageController.clear();
  //     scrollToBottom();
  //   }
  // }

  void _handleSend() {
    final hasText = _messageController.text.trim().isNotEmpty;
    final hasFiles = _attachedFiles.isNotEmpty;

    final oversized = _attachedFiles.any((f) => f.size > 100 * 1024 * 1024);
    if (oversized) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              //TODO: nincs letesztelve
              Preferences.getPreferredLanguage() == "Magyar"
                  ? "Túl nagy fájl!"
                  : "File too large!",
            ),
            content: Text(
              Preferences.getPreferredLanguage() == "Magyar"
                  ? "Csak 100 MB alatti fájlokat lehet küldeni."
                  : "Only files under 100 MB can be sent.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (hasFiles) {
      _sendFiles(); // Ez lekezeli a fájlokat és törli őket
    } else if (hasText) {
      _sendMessage(); // Ez törli a beviteli mezőt
    }
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/chat/set/mark_as_read.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "chat_id": widget.chatId,
          "user_id": widget.receiverId,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log("Messages marked as read successfully: ${responseData.toString()}");
        _channel.sink.add(jsonEncode({
          "message_type": "read_status_update",
          "chat_id": widget.chatId,
          "user_id": Preferences.getUserId(),
        }));
      } else {
        log("Failed to mark messages as read: ${responseData.toString()}");
      }
    } catch (e) {
      log("Error marking messages as read: $e");
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  String formatLastSeen(String lastSeenString) {
    try {
      final lastSeen = DateTime.parse(lastSeenString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(lastSeen);

      if (difference.inMinutes < 1) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "Épp most"
            : "Just now";
      } else if (difference.inMinutes < 60) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "${difference.inMinutes} perce"
            : "${difference.inMinutes} minute(s) ago";
      } else if (difference.inHours < 24) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "${difference.inHours} órája"
            : "${difference.inHours} hour(s) ago";
      } else if (difference.inDays == 1) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "Tegnap"
            : "Yesterday";
      } else if (difference.inDays == 2) {
        return Preferences.getPreferredLanguage() == "Magyar"
            ? "Tegnap előtt"
            : "The day before yesterday";
      } else {
        final formattedDate =
            "${lastSeen.year}.${lastSeen.month.toString().padLeft(2, '0')}.${lastSeen.day.toString().padLeft(2, '0')} "
            "${lastSeen.hour.toString().padLeft(2, '0')}:${lastSeen.minute.toString().padLeft(2, '0')}:${lastSeen.second.toString().padLeft(2, '0')}";
        return formattedDate;
      }
    } catch (_) {
      return Preferences.getPreferredLanguage() == "Magyar"
          ? "Hiba!"
          : "Error!";
    }
  }

  Widget _emptyChat() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Ez a beszélgetés még üres."
              : "The chat is empty.",
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    if (_messages.isEmpty) return _emptyChat();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isSender = message['sender_id'] == Preferences.getUserId();
        final isLast = index == _messages.length - 1;
        final messageType = message['message_type'];

        switch (messageType) {
          case 'file':
            final fileNames = List<String>.from(message['fileNames'] ?? []);
            final downloadUrls =
                List<String>.from(message['downloadUrls'] ?? []);
            log("Download url: ${message['downloadUrls'].toString()}");

            return FileChatBubble(
              fileNames: fileNames,
              downloadUrls: downloadUrls,
              messageText: message['message_text'],
              sentAt: formatLastSeen(message['sent_at'] ?? ""),
              isSender: isSender,
              isRead: message['is_read'] == 1,
              profileImage: isSender ? null : widget.profileImage,
              onTapScrollToBottom: scrollToBottom,
              isLastMessage: isLast,
            );

          // case 'image': TODO: ezt később
          //   return ImageChatBubble(
          //     imageUrl: message['message_file'] ?? "",
          //     messageText: message['message_text'] ?? "",
          //     sentAt: formatLastSeen(message['sent_at'] ?? ""),
          //     isSender: isSender,
          //     profileImage: isSender ? null : widget.profileImage,
          //     isRead: message['is_read'] == 1,
          //     onTapScrollToBottom: scrollToBottom,
          //     isLastMessage: isLast,
          //   );

          case 'text':
          default:
            return MessageChatBubble(
              messageText: message['message_text'] ?? "",
              sentAt: formatLastSeen(message['sent_at'] ?? ""),
              isSender: isSender,
              isRead: message['is_read'] == 1,
              profileImage: isSender ? null : widget.profileImage,
              onTapScrollToBottom: scrollToBottom,
              isLastMessage: isLast,
            );
        }
      },
    );
  }

  Widget _buildScrollToBottomButton() {
    return _showScrollToBottom
        ? Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 140 : 65,
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.grey[800],
              tooltip: Preferences.getPreferredLanguage() == "Magyar"
                  ? "Ugrás az aljára"
                  : "Scroll to bottom",
              elevation: 10,
              mini: true,
              shape: const CircleBorder(),
              onPressed: scrollToBottom,
              child: const Icon(
                Icons.keyboard_double_arrow_down_rounded,
                color: Colors.white,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildFilePreviewBar() {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 65),
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _attachedFiles.length,
        itemBuilder: (context, index) {
          final file = _attachedFiles[index];
          final isImage = file.extension?.toLowerCase().startsWith("jp") ==
                  true || //TODO: képnél ezt megnézni
              ["png", "gif", "webp"].contains(file.extension?.toLowerCase());

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepPurpleAccent),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isImage
                          ? Image.memory(file.bytes!, width: 40, height: 40)
                          : const Icon(Icons.insert_drive_file,
                              color: Colors.white, size: 30),
                      const SizedBox(height: 4),
                      Text(
                        file.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 9, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: GestureDetector(
                    onTap: () => setState(() => _attachedFiles.removeAt(index)),
                    child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

//TODO: folytonossá tenni a people.dart-ot is
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _buildScrollToBottomButton(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[850],
        appBar: _buildAppBar(),
        body: MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: (_buildMessageList())),
                  if (_attachedFiles.isNotEmpty) _buildFilePreviewBar(),
                ],
              ),
            ],
          ),
        ),
        bottomSheet: _buildBottomBar(),
      ),
    );
  }

  Widget _buildIcon({
    required Color color,
    required String hunTooltip,
    required String engTooltip,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      color: color,
      focusColor: Colors.deepPurpleAccent,
      tooltip: Preferences.getPreferredLanguage() == "Magyar"
          ? hunTooltip
          : engTooltip,
      icon: Icon(
        icon,
        size: 26,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildProfileImage(String imageString, String isOnline, int signedIn) {
    Widget imageWidget;

    if (imageString.startsWith("data:image/svg+xml;base64,")) {
      final svgBytes = base64Decode(imageString.split(",")[1]);
      imageWidget = SvgPicture.memory(
        svgBytes,
        width: 48,
        height: 48,
        fit: BoxFit.fill,
      );
    } else if (imageString.startsWith("data:image/")) {
      final base64Data = base64Decode(imageString.split(",")[1]);
      imageWidget = Image.memory(
        base64Data,
        width: 48,
        height: 48,
        fit: BoxFit.fill,
      );
    } else {
      imageWidget = const Icon(
        Icons.person,
        size: 30,
        color: Colors.white,
      );
    }

    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[800],
              child: ClipOval(
                child: imageWidget,
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isOnline == "online" && signedIn == 1
                    ? Colors.green
                    : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//TODO: chaten valósidőbe kezelni az adatokat, last seen, online, üzenet stb...
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.deepPurpleAccent,
        shadowColor: Colors.deepPurpleAccent,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        titleSpacing: 0,
        leadingWidth: 55,
        title: Row(
          children: [
            _buildProfileImage(
                widget.profileImage, widget.isOnline, widget.signedIn),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.isOnline == "online" && widget.signedIn == 1
                        ? (Preferences.getPreferredLanguage() == "Magyar"
                            ? "Elérhető"
                            : "Online")
                        : (Preferences.getPreferredLanguage() == "Magyar"
                            ? "Utoljára elérhető: ${formatLastSeen(widget.lastSeen)}"
                            : "Last seen: ${formatLastSeen(widget.lastSeen)}"),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            _buildIcon(
              color: Colors.deepPurpleAccent,
              hunTooltip: "Információ a felhasználóról",
              engTooltip: "User Information",
              icon: Icons.info,
              onPressed: () {
                //TODO: felhasználó információi
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: BottomAppBar(
        color: Colors.black,
        height: 70,
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Row(
          children: [
            if (_isInputFocused)
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Vissza",
                engTooltip: "Back",
                icon: Icons.arrow_back,
                onPressed: () {
                  setState(() {
                    _isInputFocused = false;
                  });
                },
              )
            else ...[
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Fájl feltöltése",
                engTooltip: "File upload",
                icon: Icons.file_upload_outlined,
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    withData: true,
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: [
                      'pdf',
                      'doc',
                      'docx',
                      'xls',
                      'xlsx',
                      'ppt',
                      'pptx',
                      'zip',
                      'rar',
                      '7z',
                    ],
                  );

                  if (result != null) {
                    final oversizedFiles = result.files
                        .where((file) => file.size > 100 * 1024 * 1024)
                        .toList();
                    final validFiles = result.files
                        .where((file) => file.size <= 100 * 1024 * 1024)
                        .toList();

                    if (oversizedFiles.isNotEmpty) {
                      final names =
                          oversizedFiles.map((f) => f.name).join(', ');
                      ToastMessages.showToastMessages(
                        //TODO: megnézni hogy működik-e
                        Preferences.getPreferredLanguage() == "Magyar"
                            ? "A következő fájl(ok) túl nagy(ok): $names (max. 100 MB)"
                            : "The following file(s) are too large: $names (max. 100 MB)",
                        0.4,
                        Colors.redAccent,
                        Icons.error,
                        Colors.black,
                        const Duration(seconds: 2),
                        context,
                      );
                    }

                    setState(() {
                      _attachedFiles.addAll(validFiles);
                    });
                  }
                },
              ),
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Kamera",
                engTooltip: "Camera",
                icon: Icons.camera_enhance,
                onPressed: () {},
              ),
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Galéria",
                engTooltip: "Gallery",
                icon: Icons.photo_library_rounded,
                onPressed: () {},
              ),
            ],
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _inputFocusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: Preferences.getPreferredLanguage() == "Magyar"
                        ? "Kezdj el írni..."
                        : "Start writing...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            _buildIcon(
              //TODO: ikonok megírása, php-k
              color: Colors.deepPurpleAccent,
              hunTooltip: _shouldShowSendIcon ? "Üzenet küldése" : "Emoji gomb",
              engTooltip: _shouldShowSendIcon ? "Send message" : "Emoji button",
              icon: _shouldShowSendIcon
                  ? Icons.send_rounded
                  : Icons.thumb_up_rounded,

              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}

//TODO: Te:
//TODO: számláló ami a 5000 karaktert számolja, és ha elérjük akkor nem enged tovább gépelni

//MessageChatBubble osztály kezdete -----------------------------------------------------------------------
class MessageChatBubble extends StatefulWidget {
  const MessageChatBubble({
    super.key,
    required this.messageText,
    required this.isSender,
    required this.sentAt,
    this.profileImage,
    this.isRead = false,
    this.onTapScrollToBottom,
    this.isLastMessage = false,
  });

  final String messageText;
  final bool isSender;
  final String sentAt;
  final String? profileImage;
  final bool isRead;
  final VoidCallback? onTapScrollToBottom;
  final bool isLastMessage;

  @override
  State<MessageChatBubble> createState() => _MessageChatBubbleState();
}

class _MessageChatBubbleState extends State<MessageChatBubble> {
  bool _showDetails = false;

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
    });

    if (widget.onTapScrollToBottom != null && widget.isLastMessage) {
      widget.onTapScrollToBottom!();
    }
  }

  Widget _buildProfileImage(String? imageString) {
    if (imageString == null || imageString.isEmpty) {
      return const Icon(
        Icons.person,
        size: 36,
        color: Colors.white,
      );
    }

    if (imageString.startsWith("data:image/svg+xml;base64,")) {
      final svgBytes = base64Decode(imageString.split(",")[1]);
      return SvgPicture.memory(
        svgBytes,
        width: 36,
        height: 36,
        fit: BoxFit.fill,
      );
    } else if (imageString.startsWith("data:image/")) {
      final base64Data = base64Decode(imageString.split(",")[1]);
      return Image.memory(
        base64Data,
        width: 36,
        height: 36,
        fit: BoxFit.fill,
      );
    } else {
      return const Icon(
        Icons.person,
        size: 36,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDetails,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
        child: Row(
          mainAxisAlignment:
              widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: _showDetails
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.start,
          children: [
            if (!widget.isSender)
              ClipOval(child: _buildProfileImage(widget.profileImage)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: widget.isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.isSender
                        ? Colors.deepPurpleAccent
                        : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    widget.messageText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                if (_showDetails) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.sentAt,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                    ),
                  ),
                  if (widget.isSender)
                    Text(
                      widget.isRead
                          ? Preferences.getPreferredLanguage() == "Magyar"
                              ? "Látta"
                              : "Seen"
                          : Preferences.getPreferredLanguage() == "Magyar"
                              ? "Kézbesítve"
                              : "Delivered",
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: widget.isRead
                            ? Colors.greenAccent
                            : Colors.grey[500],
                      ),
                    ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//FileChatBubble osztály kezdete -----------------------------------------------------------------------
class FileChatBubble extends StatefulWidget {
  const FileChatBubble({
    super.key,
    required this.fileNames,
    required this.downloadUrls,
    required this.isSender,
    required this.sentAt,
    this.messageText,
    this.profileImage,
    this.isRead = false,
    this.onTapScrollToBottom,
    this.isLastMessage = false,
  });

  final List<String> fileNames;
  final List<String> downloadUrls;
  final String? messageText;
  final bool isSender;
  final String sentAt;
  final String? profileImage;
  final bool isRead;
  final VoidCallback? onTapScrollToBottom;
  final bool isLastMessage;

  @override
  State<FileChatBubble> createState() => _FileChatBubbleState();
}

class _FileChatBubbleState extends State<FileChatBubble> {
  bool _showDetails = false;

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
    });

    if (widget.onTapScrollToBottom != null && widget.isLastMessage) {
      widget.onTapScrollToBottom!();
    }
  }

  Future<void> _downloadFile(int index) async {
    try {
      final uri = Uri.tryParse(widget.downloadUrls[index]);
      if (uri == null || uri.toString().isEmpty) return;

      final response = await http.get(uri);
      if (response.statusCode != 200) return;

      final downloadsPath = "/storage/emulated/0/Download";
      final filePath = "$downloadsPath/${widget.fileNames[index]}";
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await NotificationService.showNotification(
        title: "✅ Letöltés kész",
        body: "${widget.fileNames[index]} elmentve ide:\n$filePath",
      );
    } catch (e) {
      await NotificationService.showNotification(
        title: "❌ Hiba",
        body: "Letöltési hiba: $e",
      );
    }
  }

  Widget _buildProfileImage(String? imageString) {
    if (imageString == null || imageString.isEmpty) {
      return const Icon(
        Icons.person,
        size: 36,
        color: Colors.white,
      );
    }
    if (imageString.startsWith("data:image/svg+xml;base64,")) {
      final svgBytes = base64Decode(imageString.split(",")[1]);
      return SvgPicture.memory(
        svgBytes,
        width: 36,
        height: 36,
        fit: BoxFit.fill,
      );
    } else if (imageString.startsWith("data:image/")) {
      final base64Data = base64Decode(imageString.split(",")[1]);
      return Image.memory(
        base64Data,
        width: 36,
        height: 36,
        fit: BoxFit.fill,
      );
    } else {
      return const Icon(
        Icons.person,
        size: 36,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDetails,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
        child: Row(
          mainAxisAlignment:
              widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: _showDetails
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.start,
          children: [
            if (!widget.isSender)
              ClipOval(child: _buildProfileImage(widget.profileImage)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: widget.isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.isSender
                        ? Colors.deepPurpleAccent
                        : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      if (widget.messageText != null &&
                          widget.messageText!.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            widget.messageText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ...List.generate(widget.fileNames.length, (index) {
                        return TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _downloadFile(index),
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: AutoSizeText(
                            maxLines: 2,
                            widget.fileNames[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                if (_showDetails) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.sentAt,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                    ),
                  ),
                  if (widget.isSender)
                    Text(
                      widget.isRead
                          ? Preferences.getPreferredLanguage() == "Magyar"
                              ? "Látta"
                              : "Seen"
                          : Preferences.getPreferredLanguage() == "Magyar"
                              ? "Kézbesítve"
                              : "Delivered",
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: widget.isRead
                            ? Colors.greenAccent
                            : Colors.grey[500],
                      ),
                    ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class FileChatBubble extends StatefulWidget { mentés
//   const FileChatBubble({
//     super.key,
//     required this.fileName,
//     required this.downloadUrl,
//     required this.isSender,
//     required this.sentAt,
//     this.messageText,
//     this.profileImage,
//     this.isRead = false,
//     this.onTapScrollToBottom,
//     this.isLastMessage = false,
//   });

//   final String fileName;
//   final String downloadUrl;
//   final String? messageText;
//   final bool isSender;
//   final String sentAt;
//   final String? profileImage;
//   final bool isRead;
//   final VoidCallback? onTapScrollToBottom;
//   final bool isLastMessage;

//   @override
//   State<FileChatBubble> createState() => _FileChatBubbleState();
// }

// class _FileChatBubbleState extends State<FileChatBubble> {
//   bool _showDetails = false;

//   void _toggleDetails() {
//     setState(() {
//       _showDetails = !_showDetails;
//     });

//     if (widget.onTapScrollToBottom != null && widget.isLastMessage) {
//       widget.onTapScrollToBottom!();
//     }
//   }

//   Widget _buildProfileImage(String? imageString) {
//     if (imageString == null || imageString.isEmpty) {
//       return const Icon(
//         Icons.person,
//         size: 36,
//         color: Colors.white,
//       );
//     }

//     if (imageString.startsWith("data:image/svg+xml;base64,")) {
//       final svgBytes = base64Decode(imageString.split(",")[1]);
//       return SvgPicture.memory(
//         svgBytes,
//         width: 36,
//         height: 36,
//         fit: BoxFit.fill,
//       );
//     } else if (imageString.startsWith("data:image/")) {
//       final base64Data = base64Decode(imageString.split(",")[1]);
//       return Image.memory(
//         base64Data,
//         width: 36,
//         height: 36,
//         fit: BoxFit.fill,
//       );
//     } else {
//       return const Icon(
//         Icons.person,
//         size: 36,
//         color: Colors.white,
//       );
//     }
//   }

//   Future<void> _downloadFile() async {
//     try {
//       final uri = Uri.tryParse(widget.downloadUrl);
//       log("uri link: ${uri.toString()}");
//       if (uri == null || uri.toString().isEmpty) {
//         await NotificationService.showNotification(
//           title: Preferences.getPreferredLanguage() == "Magyar"
//               ? "Letöltési hiba"
//               : "Download error",
//           body: Preferences.getPreferredLanguage() == "Magyar"
//               ? "A fájl nem található!"
//               : "File not found!",
//         );
//         return;
//       }

//       final response = await http.get(uri);
//       if (response.statusCode != 200) {
//         await NotificationService.showNotification(
//           title: Preferences.getPreferredLanguage() == "Magyar"
//               ? "Letöltési hiba"
//               : "Download error",
//           body: Preferences.getPreferredLanguage() == "Magyar"
//               ? "Nem sikerült letölteni a fájlt (Hiba kód: ${response.statusCode})!"
//               : "Failed to download the file (Error code: ${response.statusCode})!",
//         );
//         return;
//       }

//       final downloadsPath = "/storage/emulated/0/Download";
//       final filePath = "$downloadsPath/${widget.fileName}";
//       final file = File(filePath);
//       await file.writeAsBytes(response.bodyBytes);

//       await NotificationService.showNotification(
//         title: Preferences.getPreferredLanguage() == "Magyar"
//             ? "Letöltés sikeres"
//             : "Download successful",
//         body: Preferences.getPreferredLanguage() == "Magyar"
//             ? "${widget.fileName} elmentve ide:\n$filePath"
//             : "${widget.fileName} saved to:\n$filePath",
//       );
//     } catch (e) {
//       await NotificationService.showNotification(
//         title: Preferences.getPreferredLanguage() == "Magyar"
//             ? "Hiba történt"
//             : "Error occurred",
//         body: Preferences.getPreferredLanguage() == "Magyar"
//             ? "Nem sikerült letölteni: ${e.toString()}"
//             : "Failed to download: ${e.toString()}",
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _toggleDetails,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
//         child: Row(
//           mainAxisAlignment:
//               widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//           crossAxisAlignment: _showDetails
//               ? CrossAxisAlignment.start
//               : CrossAxisAlignment.start,
//           children: [
//             if (!widget.isSender)
//               ClipOval(child: _buildProfileImage(widget.profileImage)),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: widget.isSender
//                   ? CrossAxisAlignment.end
//                   : CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.5,
//                   ),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: widget.isSender
//                         ? Colors.deepPurpleAccent
//                         : Colors.blueAccent,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (widget.messageText != null &&
//                           widget.messageText!.trim().isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 5),
//                           child: Text(
//                             widget.messageText!,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ),
//                       TextButton.icon(
//                         style: TextButton.styleFrom(
//                           backgroundColor: Colors.grey[800],
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 5,
//                             horizontal: 5,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: () => _downloadFile(),
//                         icon: const Icon(
//                           Icons.download_rounded,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                         label: Text(
//                           widget.fileName,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (_showDetails) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     widget.sentAt,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontStyle: FontStyle.italic,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                   if (widget.isSender)
//                     Text(
//                       widget.isRead
//                           ? Preferences.getPreferredLanguage() == "Magyar"
//                               ? "Látta"
//                               : "Seen"
//                           : Preferences.getPreferredLanguage() == "Magyar"
//                               ? "Kézbesítve"
//                               : "Delivered",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontStyle: FontStyle.italic,
//                         color: widget.isRead
//                             ? Colors.greenAccent
//                             : Colors.grey[500],
//                       ),
//                     ),
//                 ]
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
