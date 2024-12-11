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
    TextStyle buttonsTextStyle = TextStyle(
      fontSize: 18 * MediaQuery.of(context).textScaler.scale(1.0),
    );

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
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "E-mail cím"
              ),
            ),
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
                        elevation: 5,
                      ),
                    child: AutoSizeText(
                      "Bejelentkezés",
                      style: buttonsTextStyle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
  }
}