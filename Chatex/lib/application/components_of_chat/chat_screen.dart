import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chatex/application/components_of_chat/load_chats.dart';
import 'package:chatex/application/components_of_chat/components_of_chat_screen/message_chat_bubble.dart';
import 'package:chatex/application/components_of_chat/components_of_chat_screen/file_chat_bubble.dart';
import 'package:chatex/application/components_of_chat/components_of_chat_screen/image_chat_bubble.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

//A WEBSOCKET SZERVER-T INDÍTÁS ELŐTT FUTTATNI KELL A PHP-T: xampp_server\htdocs\ChatexProject\chatex_phps> php server_run.php

//ChatScreen OSZTÁLY ELEJE ------------------------------------------------------------------------
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

class _ChatScreenState extends State<ChatScreen> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isInputFocused = false;
  bool _showScrollToBottomButton = false;

  final List<PlatformFile> _attachedFiles = [];

  bool get _showSendIcon {
    return _messageController.text.trim().isNotEmpty ||
        _attachedFiles.isNotEmpty;
  }

  late String _currentStatus;
  late String _currentLastSeen;
  late int _currentSignedIn;

  late WebSocketChannel _channel;
  List<Map<String, dynamic>> _messages = <Map<String, dynamic>>[];
  Timer? _keepAliveTimer;

  static const int _maxMessageLength = 5000;

  ImageProvider? _cachedAppbarProfilePicture;
  Uint8List? _cachedAppbarSvgBytes;
  ImageProvider? _cachedMessageProfilePicture;
  Uint8List? _cachedMessageSvgBytes;

  final ImagePicker _imagePicker = ImagePicker();

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _loadMessages();
    _connectToWebSocket();
    _markMessagesAsRead();

    // AppBar profilkép //TODO: EGYSÉGESÍTENI
    if (widget.profileImage.startsWith("data:image/svg+xml;base64,")) {
      _cachedAppbarSvgBytes = base64Decode(widget.profileImage.split(",")[1]);
    } else if (widget.profileImage.startsWith("data:image/")) {
      final base64Data = base64Decode(widget.profileImage.split(",")[1]);
      _cachedAppbarProfilePicture = MemoryImage(base64Data);
    }

    // Üzenetbuborék profilkép
    if (widget.profileImage.startsWith("data:image/svg+xml;base64,")) {
      _cachedMessageSvgBytes = base64Decode(widget.profileImage.split(",")[1]);
    } else if (widget.profileImage.startsWith("data:image/")) {
      final base64Data = base64Decode(widget.profileImage.split(",")[1]);
      _cachedMessageProfilePicture = MemoryImage(base64Data);
    }

    _currentStatus = widget.isOnline;
    _currentLastSeen = widget.lastSeen;
    _currentSignedIn = widget.signedIn;

    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused =
            _inputFocusNode.hasFocus; //eltároljuk ha fókuszban van
      });
    });

    _messageController.addListener(() {
      setState(() {
        _isInputFocused = _messageController.text
            .trim()
            .isNotEmpty; //az input mező íráskor nagy legyen
      });
    });

    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      // Ha eltávolodott az üzenetek aljától egy bizonyos arányban akkor mutassuk a _scrollToBottomButton-t
      final distanceFromBottom = _scrollController.position.maxScrollExtent -
          _scrollController
              .offset; //a maximum scrollolható távolság (üzenetektől függ) - mennyire távolodtunk el az aljától

      const thresholdRatio =
          0.25; // alsó százaléktól eltávolodva jelenjen meg a gomb
      final shouldShow = distanceFromBottom >
          _scrollController.position.maxScrollExtent *
              thresholdRatio; //maximum * 25%

      if (_showScrollToBottomButton != shouldShow) {
        setState(() {
          _showScrollToBottomButton = shouldShow;
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

//ÜZENET KÜLDŐ/KEZELŐ METÓDUSOK ELEJE -------------------------------------------------------------

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(
          "ws://10.0.2.2:8080"), //csatlakozunk a websocket szerverhez hogy valós időben frissüljenek az adatok
    );

    //Auth típusú üzenet frissíti a is_online és a last_seen mezőt ezért az Appbar-ban lévő adatok frissülnek
    _channel.sink.add(jsonEncode({
      "message_type": "auth",
      "user_id": userId,
    }));

    log("A chat_screen.dart-ról sikeres volt a websocket csatlakozás!");

    _channel.stream.listen((message) {
      //figyelünk minden üzenetet (üzenet = bármilyen adat) ami a websocket szerverre érkezik
      final decoded = jsonDecode(message);
      final type = decoded['message_type'] ?? 'text';
      final data = decoded['data'] ?? decoded;

      if (data['chat_id'] != widget.chatId) return; //ha rossz a chat id alapján

      final messageId = data['message_id'];
      final index = _messages.indexWhere(
          (msg) => msg['message_id'] == messageId); //van e egyező üzenet id

      if (index != -1) return;

      final isForMe = data['receiver_id'] ==
          userId; //ha az üzenet a jelenlegi felhasználónak szól
      if (isForMe && ModalRoute.of(context)?.isCurrent == true) {
        //és a chat_screen.dart a jelenlegi képernyő
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            _channel.sink.add(jsonEncode({
              "message_type":
                  "read_status_update", //akkor olvasva legyenek az üzenetek
              "chat_id": widget.chatId,
              "user_id": userId,
            }));
          },
        );
      }

      switch (type) {
        //ha az ÉRKEZETT üzenet típusa a websocket szerverről
        case 'text':
          setState(() {
            _messages.add(data);
          });
          scrollToBottom();
          break;

        case 'file':
          final attachments = data['attachments'] ?? [];
          final fileNames = <String>[];
          final downloadUrls = <String>[];

          for (final att in attachments) {
            fileNames.add(att['file_name']);
            downloadUrls.add(att['download_url']);
          }

          setState(() {
            // // Ha van szöveg, előbb egy szöveges buborék jelenjen meg
            // if ((data['message_text'] ?? '').toString().trim().isNotEmpty) {
            //   _messages.add({
            //     ...data,
            //     'message_type': 'text',
            //   });
            // } mentés

            // Majd egy külön fájl buborék <- mentés
            _messages.add({
              ...data,
              'message_type': 'file',
              'fileNames': fileNames,
              'downloadUrls': downloadUrls,
              'message_text': data[
                  'message_text'], // ne jelenjen meg még egyszer ITT NULL VOLT MENTÉS
            });
          });

          scrollToBottom();
          break;

        case 'image':
          final attachments = data['attachments'] ?? [];

          if (attachments.isNotEmpty) {
            final imageUrls = attachments
                .map<String>((att) =>
                    att['download_url'].toString()) //TODO: dynamic típusú
                .toList();
            final fileNames = attachments
                .map<String>((att) => att['file_name'].toString())
                .toList();

            setState(() {
              _messages.add({
                ...data,
                'message_type': 'image',
                'downloadUrls': imageUrls,
                'fileNames': fileNames,
                'message_text': data['message_text'],
              });
            });
          }

          scrollToBottom();
          break;

        case 'message_read': //read-eli az üzeneteket amit látott a felhasználó
          if (index != -1) {
            setState(() {
              _messages[index] = data;
            });
          }
          break;

        case 'status_update': //beállítja az appbar-on lévő adatokat
          final int updatedUserId = data['user_id'];
          if (updatedUserId == widget.receiverId) {
            setState(() {
              _currentStatus = data['status'];
              _currentLastSeen = data['last_seen'];
              _currentSignedIn = data['signed_in'];
            });
          }
          break;

        default:
          log("Ismeretlen websocket típus: $type");
      }
    });

    _keepAliveTimer?.cancel(); // ha már 25s-es timer akkor töröljük
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      _channel.sink.add(jsonEncode({"message_type": "ping"}));
      log("Keep-alive ping elküldve!"); //azért szükséges hogy ne vesszen el a kapcsolat magától!
    });
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
        final attachments = message['attachments'] ?? [];

        final fileNames = <String>[];
        final downloadUrls = <String>[];

        for (final att in attachments) {
          fileNames.add(att['file_name']);
          downloadUrls.add(att['download_url']);
        }

        // final hasText =
        //     (message['message_text']?.toString().trim().isNotEmpty ?? false);

        // if ((messageType == 'file' || messageType == 'image') && hasText) {
        //   // 1️⃣ Először a szöveg buborék
        //   loadedMessages.add({
        //     ...message,
        //     'message_type': 'text',
        //     'attachments': [],
        //   });

        //   // 2️⃣ A fájl vagy kép külön
        //   loadedMessages.add({
        //     ...message,
        //     'message_type': messageType,
        //     'fileNames': fileNames,
        //     'downloadUrls': downloadUrls,
        //     'message_text': null, // ne ismételje meg a szöveget
        //   });
        // } mentés

        if (messageType == 'file' || messageType == 'image') {
          //ez else if volt
          loadedMessages.add({
            ...message,
            'message_type': messageType,
            'fileNames': fileNames,
            'downloadUrls': downloadUrls,
            'message_text':
                (message['message_text']?.toString().trim().isEmpty ?? true)
                    ? null
                    : message['message_text'],
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
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Kapcsolati hiba az üzenetek betöltésénél!"
            : "Connection error by getting messages!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Hiba történt az üzenetek lekérésekor: ${response.body}");
    }
  }

  // Future<void> _loadMessages() async { mentés
  //   final response = await http.post(
  //     Uri.parse(
  //         "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_messages.php"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"chat_id": widget.chatId}),
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     final List<Map<String, dynamic>> loadedMessages = [];

  //     for (final message in responseData['messages']) {
  //       final messageType = message['message_type'];

  //       if (messageType == 'file' || messageType == 'image') {
  //         final attachments = message['attachments'] ?? [];

  //         final fileNames = <String>[];
  //         final downloadUrls = <String>[];

  //         for (final att in attachments) {
  //           fileNames.add(att['file_name']);
  //           downloadUrls.add(att['download_url']);
  //         }

  //         loadedMessages.add({
  //           ...message,
  //           'fileNames': fileNames,
  //           'downloadUrls': downloadUrls,
  //           'message_text':
  //               (message['message_text']?.toString().trim().isEmpty ?? true)
  //                   ? null
  //                   : message['message_text'],
  //         });
  //       } else {
  //         loadedMessages.add(message);
  //       }
  //     }

  //     //elrendezzük az üzenetek adatait és megjelenítjük őket
  //     setState(() {
  //       _messages = loadedMessages;
  //     });

  //     scrollToBottom();
  //   } else {
  //     ToastMessages.showToastMessages(
  //       Preferences.getPreferredLanguage() == "Magyar"
  //           ? "Kapcsolati hiba az üzenetek betöltésénél!"
  //           : "Connection error by getting messages!",
  //       0.2,
  //       Colors.redAccent,
  //       Icons.error,
  //       Colors.black,
  //       const Duration(seconds: 2),
  //       context,
  //     );
  //     log("Hiba történt az üzenetek lekérésekor: ${response.body}");
  //   }
  // }

  void _sendMessage() {
    final message = {
      "message_type": "text",
      "chat_id": widget.chatId,
      "sender_id": userId,
      "receiver_id": widget.receiverId,
      "message_text": _messageController.text.trim(),
    };

    //üzenet küldés a websocket szerveren keresztűl megy az adatbázisba,
    //illetve töröljük a tartalmát és a focust a textmezőről, és letekerünk a chat aljára
    _channel.sink.add(jsonEncode(message));
    // _messageController.clear();
    // FocusScope.of(context).unfocus();
    // scrollToBottom();
  }

  Future<void> _sendFiles() async {
    final picked = await FilePicker.platform.pickFiles(
      dialogTitle:
          lang == "Magyar" ? "Fájl(ok) kiválasztása" : "Select file(s)",
      withData: true,
      compressionQuality: 75,
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
    if (picked == null || picked.files.isEmpty) return;

    final oversizedFiles = <PlatformFile>[];
    final validFiles = <PlatformFile>[];

    for (final file in picked.files) {
      if (file.size > 100 * 1024 * 1024) {
        oversizedFiles.add(file);
      } else {
        validFiles.add(file);
      }
    }

    if (oversizedFiles.isNotEmpty) {
      _showContentTooLargeDialog(
        "A fájlok mérete túl nagy!",
        "The files are too large!",
        "Csak 100 MB vagy alatti fájlokat lehet küldeni!",
        "You can only send files up to 100 MB!",
      );
      return;
    }

    log("validFiles: ${validFiles.toString()}");
    setState(() {
      _attachedFiles.addAll(validFiles);
    });
  }

  void _sendFilesFromPreviewBar(String? messageText) {
    final files = _attachedFiles
        .where((f) => !_isImageExtension(_getExtension(f))) // csak nem-kép
        .map((file) => {
              "file_name": file.name,
              "file_bytes": base64Encode(file.bytes!),
            }) //megnézni hogy passzol
        .toList();

    if (files.isEmpty) return;

    log("files: ${files.toString()}");
    final message = {
      "message_type": "file",
      "chat_id": widget.chatId,
      "sender_id": userId,
      "receiver_id": widget.receiverId,
      "message_text": messageText,
      // _messageController.text.trim().isEmpty
      //     ? null
      //     : _messageController.text.trim(),
      "files": files,
    };

//"message_text": _messageController.text.trim(), régibe ez volt
    log("📤 Küldés fájlokkal: ${jsonEncode(message)}");
    _channel.sink.add(jsonEncode(message));
    // _messageController.clear();
    // _attachedFiles.clear();
    // FocusScope.of(context).unfocus();
    // scrollToBottom();
  }

  Future<void> _sendImageFromCamera() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    if (bytes.length > 50 * 1024 * 1024) {
      //maximum 50MB a kép küldés limitje
      _showContentTooLargeDialog(
          "A képek mérete túl nagy!",
          "The images are too large!",
          "Csak 50 MB vagy alatti képeket lehet küldeni!",
          "You can only send files up to 50 MB!");
      return;
    }

    final base64Image = base64Encode(bytes);

    final message = {
      "message_type": "image",
      "chat_id": widget.chatId,
      "sender_id": userId,
      "receiver_id": widget.receiverId,
      "message_text": null,
      "images": [
        {
          "file_name": picked.name,
          "image_data": base64Image,
        }
      ],
    };

    //egyből elküldjük a képet
    _channel.sink.add(jsonEncode(message));
    //scrollToBottom();
  }

  Future<void> _sendImageFromGallery() async {
    final picked = await _imagePicker.pickMultiImage();
    if (picked.isEmpty) return;

    final oversized = <XFile>[];
    final List<PlatformFile> validImageFiles = [];

    for (final img in picked) {
      final length = await img.length();
      if (length > 50 * 1024 * 1024) {
        //maximum 50MB a képek együttes mérete
        oversized.add(img);
      } else {
        final bytes = await img.readAsBytes();
        validImageFiles.add(
          PlatformFile(
            name: img.name,
            size: length,
            bytes: bytes,
            path: img.path,
          ),
        );
      }
    }

    if (oversized.isNotEmpty) {
      _showContentTooLargeDialog(
          "A képek mérete túl nagy!",
          "The images are too large!",
          "Csak 50 MB vagy alatti képeket lehet küldeni!",
          "You can only send files up to 50 MB!");
      return;
    }

    //felvesszük a képeket a PreviewBar-ra amihez küldés előtt szöveget és fileokat lehet hozzáadni
    setState(() {
      _attachedFiles.addAll(validImageFiles);
    });
  }

  void _sendImagesFromPreviewBar(String? messageText) {
    final images = _attachedFiles
        .where((f) => _isImageExtension(_getExtension(
            f))) //csak olyan fileokat engedünk amik a megfelelő kiterjesztéssel rendelkeznek
        .map((file) => {
              "file_name": file.name,
              "image_data": base64Encode(file.bytes!),
            })
        .toList();

    if (images.isEmpty) return;

    final message = {
      "message_type": "image",
      "chat_id": widget.chatId,
      "sender_id": userId,
      "receiver_id": widget.receiverId,
      "message_text": messageText,
      // _messageController.text.trim().isEmpty
      //     ? null
      //     : _messageController.text.trim(),
      "images": images,
    };

    _channel.sink.add(jsonEncode(message));
  }

  void _handleSend() {
    _checkMessageLength();

    final hasText = _messageController.text.trim().isNotEmpty;
    final hasFiles = _attachedFiles.isNotEmpty;

    final hasImages =
        _attachedFiles.any((f) => _isImageExtension(_getExtension(f)));
    final hasOtherFiles =
        _attachedFiles.any((f) => !_isImageExtension(_getExtension(f)));

    String? currentText = _messageController.text.trim().isNotEmpty
        ? _messageController.text.trim()
        : null;

    if (hasImages) {
      _sendImagesFromPreviewBar(currentText);
      // küldés után null értéket adunk, hogy a következő típusnál már ne adja hozzá ugyanazt az üzenetet! (pl.: ha 5000 karakteres szövegről van szó)
      currentText = null;
    }

    if (hasOtherFiles) {
      _sendFilesFromPreviewBar(currentText);
    }

    if (hasText && !hasFiles) {
      _sendMessage();
    }

    //Törlés csak itt, ha esetleg több típust küld egyszerre a felhasználó!
    _messageController.clear();
    _attachedFiles.clear();
    FocusScope.of(context).unfocus();
    scrollToBottom();
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/chat/set/mark_as_read.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "chat_id": widget.chatId,
          "user_id":
              userId, //az a receiver_id aki megkapja tehát az user_id-t kell megadnunk
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log("Messages marked as read successfully: ${responseData.toString()}");
        //elküldjük a websocket szervernek is mert chat közben is változhat nem csak betöltéskor
        _channel.sink.add(jsonEncode({
          "message_type": "read_status_update",
          "chat_id": widget.chatId,
          "user_id": userId,
        }));
      } else {
        log("Hiba az üzenet olvasottsága frissítése közben: ${responseData.toString()}");
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Kapcsolati hiba\naz olvasottság átállításánál!"
            : "Connection error by\nmarking the message as read!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba\naz olvasottság átállításánál: $e");
    }
  }

//ÜZENET KÜLDŐ/KEZELŐ METÓDUSOK VÉGE --------------------------------------------------------------

//EGYÉB KIEGÉSZÍTŐ METÓDUSOK ELEJE ----------------------------------------------------------------

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController
                  .position.maxScrollExtent, //a képernyő aljára ugrik
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        },
      );
    });
  }

  String formatLastSeen(String lastSeenString) {
    //TODO: EGYSÉGESÍTENI
    try {
      final lastSeen = DateTime.parse(lastSeenString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(lastSeen);

      if (difference.inMinutes < 1) {
        return lang == "Magyar" ? "Épp most" : "Just now";
      } else if (difference.inMinutes < 60) {
        return lang == "Magyar"
            ? "${difference.inMinutes} perce"
            : "${difference.inMinutes} minute(s) ago";
      } else if (difference.inHours < 24) {
        return lang == "Magyar"
            ? "${difference.inHours} órája"
            : "${difference.inHours} hour(s) ago";
      } else if (difference.inDays == 1) {
        return lang == "Magyar" ? "Tegnap" : "Yesterday";
      } else if (difference.inDays == 2) {
        return lang == "Magyar" ? "Tegnap előtt" : "The day before yesterday";
      } else {
        final formattedDate =
            "${lastSeen.year}.${lastSeen.month.toString().padLeft(2, '0')}.${lastSeen.day.toString().padLeft(2, '0')} "
            "${lastSeen.hour.toString().padLeft(2, '0')}:${lastSeen.minute.toString().padLeft(2, '0')}:${lastSeen.second.toString().padLeft(2, '0')}";
        return formattedDate;
      }
    } catch (e) {
      return Preferences.getPreferredLanguage() == "Magyar"
          ? "Hiba!"
          : "Error!";
    }
  }

  void _showContentTooLargeDialog(String hunTitleString, String engTitleString,
      String hunContentString, String engContentString) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: AutoSizeText(
            lang == "Magyar" ? hunTitleString : engTitleString,
          ),
          content: AutoSizeText(
            lang == "Magyar" ? hunContentString : engContentString,
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
  }

  bool _isImageExtension(String? ext) {
    return ['jpg', 'jpeg', 'png', 'svg'].contains(ext?.toLowerCase());
  }

  String? _getExtension(PlatformFile file) {
    final name = file.name;
    if (!name.contains('.')) return null;
    return name.split('.').last.toLowerCase();
  }

  void _checkMessageLength() {
    //TODO: EGYSÉGESÍTENI
    if (_messageController.text.length > _maxMessageLength) {
      //jelenleg 5000-re van rakva mind itt Dart-on és mind az adatbázisba!
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: AutoSizeText(
            lang == "Magyar" ? "Túl hosszú üzenet!" : "Message too long!",
          ),
          content: AutoSizeText(
            lang == "Magyar"
                ? "Legfeljebb $_maxMessageLength karakter hosszú üzenetet lehet küldeni!"
                : "You can send a message up to $_maxMessageLength characters!",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
  }

//EGYÉB KIEGÉSZÍTŐ METÓDUSOK VÉGE -----------------------------------------------------------------

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

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
        body: _buildBody(),
        bottomSheet: _buildBottomBar(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildBody() {
    return MediaQuery.removeViewInsets(
      removeBottom: true,
      context: context,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(child: (_buildMessageList())),
              if (_attachedFiles.isNotEmpty) _buildAttachmentPreviewBar(),
            ],
          ),
        ],
      ),
    );
  }

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
            _buildProfileImage(_currentStatus, _currentSignedIn),
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
                  AutoSizeText(
                    maxLines: 1,
                    _currentStatus == "online" && _currentSignedIn == 1
                        ? (lang == "Magyar" ? "Elérhető" : "Online")
                        : (lang == "Magyar"
                            ? "Utoljára elérhető: ${formatLastSeen(_currentLastSeen)}"
                            : "Last seen: ${formatLastSeen(_currentLastSeen)}"),
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
                //TODO: felhasználó információi CHAT TÖLÉST ÉS JÓL VAN AZ ÚGY
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String isOnline, int signedIn) {
    Widget imageWidget; //TODO: EGYSÉGESÍTENI

    if (_cachedAppbarSvgBytes != null) {
      imageWidget = SvgPicture.memory(
        _cachedAppbarSvgBytes!,
        width: 48,
        height: 48,
        fit: BoxFit.fill,
      );
    } else if (_cachedAppbarProfilePicture != null) {
      imageWidget = Image(
        image: _cachedAppbarProfilePicture!,
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
      tooltip: lang == "Magyar" ? hunTooltip : engTooltip,
      icon: Icon(
        icon,
        size: 26,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildEmptyChat() {
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
    if (_messages.isEmpty) return _buildEmptyChat();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isSender = message['sender_id'] == userId;
        final isLast = index == _messages.length - 1;
        final messageType = message['message_type'];

        switch (messageType) {
          case 'file': //itt is egy case alapján jelenítjük meg az üzeneteket
            final fileNames = List<String>.from(message['fileNames'] ?? []);
            final downloadUrls =
                List<String>.from(message['downloadUrls'] ?? []);

            return FileChatBubble(
              fileNames: fileNames,
              downloadUrls: downloadUrls,
              messageText: message['message_text'],
              sentAt: formatLastSeen(message['sent_at'] ?? ""),
              isSender: isSender,
              isRead: message['is_read'] == 1,
              svgProfileBytes: isSender ? null : _cachedMessageSvgBytes,
              cachedImage: isSender ? null : _cachedMessageProfilePicture,
              onTapScrollToBottom: scrollToBottom,
              isLastMessage: isLast,
            );

          case 'image':
            final imageUrls = List<String>.from(message['downloadUrls'] ?? []);
            return ImageChatBubble(
              imageUrls: imageUrls,
              messageText: message['message_text'],
              sentAt: formatLastSeen(message['sent_at'] ?? ""),
              isSender: isSender,
              isRead: message['is_read'] == 1,
              svgProfileBytes: isSender ? null : _cachedMessageSvgBytes,
              cachedImage: isSender ? null : _cachedMessageProfilePicture,
              onTapScrollToBottom: scrollToBottom,
              isLastMessage: isLast,
            );

          case 'text':
          default:
            return MessageChatBubble(
              messageText: message['message_text'] ?? "",
              sentAt: formatLastSeen(message['sent_at'] ?? ""),
              isSender: isSender,
              isRead: message['is_read'] == 1,
              svgProfileBytes: isSender ? null : _cachedMessageSvgBytes,
              cachedImage: isSender ? null : _cachedMessageProfilePicture,
              onTapScrollToBottom: scrollToBottom,
              isLastMessage: isLast,
            );
        }
      },
    );
  }

  Widget _buildScrollToBottomButton() {
    return _showScrollToBottomButton
        ? Padding(
            //TODO: azt is megnézni hogy a file preview list nyítva van e mert ha nem akkor más viewInsets.bottom
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

  Widget _buildAttachmentPreviewBar() {
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
          final isImage = _isImageExtension(_getExtension(file));

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
                          ? Image.memory(
                              file.bytes!,
                              width: 30,
                              height: 30,
                            )
                          : const Icon(
                              Icons.insert_drive_file,
                              color: Colors.white,
                              size: 30,
                            ),
                      const SizedBox(height: 4),
                      Text(
                        file.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                        ),
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
                      child: Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
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
                onPressed: _sendFiles,
              ),
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Kamera",
                engTooltip: "Camera",
                icon: Icons.camera_enhance,
                onPressed: _sendImageFromCamera,
              ),
              _buildIcon(
                color: Colors.white,
                hunTooltip: "Galéria",
                engTooltip: "Gallery",
                icon: Icons.photo_library_rounded,
                onPressed: _sendImageFromGallery,
              ),
            ],
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _inputFocusNode,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        maxLines:
                            null, //annyi sorba írhat ahányat akar max 5000 karakterig
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: lang == "Magyar"
                              ? "Kezdj el írni..."
                              : "Start writing...",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_messageController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "${_messageController.text.length}/$_maxMessageLength", //számláló
                          style: TextStyle(
                            fontSize: 12,
                            color: _messageController.text.length >
                                    _maxMessageLength
                                ? Colors.redAccent
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            _buildIcon(
              color: Colors.deepPurpleAccent,
              hunTooltip: _showSendIcon ? "Üzenet küldése" : "Emoji gomb",
              engTooltip: _showSendIcon ? "Send message" : "Emoji button",
              icon: _showSendIcon ? Icons.send_rounded : Icons.thumb_up_rounded,
              onPressed: _handleSend, //TODO: emoji nem csinál semmit!
            ),
          ],
        ),
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}
//ChatScreen OSZTÁLY VÉGE -------------------------------------------------------------------------
