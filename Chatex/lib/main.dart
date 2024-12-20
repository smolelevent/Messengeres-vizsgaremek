import 'package:flutter/material.dart';

import 'widgets/password_visibility.dart';

void main() {
  runApp(const MaterialApp(home: LoginUI()));
}

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  ButtonStyle forgotPasswordTextButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ));

  MenuStyle languageDropdownMenuStyle = const MenuStyle(
    backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
    elevation: WidgetStatePropertyAll<double>(5),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsets.only(bottom: 10),
    ),
  );

  ButtonStyle languageDropdownMenuEntryStyle = TextButton.styleFrom(
      foregroundColor: Colors.black,
      textStyle: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          const SizedBox(
            height: 60.0,
          ),
          DropdownMenu(
            menuStyle: languageDropdownMenuStyle,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            dropdownMenuEntries: [
              DropdownMenuEntry(
                style: languageDropdownMenuEntryStyle,
                value: "magyar",
                label: "Magyar",
              ),
              DropdownMenuEntry(
                style: languageDropdownMenuEntryStyle,
                value: "english",
                label: "English",
              )
            ],
          ),
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("assets/logo_titkos.png"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0),
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
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      elevation: 5,
                    ),
                    child: Text(
                      "Bejelentkezés",
                      style: TextStyle(
                        fontSize:
                            20 * MediaQuery.of(context).textScaler.scale(1.0),
                        height: 3.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextButton(
            onPressed: () {},
            style: forgotPasswordTextButtonStyle,
            child: const Text(
              "Elfelejtett jelszó",
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        bottom: 20.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: Text(
                          "Új fiók létrehozása",
                          style: TextStyle(
                            fontSize: 20 *
                                MediaQuery.of(context).textScaler.scale(1.0),
                            height: 3.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/logo_titkos.png"),
                    radius: 30,
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    text: "Chatex",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
