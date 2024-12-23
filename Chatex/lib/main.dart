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
  bool dropdownMenuArrowClicked = false;

  // InputDecorationTheme languageMenuStyle = InputDecorationTheme(
  //   labelStyle: TextStyle(
  //     color: Colors.grey[600],
  //     fontStyle: FontStyle.italic,
  //     fontWeight: FontWeight.bold,
  //     fontSize: 20.0,
  //   ),
  //   enabledBorder: dropdownMenuArrowClicked
  //       ? const OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
  //         )
  //       : const OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.white, width: 2.5)),
  //   // focusedBorder: const OutlineInputBorder(
  //   //   borderSide: BorderSide(
  //   //     color: Colors.deepPurpleAccent,
  //   //     width: 2.5,
  //   //   ),
  //   // ),
  // );

  MenuStyle languageMenuOptionsStyle = const MenuStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.deepPurpleAccent),
    elevation: WidgetStatePropertyAll(5),
  );

  ButtonStyle languageMenuEntryStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ));

  ButtonStyle forgotPasswordStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // íráskor nem jön fel az expanded widget
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          const SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: DropdownMenu(
              //TODO hogy tudom a keresést kikapcsolni (nem szükséges mert 2 nyelv lesz a vizsgáig, a nyíl és a keret egyszerre váltson, nyíl nyitáskor működjön)
              requestFocusOnTap: true,
              trailingIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    dropdownMenuArrowClicked = !dropdownMenuArrowClicked;
                  });
                },
                child: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
              selectedTrailingIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    dropdownMenuArrowClicked = !dropdownMenuArrowClicked;
                  });
                },
                child: const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              label: const Text("Nyelvek"),
              initialSelection: "magyar",
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
                enabledBorder: dropdownMenuArrowClicked
                    ? const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, width: 2.5),
                      )
                    : const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.5)),
                focusedBorder: dropdownMenuArrowClicked
                    ? const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, width: 2.5),
                      )
                    : const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.5)),
              ),
              menuStyle: languageMenuOptionsStyle,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  style: languageMenuEntryStyle,
                  value: "magyar",
                  label: "Magyar",
                ),
                DropdownMenuEntry(
                  style: languageMenuEntryStyle,
                  value: "english",
                  label: "English",
                ),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("assets/logo_titkos.png"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
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
            style: forgotPasswordStyle,
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
                RichText(
                  text: const TextSpan(
                    text: "Chatex",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
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
