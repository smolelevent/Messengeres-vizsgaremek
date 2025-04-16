import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/logic/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.language});

  final String language;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  bool _isUsernameFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isPasswordConfirmFocused = false;

  bool _isPasswordNotVisible = true;

  final _formKey = GlobalKey<FormBuilderState>();
  bool _isRegistrationDisabled = true;

  void _checkRegistrationFieldsValidation() {
    final currentState = _formKey.currentState;
    if (currentState == null) return;

    // Explicit validálás (ez frissíti is a mezőket vizuálisan!)
    final isValid = currentState.validate(focusOnInvalid: false);

    // Lekérjük a mezők értékeit
    final usernameValue = currentState.fields['username']?.value;
    final emailValue = currentState.fields['email']?.value;
    final passwordValue = currentState.fields['password']?.value;
    final passwordConfirmValue = currentState.fields['password_confirm']?.value;

    final allFilled = usernameValue.isNotEmpty &&
        emailValue.isNotEmpty &&
        passwordValue.isNotEmpty &&
        passwordConfirmValue.isNotEmpty;

    setState(() {
      _isRegistrationDisabled = !(isValid && allFilled);
    });
  }

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      setState(() {
        _isUsernameFocused = _usernameFocusNode.hasFocus;
      });
    });
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
    _passwordConfirmFocusNode.addListener(() {
      setState(() {
        _isPasswordConfirmFocused = _passwordConfirmFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          shadowColor: Colors.deepPurpleAccent,
          elevation: 10,
          centerTitle: true,
          title: Text(
              widget.language == "Magyar" ? "Regisztráció" : "Registration"),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        body: FormBuilder(
          key: _formKey,
          onChanged: _checkRegistrationFieldsValidation,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      _usernameWidget(const Key("userName")),
                      const SizedBox(height: 10),
                      _emailAddressWidget(const Key("emailAddress")),
                      const SizedBox(height: 10),
                      _passwordWidget(const Key("passWord")),
                      const SizedBox(height: 10),
                      _passwordConfirmWidget(const Key("passWordConfirm")),
                      const SizedBox(height: 25),
                      _signUpWidget(context, const Key("signUp")),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
              _chatexWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameWidget(Key key) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        name: "username",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.minLength(
            3,
            errorText: widget.language == "Magyar"
                ? "A felhasználónév túl rövid! (min 3)"
                : "The username is too short! (min 3)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.maxLength(
            20,
            errorText: widget.language == "Magyar"
                ? "A felhasználónév túl hosszú! (max 20)"
                : "The username is too long! (max 20)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.required(
              errorText: widget.language == "Magyar"
                  ? "A felhasználónév nem lehet üres!"
                  : "The username cannot be empty!",
              checkNullOrEmpty: false),
        ]),
        focusNode: _usernameFocusNode,
        controller: _usernameController,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: _isUsernameFocused
              ? null
              : widget.language == "Magyar"
                  ? "Felhasználónév"
                  : "Username",
          labelText: _isUsernameFocused
              ? widget.language == "Magyar"
                  ? "Felhasználónév"
                  : "Username"
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

  Widget _emailAddressWidget(Key key) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: FormBuilderTextField(
        name: "email",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.email(
              regex: RegExp(
                  r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  unicode: true),
              errorText: widget.language == "Magyar"
                  ? "Az email cím érvénytelen!"
                  : "The email address is invalid!",
              checkNullOrEmpty: false),
          FormBuilderValidators.required(
              errorText: widget.language == "Magyar"
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
              : widget.language == "Magyar"
                  ? "E-mail cím"
                  : "E-mail address",
          helperText: widget.language == "Magyar"
              ? "pl: valaki@kiszolgalo.hu"
              : "eg: example@example.com",
          labelText: _isEmailFocused
              ? widget.language == "Magyar"
                  ? "E-mail cím"
                  : "E-mail address"
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

  Widget _passwordWidget(Key key) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: FormBuilderTextField(
        name: "password",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: widget.language == "Magyar"
                  ? "A jelszó nem lehet üres!"
                  : "The password cannot be empty!",
              checkNullOrEmpty: false),
          FormBuilderValidators.minLength(8,
              errorText: widget.language == "Magyar"
                  ? "A jelszó túl rövid! (min 8 karakter)"
                  : "The password is too short! (min 8 characters)",
              checkNullOrEmpty: false),
          FormBuilderValidators.maxLength(20,
              errorText: widget.language == "Magyar"
                  ? "A jelszó túl hosszú! (max 20 karakter)"
                  : "The password is too long! (max 20 characters)",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasUppercaseChars(
              atLeast: 1,
              regex: RegExp(r'\p{Lu}', unicode: true),
              errorText: widget.language == "Magyar"
                  ? "A jelszónak legalább 1 nagybetűt tartalmaznia kell!"
                  : "The password must contain at least 1 uppercase letter!",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasLowercaseChars(
              atLeast: 1,
              regex: RegExp(r'\p{Ll}', unicode: true),
              errorText: widget.language == "Magyar"
                  ? "A jelszónak legalább 1 kisbetűt tartalmaznia kell!"
                  : "The password must contain at least 1 lowercase letter!",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasNumericChars(
              atLeast: 1,
              regex: RegExp(r'[0-9]', unicode: true),
              errorText: widget.language == "Magyar"
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
              : widget.language == "Magyar"
                  ? "Jelszó"
                  : "Password",
          labelText: _isPasswordFocused
              ? widget.language == "Magyar"
                  ? "Jelszó"
                  : "Password"
              : null,
          helperText: widget.language == "Magyar"
              ? "Min. 8 karakter, Max. 20 karakter,\n1 kisbetű, 1 nagybetű, és 1 szám."
              : "Min. 8 characters, Max. 20 characters,\n1 lowercase, 1 uppercase, and 1 number.",
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

  Widget _passwordConfirmWidget(Key key) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: FormBuilderTextField(
        name: "password_confirm",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: widget.language == "Magyar"
                  ? "A mezőnek meg kell egyeznie a jelszó mezővel!"
                  : "The field must match the password field!",
              checkNullOrEmpty: false),
          FormBuilderValidators.equal(_passwordController.text,
              errorText: widget.language == "Magyar"
                  ? "A jelszavak nem egyeznek meg!"
                  : "The passwords do not match!",
              checkNullOrEmpty: false),
        ]),
        focusNode: _passwordConfirmFocusNode,
        controller: _passwordConfirmController,
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
          labelText: _isPasswordConfirmFocused
              ? widget.language == "Magyar"
                  ? "Jelszó újra"
                  : "Confirm password"
              : null,
          hintText: _isPasswordConfirmFocused
              ? null
              : widget.language == "Magyar"
                  ? "Jelszó újra"
                  : "Confirm password",
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
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _signUpWidget(BuildContext context, Key key) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[700],
                disabledForegroundColor: Colors.white,
                elevation: 5,
              ),
              onPressed: _isRegistrationDisabled
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.saveAndValidate()) {
                        await AuthService().register(
                          username: _usernameController,
                          email: _emailController,
                          password: _passwordController,
                          context: context,
                          language: widget.language,
                        );
                      }
                    },
              child: Text(
                widget.language == "Magyar" ? "Regisztrálás" : "Sign up",
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

  Widget _chatexWidget() {
    return Expanded(
      flex: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
