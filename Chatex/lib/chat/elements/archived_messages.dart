import 'package:flutter/material.dart';

class ArchivedMessages extends StatefulWidget {
  const ArchivedMessages({super.key});

  @override
  State<ArchivedMessages> createState() => _ArchivedMessagesState();
}

class _ArchivedMessagesState extends State<ArchivedMessages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        body: Text("archived messages"),
      ),
    );
  }
}
