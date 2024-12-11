import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(const MaterialApp(
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
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ClipRRect(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("assets/logo_titkos.png"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        // minimumSize: const Size(20, 20),
                        // maximumSize: const Size(100, 100),
                        elevation: 5,
                      ),
                    child: const AutoSizeText(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaler
                      ),
                      "login"
                      ),
                    ),
              ],
            ),
          ],
        ),
      );
  }
}