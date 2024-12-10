import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: LandingPage()
  ));
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
            "Chatex",
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("assets/logo_titkos.png"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "e-mail cím",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }
}


