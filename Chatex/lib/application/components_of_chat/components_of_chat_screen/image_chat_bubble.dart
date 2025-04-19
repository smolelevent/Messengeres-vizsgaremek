import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:chatex/logic/notifications.dart';

class ImageChatBubble extends StatefulWidget {
  const ImageChatBubble({
    super.key,
    required this.imageUrls,
    required this.sentAt,
    required this.isSender,
    this.messageText,
    this.svgProfileBytes,
    this.cachedImage,
    this.isRead = false,
    this.onTapScrollToBottom,
    this.isLastMessage = false,
  });

  final List<String> imageUrls;
  final String sentAt;
  final bool isSender;
  final String? messageText;
  final Uint8List? svgProfileBytes;
  final ImageProvider<Object>? cachedImage;
  final bool isRead;
  final VoidCallback? onTapScrollToBottom;
  final bool isLastMessage;

  @override
  State<ImageChatBubble> createState() => _ImageChatBubbleState();
}

class _ImageChatBubbleState extends State<ImageChatBubble> {
  bool _showDetails = false;

  void _toggleDetails() {
    setState(() => _showDetails = !_showDetails);
    if (widget.onTapScrollToBottom != null && widget.isLastMessage) {
      widget.onTapScrollToBottom!();
    }
  }

  Future<void> _downloadImage(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return;

      final directory = await getDownloadsDirectory();
      final path = "${directory!.path}/$fileName";
      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);

      await NotificationService.showNotification(
        title: "✅ Kép elmentve",
        body: "$fileName elmentve ide:\n$path",
      );
    } catch (e) {
      await NotificationService.showNotification(
        title: "❌ Hiba",
        body: "Nem sikerült letölteni a képet!",
      );
    }
  }

  Widget _buildProfileImage() {
    if (widget.svgProfileBytes != null) {
      return SvgPicture.memory(
        widget.svgProfileBytes!,
        width: 36,
        height: 36,
        fit: BoxFit.fill,
      );
    } else if (widget.cachedImage != null) {
      return Image(
        image: widget.cachedImage!,
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
            if (!widget.isSender) ClipOval(child: _buildProfileImage()),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: widget.isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.isSender
                        ? Colors.deepPurpleAccent
                        : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.messageText != null &&
                          widget.messageText!.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            widget.messageText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 5, //képek közötti távolság
                        ),
                        itemCount: widget.imageUrls.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                              onTap: () async {
                                final url = widget.imageUrls[index];
                                final fileName =
                                    widget.imageUrls[index].split("/").last;
                                await _downloadImage(url, fileName);
                              },
                              child: Image.network(
                                widget.imageUrls[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      ),
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
                      widget.isRead ? "Látta" : "Kézbesítve",
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
