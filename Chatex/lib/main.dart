import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
//import 'package:device_preview/device_preview.dart'; //TODO: device_preview
import 'package:chatex/main/reset_password.dart';
import 'package:chatex/main/sign_up.dart';
import 'package:chatex/application/components_of_chat/build_ui.dart';
import 'package:chatex/logic/notifications.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/auth.dart';
import 'dart:convert';
import 'dart:developer';

//TODO: phpMyAdmin id-k sorrendje rendezése

//TODO: keyboard submit után automatikusan zárja be a billentyűzetet

//TODO: forgot password feliratnál egy kicsit nagyobb legyen a hely

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Preferences.init();
  await NotificationService.initialize();
  FlutterNativeSplash.remove();

  final isLoggedIn = await tryAutoLogin();

  runApp(MaterialApp(
    home: isLoggedIn ? const ChatUI() : const LoginUI(),
  ));
}

Future<bool> tryAutoLogin() async {
  final token = Preferences.getToken();

  try {
    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/auth/validate_token.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData["success"] == true) {
      Preferences.setUserId(responseData["id"]);
      Preferences.setPreferredLanguage(responseData["preferred_lang"]);
      Preferences.setProfilePicture(responseData["profile_picture"]);
      Preferences.setUsername(responseData["username"]);
      Preferences.setEmail(responseData["email"]);
      Preferences.setPasswordHash("password_hash");
      return true;
    }
  } catch (e) {
    log("Hiba a token validálásakor: ${e.toString()}");
  }

  return false;
}

class LoginUI extends StatefulWidget {
  const LoginUI({
    super.key,
  });

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

  @override //FlutterToast-hoz kell hogy mindenhol megtudjon jelenni
  void didChangeDependencies() {
    super.didChangeDependencies();
    ToastMessages.init(context);
  }

  void _checkLogInFieldsValidation() {
    final currentState = _formKey.currentState;
    if (currentState == null) return;

    // Explicit validálás (ez frissíti is a mezőket vizuálisan!)
    final isValid = currentState.validate(focusOnInvalid: false);

    // Lekérjük a mezők értékeit
    final emailValue = currentState.fields['email']?.value?.trim() ?? '';
    final passwordValue = currentState.fields['password']?.value?.trim() ?? '';

    final allFilled = emailValue.isNotEmpty && passwordValue.isNotEmpty;

    setState(() {
      _isLogInDisabled = !(isValid && allFilled);
    });
  }

  Widget _dropDownMenu() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownMenu<String>(
        requestFocusOnTap: false,
        label: Text(
          _selectedLanguage == "Magyar" ? "Nyelvek" : "Languages",
        ),
        initialSelection: _selectedLanguage,
        onSelected: (newValue) {
          setState(() {
            _selectedLanguage = newValue!;
          });
        },
        dropdownMenuEntries: [
          DropdownMenuEntry(
            style: TextButton.styleFrom(
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
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
          ),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        menuStyle: const MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.deepPurpleAccent),
          elevation: WidgetStatePropertyAll(5),
        ),
      ),
    );
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
                backgroundImage: AssetImage("assets/logo/logo.jpg"),
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),
              ),
              _registrationWidget(),
              _chatexWidget(),
            ],
          ),
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
                  r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
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
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
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
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.5,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
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
          helperStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            letterSpacing: 1.0,
          ),
          labelStyle: const TextStyle(
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
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
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
          helperStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            letterSpacing: 1.0,
          ),
          labelStyle: const TextStyle(
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
                          language: _selectedLanguage,
                        );
                      }
                    },
              child: Text(
                _selectedLanguage == "Magyar" ? "Bejelentkezés" : "Login",
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

  Widget _forgotPasswordWidget() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(
              language: _selectedLanguage,
            ),
          ),
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
      child: Text(
        _selectedLanguage == "Magyar"
            ? "Elfelejtett jelszó"
            : "Forgot password",
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
                        builder: (context) => SignUp(
                          language: _selectedLanguage,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: Text(
                    _selectedLanguage == "Magyar"
                        ? "Új fiók létrehozása"
                        : "Create a new account",
                    style: TextStyle(
                      fontSize:
                          20 * MediaQuery.of(context).textScaler.scale(1.0),
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
