import 'package:flutter/material.dart';

class PasswordConfirmWidget extends StatefulWidget {
  const PasswordConfirmWidget({super.key});

  @override
  State<PasswordConfirmWidget> createState() => _PasswordConfirmWidgetState();
}

class _PasswordConfirmWidgetState extends State<PasswordConfirmWidget> {
  bool passwordVisibile = true;
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _passwordController,
        obscureText: passwordVisibile,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisibile ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                passwordVisibile = !passwordVisibile;
              });
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: "Jelszó újra",
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
}
