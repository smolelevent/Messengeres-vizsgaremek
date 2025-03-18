import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
//import 'package:device_preview/device_preview.dart';
import 'package:chatex/main/reset_password.dart';
import 'package:chatex/main/sign_up.dart';
import 'package:chatex/logic/auth.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
//import 'package:chatex/chat/chat_build_ui.dart';
import 'dart:developer';

//TODO: alkalmazás belépéskor ne a Flutter logo legyen

//TODO: ha nyelvek angol és regisztráció akkor utána magyart állít be

//TODO: nincs adat akkor is lila a bejelentkezés gomb

//TODO: phpMyAdmin id-k sorrendje rendezése

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(MaterialApp(
    // builder: (context, child) {
    //   return Overlay(
    //     initialEntries: [
    //       OverlayEntry(builder: (context) => child!),
    //     ],
    //   );
    // },
    home: LoginUI(),
    //home: ChatUI(),
    //home: LanguageSetting(),
  ));
}

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  bool _isPasswordNotVisible = true;

  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLogInDisabled = true;

  String _selectedLanguage = Preferences.getPreferredLanguage();

  void _checkLogInFieldsValidation() {
    final isEmailValid =
        _formKey.currentState?.fields['email']?.isValid ?? false;
    final isPasswordValid =
        _formKey.currentState?.fields['password']?.isValid ?? false;
    setState(() {
      _isLogInDisabled = !(isEmailValid && isPasswordValid);
    });
  }

  void _validateActiveField() {
    if (_emailFocusNode.hasFocus) {
      _formKey.currentState?.fields['email']?.validate();
    } else if (_passwordFocusNode.hasFocus) {
      _formKey.currentState?.fields['password']?.validate();
    }
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override //FlutterToast
  void didChangeDependencies() {
    super.didChangeDependencies();
    ToastMessages.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        body: FormBuilder(
          key: _formKey,
          onChanged: () {
            _validateActiveField();
            _checkLogInFieldsValidation();
          },
          child: Column(
            children: [
              const SizedBox(
                height: 25.0,
              ),
              _dropDownMenu(),
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/logo.jpg"),
              ),
              _emailAddressWidget(),
              _passwordWidget(),
              const SizedBox(
                height: 10.0,
              ),
              _logInWidget(),
              const SizedBox(
                height: 5.0,
              ),
              _forgotPasswordWidget(),
              _registrationWidget(),
              _chatexWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropDownMenu() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownMenu(
        requestFocusOnTap: false,
        label: _selectedLanguage == "Magyar"
            ? const Text("Nyelvek")
            : const Text("Languages"),
        initialSelection: _selectedLanguage,
        onSelected: (String? newValue) {
          setState(() {
            _selectedLanguage = newValue!;
          });
        },
        dropdownMenuEntries: [
          DropdownMenuEntry(
            style: TextButton.styleFrom(
              //választó részben lévő nyelv stílusa
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            value: "Magyar",
            label: "Magyar",
          ),
          DropdownMenuEntry(
            style: TextButton.styleFrom(
              //választó részben lévő nyelv stílusa
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            value: "English",
            label: "English",
          ),
        ],
        trailingIcon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        selectedTrailingIcon: const Icon(
          Icons.arrow_drop_up,
          color: Colors.deepPurpleAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          enabledBorder: const OutlineInputBorder(
            //állandó border
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
          ),
        ),
        textStyle: const TextStyle(
          //kiválasztott nyelv stílusa
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        menuStyle: MenuStyle(
          //választó rész
          backgroundColor: WidgetStatePropertyAll(Colors.deepPurpleAccent),
          elevation: WidgetStatePropertyAll(5),
        ),
      ),
    );
  }

  Widget _emailAddressWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        key: const Key("email"),
        name: "email",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.email(
              regex: RegExp(
                  r"^[a-zA-z0-9.!#$°&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-z]+",
                  unicode: true),
              errorText: _selectedLanguage == "Magyar"
                  ? "Az email cím érvénytelen!"
                  : "The email address is invalid!",
              checkNullOrEmpty: false),
          FormBuilderValidators.required(
              errorText: _selectedLanguage == "Magyar"
                  ? "Az email cím nem lehet üres!"
                  : "The email address cannot be empty!",
              checkNullOrEmpty: false),
        ]),
        focusNode: _emailFocusNode,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          //szöveg stílusa
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          //padding hozzáadása a mezőhöz
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: _isEmailFocused
              ? null
              : _selectedLanguage == "Magyar"
                  ? "E-mail cím"
                  : "E-mail address",
          labelText: _isEmailFocused
              ? _selectedLanguage == "Magyar"
                  ? "E-mail cím"
                  : "Email address"
              : null,
          enabledBorder: const UnderlineInputBorder(
            //állandó szín a mező alsó csíkjának
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.5,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            //fókuszra lila lesz a mező alsó csíkja
            borderSide: BorderSide(
              color: Colors.deepPurpleAccent,
              width: 2.5,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          helperStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            letterSpacing: 1.0,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _passwordWidget() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: FormBuilderTextField(
        key: const Key("password"),
        name: "password",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszó nem lehet üres!"
                  : "The password cannot be empty!",
              checkNullOrEmpty: false),
          FormBuilderValidators.minLength(8,
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszó túl rövid! (min 8 karakter)"
                  : "The password is too short! (min 8 characters)",
              checkNullOrEmpty: false),
          FormBuilderValidators.maxLength(20,
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszó túl hosszú! (max 20 karakter)"
                  : "The password is too long! (max 20 characters)",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasUppercaseChars(
              atLeast: 1,
              regex: RegExp(r'\p{Lu}', unicode: true),
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszónak legalább 1 nagybetűt tartalmaznia kell!"
                  : "The password must contain at least 1 uppercase letter!",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasLowercaseChars(
              atLeast: 1,
              regex: RegExp(r'\p{Ll}', unicode: true),
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszónak legalább 1 kisbetűt tartalmaznia kell!"
                  : "The password must contain at least 1 lowercase letter!",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasNumericChars(
              atLeast: 1,
              regex: RegExp(r'[0-9]', unicode: true),
              errorText: _selectedLanguage == "Magyar"
                  ? "A jelszónak legalább 1 számot tartalmaznia kell!"
                  : "The password must contain at least 1 number!",
              checkNullOrEmpty: false),
        ]),
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        obscureText: _isPasswordNotVisible,
        style: const TextStyle(
          //szöveg stílusa
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            //szem ikon változása
            icon: Icon(
              _isPasswordNotVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordNotVisible = !_isPasswordNotVisible;
              });
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: _isPasswordFocused
              ? null
              : _selectedLanguage == "Magyar"
                  ? "Jelszó"
                  : "Password",
          labelText: _isPasswordFocused
              ? _selectedLanguage == "Magyar"
                  ? "Jelszó"
                  : "Password"
              : null,
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
          helperStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            letterSpacing: 1.0,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _logInWidget() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              key: const Key("logIn"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[700],
                disabledForegroundColor: Colors.white,
                elevation: 5,
              ),
              onPressed: _isLogInDisabled
                  ? null
                  : () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        await AuthService().logIn(
                            email: _emailController,
                            password: _passwordController,
                            context: context,
                            language: _selectedLanguage);
                      }
                    },
              child: _selectedLanguage == "Magyar"
                  ? Text(
                      "Bejelentkezés",
                      style: TextStyle(
                        fontSize:
                            20 * MediaQuery.of(context).textScaler.scale(1.0),
                        height: 3.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    )
                  : Text(
                      "Log in",
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
    );
  }

  Widget _forgotPasswordWidget() {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ForgotPasswordPage(language: _selectedLanguage)));
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
      child: _selectedLanguage == "Magyar"
          ? const Text(
              "Elfelejtett jelszó",
            )
          : const Text(
              "Forgot password",
            ),
    );
  }

  Widget _registrationWidget() {
    return Expanded(
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
                            builder: (context) =>
                                SignUp(language: _selectedLanguage)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: _selectedLanguage == "Magyar"
                      ? Text(
                          "Új fiók létrehozása",
                          style: TextStyle(
                            fontSize: 20 *
                                MediaQuery.of(context).textScaler.scale(1.0),
                            //minden eszközön elvileg ugyanakkora lesz (px helyett dp)
                            height: 3.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        )
                      : Text(
                          "Create new account",
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
    );
  }

  Widget _chatexWidget() {
    return Padding(
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
    );
  }
}
/*
           │Entrance hidden by
           │Bricks and rubble
       ▂▃▂▅▇▅▅▇▄▃
    ┳  ║       ║▔▔▔▔▔▔▔
    │  ╚╗     ╔╝
    │   ║     ║   │
   6ft  ╚╗   ╔╝   │
    │====o   ╚════│═════╗
    │   │║@    ▇▅▆▇▆▅▅█ ║
    ┷   │╚│═════════════╝
Air vent│ │Fan
*/
