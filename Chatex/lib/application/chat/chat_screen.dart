import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.black,
            //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.file_upload, color: Colors.white),
                  onPressed: () {
                    // TODO: fájl feltöltés
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () {
                    // TODO: kamera megnyitása
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.photo, color: Colors.white),
                  onPressed: () {
                    // TODO: galéria megnyitása
                  },
                ),

                // 💬 Üzenet írása
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Írj üzenetet...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 👍 Like ikon (később testreszabható)
                IconButton(
                  icon: const Icon(Icons.thumb_up, color: Colors.blueAccent),
                  onPressed: () {
                    // TODO: like küldés logika
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
