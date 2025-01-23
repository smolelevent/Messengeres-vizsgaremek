import 'package:chatex/Auth.dart';
import 'package:chatex/main.dart';
import 'package:chatex/widgets/password_confirm_widget.dart';
import 'package:chatex/widgets/password_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordWidgetController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[850],
      //bottomNavigationBar: _signInWidget(context),
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
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
          Text(
            "info a regisztrációhoz",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          emailAddressWidget(),
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
          const SizedBox(
            height: 85,
          ),
          _signInWidget(context),
        ],
      ),
    );
  }

  Widget emailAddressWidget() {
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
    return PasswordWidget();
  }

  Widget _passwordConfirmWidget() {
    return PasswordConfirmWidget();
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
                await AuthService().signup(
                    email: _emailController.text,
                    password: _passwordWidgetController.text,
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

  Widget _signInWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            text: "Már van fiókom",
            style: TextStyle(
              color: Colors.deepPurple[300],
              fontWeight: FontWeight.normal,
              fontSize: 20,
              letterSpacing: 1,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginUI()),
                );
              },
          ),
        ),
      ],
    );
  }
}
