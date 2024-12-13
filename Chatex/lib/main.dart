import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'widgets/password_visibility.dart';

void main() {
  runApp(const MaterialApp(home: LandingPage()));
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
      fontSize: 20 * MediaQuery.of(context).textScaler.scale(1.0),
      height: 3.0,
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
            letterSpacing: 5.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50.0,
          ),
          const ClipRRect(
            child: CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage("assets/logo_titkos.png"),
            ),
          ),
          //TODO: mögötte lévő kód megírása, label használata, validálni hogy megfelelő szintaxisu bevitel
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 10.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: "E-mail cím",
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 2.5,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.5,
                  ),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          const PasswordVisibility(),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    //TODO: gomb mögötti kód megírása,
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      elevation: 5,
                    ),
                    child: AutoSizeText(
                      "Bejelentkezés",
                      style: buttonsTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
