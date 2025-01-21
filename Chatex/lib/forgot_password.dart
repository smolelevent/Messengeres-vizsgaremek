import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  



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
  ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
  
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
final TextEditingController _emailController = TextEditingController();
@override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          elevation: 0,
          toolbarHeight: 20,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Enter your email to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: 'Email',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            MaterialButton(onPressed: passwordReset,
            color: Colors.deepPurple[200],
            child: Text("Reset Password"),
            )
          ],
        ));
  }

Future passwordReset() async {
try {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text("Success"),
      content: Text("Password reset email sent"),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text("OK"))
      ],
    );
  });
} on FirebaseAuthException catch (e) {
  print(e);
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text("Error"),
      content: Text(e.message.toString()),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text("OK"))
      ],
    );
  });
}
}
}