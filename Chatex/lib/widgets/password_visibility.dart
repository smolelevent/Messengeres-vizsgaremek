import 'package:flutter/material.dart';

class PasswordVisibility extends StatefulWidget {
  const PasswordVisibility({super.key});

  @override
  State<PasswordVisibility> createState() => _PasswordVisibilityState();
}

class _PasswordVisibilityState extends State<PasswordVisibility> {
  @override
  Widget build(BuildContext context) {
    bool jelszoLathato = true;
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: TextField(
        obscureText: jelszoLathato,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                jelszoLathato = !jelszoLathato;
              });
            },
            icon: Icon(
              jelszoLathato ? Icons.visibility : Icons.visibility_off,
            ),
          ),

          contentPadding: const EdgeInsets.only(left: 10.0, bottom: 0),
          hintText: "Jelszó",
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
