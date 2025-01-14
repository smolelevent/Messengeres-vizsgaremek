import 'package:chatex/main.dart';
import 'widgets/password_visibility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatex/Auth.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final InputDecorationTheme languageMenuStyle = InputDecorationTheme(
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

  final MenuStyle languageMenuOptionsStyle = const MenuStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.deepPurpleAccent),
    elevation: WidgetStatePropertyAll(5),
  );

  final ButtonStyle languageMenuEntryStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ));



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: _signin(context),
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          elevation: 0,
          toolbarHeight: 20,
        ),
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
            
            Column(
              children: [
                Center(
                  child: Text(
                    'Regisztráció',
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 80,),
                _emailAddress(),
                const SizedBox(height: 20,),
                _password(),
                const SizedBox(height: 50,),
                _signup(context),
              ],
            ),

          ],
        )
    
    );
  }

  Widget _emailAddress() {
   return Container(
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
            );
  }

  Widget _password() {
    return PasswordVisibility();
  }

  Widget _signup(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().signup(
            email: _emailController.text,
            password: _passwordController.text,
            context: context
        );
      },
      child: Text("Regisztrálás",
      style: TextStyle(
            fontSize: 20 * MediaQuery.of(context).textScaler.scale(1.0),
            height: 3.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
      ),
    ));
  }

  Widget _signin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              children: [
                const TextSpan(
                  text: "Already Have Account? ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16
                  ),
                ),
                TextSpan(
                    text: "Log In",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 16
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginUI()
                        ),
                      );
                    }
                ),
              ]
          )
      ),
    );
  }
}
