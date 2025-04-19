import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:typed_data';

class MessageChatBubble extends StatefulWidget {
  const MessageChatBubble({
    super.key,
    required this.messageText,
    required this.isSender,
    required this.sentAt,
    this.svgProfileBytes,
    this.cachedImage,
    this.isRead = false,
    this.onTapScrollToBottom,
    this.isLastMessage = false,
  });

  final String? messageText;
  final bool isSender;
  final String sentAt;
  final Uint8List? svgProfileBytes;
  final ImageProvider<Object>? cachedImage;
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
                    widget.messageText ?? "Hiba!",
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
