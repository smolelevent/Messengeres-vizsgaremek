import 'package:chatex/Auth.dart';
import 'package:chatex/forgot_password.dart';
import 'package:chatex/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'firebase_options.dart';
import 'widgets/password_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(MaterialApp(home: LoginUI()));
}

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  //változók
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  InputDecorationTheme languageMenuStyle = InputDecorationTheme(
    labelStyle: TextStyle(
      color: Colors.grey[600],
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
    ),
  );

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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // íráskor nem jön fel az expanded widget
        backgroundColor: Colors.grey[850],
        body: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: DropdownMenu(
                requestFocusOnTap: false,
                label: const Text("Nyelvek"),
                initialSelection: "magyar",
                trailingIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                selectedTrailingIcon: const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.deepPurpleAccent,
                ),
                inputDecorationTheme: languageMenuStyle,
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
                controller: _emailController,
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
            const PasswordWidget(), //password_visibility.dart
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Email and password cannot be empty",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                          return;
                        }
                        await AuthService().signin(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context,
                        );
                      },
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
              height: 5.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()));
              },
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
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
                              //minden eszközön elvileg ugyanakkora lesz (px helyett dp)
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
      ),
    );
  }
}
