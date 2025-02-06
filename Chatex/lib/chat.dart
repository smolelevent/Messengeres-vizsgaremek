import 'package:flutter/material.dart';
import 'package:chatex/auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_fonts/google_fonts.dart';

class ChatUI extends StatelessWidget {
  const ChatUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().logOut(context: context);
      },
      child: const Text("Sign Out"),
    );
  }
}
