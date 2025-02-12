import 'package:chatex/main.dart';
import 'package:flutter/material.dart';
import 'package:chatex/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
//import 'package:google_fonts/google_fonts.dart';

final _formKey = GlobalKey<FormBuilderState>();

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          elevation: 5,
        ),
        body: FormBuilder(
          key: _formKey,
          onChanged: () {
            // _validateActiveField();
            // _checkRegistrationFieldsValidation();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                'Chat',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 35,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //nincs logika
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginUI(),
                    ),
                  );
                },
                child: Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  // Widget _logout(BuildContext context) {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: const Color(0xff0D6EFD),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(14),
  //       ),
  //       minimumSize: const Size(double.infinity, 60),
  //       elevation: 0,
  //     ),
  //     onPressed: () async {
  //       await AuthService().logOut(context: context);
  //     },
  //     child: const Text("Sign Out"),
  //   );
  // }
