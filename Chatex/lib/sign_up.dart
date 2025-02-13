import 'package:flutter/material.dart';
import 'package:chatex/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

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
    final isEmailValid =
        _formKey.currentState?.fields['email']?.isValid ?? false;
    final isPasswordValid =
        _formKey.currentState?.fields['password']?.isValid ?? false;
    final isPasswordConfirmValid =
        _formKey.currentState?.fields['passwordConfirm']?.isValid ?? false;
    final isUsernameValid =
        _formKey.currentState?.fields['username']?.isValid ?? false;
    setState(() {
      _isRegistrationDisabled = !(isEmailValid &&
          isPasswordValid &&
          isPasswordConfirmValid &&
          isUsernameValid);
    });
  }

  void _validateActiveField() {
    if (_emailFocusNode.hasFocus) {
      _formKey.currentState?.fields['email']?.validate();
    } else if (_passwordFocusNode.hasFocus) {
      _formKey.currentState?.fields['password']?.validate();
    } else if (_passwordConfirmFocusNode.hasFocus) {
      _formKey.currentState?.fields['passwordConfirm']?.validate();
    } else if (_usernameFocusNode.hasFocus) {
      _formKey.currentState?.fields['username']?.validate();
    }
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

//TODO: ha ki kattintunk a mezőből akkor jelenjenek meg az információk különben vizsgálja hogy az üres mezőt stb... - már deepseeken foglalkoztam vele
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
            _validateActiveField();
            _checkRegistrationFieldsValidation();
          },
          child: Column(
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
              const SizedBox(
                height: 25,
              ),
              _usernameWidget(),
              const SizedBox(
                height: 10,
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
              _chatexWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        name: "username",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.minLength(
            3,
            errorText: "A felhasználónév túl rövid! (min 3)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.maxLength(
            20,
            errorText: "A felhasználónév túl hosszú! (max 20)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.required(
              errorText: "A felhasználónév nem lehet üres!"),
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
          hintText: _isUsernameFocused ? null : "Felhasználónév",
          labelText: _isUsernameFocused ? "Felhasználónév" : null,
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

  Widget _emailAddressWidget() {
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
              errorText: "Az email cím érvénytelen!",
              checkNullOrEmpty: false),
          FormBuilderValidators.required(
              errorText: "Az email cím nem lehet üres!"),
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
          hintText: _isEmailFocused ? null : "E-mail cím",
          helperText: "pl: valaki@kiszolgalo.hu",
          labelText: _isEmailFocused ? "E-mail cím" : null,
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

  Widget _passwordWidget() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: FormBuilderTextField(
        name: "password",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: "A jelszó nem lehet üres!"),
          FormBuilderValidators.minLength(8,
              errorText: "A jelszó túl rövid! (min 8 karakter)",
              checkNullOrEmpty: false),
          FormBuilderValidators.maxLength(20,
              errorText: "A jelszó túl hosszú! (max 20 karakter)",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasUppercaseChars(
              atLeast: 1,
              regex: RegExp(r'\p{Lu}', unicode: true),
              errorText: "A jelszónak legalább 1 nagybetűt tartalmaznia kell!",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasLowercaseChars(
              atLeast: 1,
              regex: RegExp(r'\p{Ll}', unicode: true),
              errorText: "A jelszónak legalább 1 kisbetűt tartalmaznia kell!",
              checkNullOrEmpty: false),
          FormBuilderValidators.hasNumericChars(
              atLeast: 1,
              regex: RegExp(r'[0-9]', unicode: true),
              errorText: "A jelszónak legalább 1 számot tartalmaznia kell!",
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
          hintText: _isPasswordFocused ? null : "Jelszó",
          labelText: _isPasswordFocused ? "Jelszó" : null,
          helperText:
              "Min. 8 karakter, Max. 20 karakter,\n1 kisbetű, 1 nagybetű, és 1 szám.",
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

  Widget _passwordConfirmWidget() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: FormBuilderTextField(
        name: "passwordConfirm",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: "A mezőnek meg kell egyeznie a jelszó mezővel!"),
          FormBuilderValidators.equal(_passwordController.text,
              errorText: "A jelszavak nem egyeznek meg!",
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
          labelText: _isPasswordConfirmFocused ? "Jelszó újra" : null,
          hintText: _isPasswordConfirmFocused ? null : "Jelszó újra",
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
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            letterSpacing: 1.0,
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
                disabledBackgroundColor: Colors.grey[700],
                disabledForegroundColor: Colors.white,
                elevation: 5,
              ),
              onPressed: _isRegistrationDisabled
                  ? null
                  : () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        await AuthService().register(
                          username: _usernameController,
                          email: _emailController,
                          password: _passwordController,
                          context: context,
                        );
                      }
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

  Widget _chatexWidget() {
    return Expanded(
      flex: 1,
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

//TODO: tesztek írása, csökkenteni a kód méretét
