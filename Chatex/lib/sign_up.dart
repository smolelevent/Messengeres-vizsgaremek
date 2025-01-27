import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool passwordVisibile = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        elevation: 5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            'Regisztráció',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 35,
            ),
          ),
          AutoSizeText(
            textAlign: TextAlign.center,
            "info a regisztrációhoz (lorem)",
            //TODO: lehetne itt checkboxok amik pl: az emailt és a jelszó feltételeit ellenőrzik és folyamatosan csinálják azt
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 85,
          ),
          _emailAddressWidget(),
          const SizedBox(
            height: 10,
          ),
          _passwordWidget(),
          const SizedBox(
            height: 10,
          ),
          _passwordConfirmWidget(),
          const SizedBox(
            height: 25,
          ),
          _signUpWidget(context),
        ],
      ),
    );
  }

  Widget _emailAddressWidget() {
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

  Widget _passwordWidget() {
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

  Widget _passwordConfirmWidget() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _passwordConfirmController,
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

  Widget _signUpWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                elevation: 5,
              ),
              onPressed: () async {
                //TODO: lehetne az hogy állandóan nézi (vagy amikor elkezdenek írni a jelszó mezőbe hogy) hogy megegyeznek e, ha pedig nem akkor letiltja a gombot, és addig nem lehet tovább menni VAGY csak az hogy szól pl: pirossal hogy nem egyeznek meg...
                if (_passwordController.text ==
                    _passwordConfirmController.text) {
                  print("a jelszavak megegyeznek");
                } else {
                  print("a jelszavak nem egyeznek meg");
                }

                await AuthService().register(
                    email: _emailController,
                    password: _passwordController,
                    context: context);
              },
              child: Text(
                "Regisztrálás",
                style: TextStyle(
                  fontSize: 20 * MediaQuery.of(context).textScaler.scale(1.0),
                  height: 3.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
//TODO: szerintem ameddig el nem ér a felhasználó a homescreenig addig mindenhova tegyünk "Chatex" jelzést
}
