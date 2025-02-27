import 'package:flutter/material.dart';

class MessageRequests extends StatefulWidget {
  const MessageRequests({super.key});

  @override
  State<MessageRequests> createState() => _MessageRequestsState();
}

class _MessageRequestsState extends State<MessageRequests> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text("message requests"),
        backgroundColor: Colors.grey[850],
      ),
    );
  }
}
