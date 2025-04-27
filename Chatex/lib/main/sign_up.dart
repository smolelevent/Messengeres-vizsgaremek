import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/logic/auth.dart';

//SignUp OSZTÁLY ELEJE ----------------------------------------------------------------------------
class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.language});

  final String language; //átadjuk itt is a megjelenésért

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //ugyanaz a minta
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _isUsernameFocused = false;

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailFocused = false;

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordFocused = false;
  bool _isPasswordNotVisible = true;

  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final FocusNode _passwordConfirmFocusNode = FocusNode();
  bool _isPasswordConfirmFocused = false;
  bool _isPasswordConfirmNotVisible = true;

  final _formKey = GlobalKey<FormBuilderState>();
  bool _isRegistrationDisabled = true;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

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

  void _checkRegistrationFieldsValidation() {
    final currentState = _formKey.currentState;
    if (currentState == null) return;

    final isValid = currentState.validate(focusOnInvalid: false);

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

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[850],
        appBar: _buildAppbar(),
        body: _buildBody(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        widget.language == "Magyar" ? "Regisztráció" : "Registration",
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 10,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildBody() {
    return FormBuilder(
      key: _formKey,
      onChanged: _checkRegistrationFieldsValidation,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //a kulcs paraméterek a teszteléshez kellenek!
                  _buildUsernameWidget(const Key("userName")),
                  _buildEmailWidget(const Key("emailAddress")),
                  _buildPasswordWidget(const Key("passWord")),
                  _buildPasswordConfirmWidget(const Key("passWordConfirm")),
                  _buildSignupWidget(context, const Key("signUp")),
                ],
              ),
            ),
          ),
          _chatexWidget(),
        ],
      ),
    );
  }

  InputDecoration _decorationForInput(
    TextEditingController controller,
    String title,
    bool focusVariable,
    String? helperText, {
    VoidCallback? onVisibilityToggle,
    bool? obscureText,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      suffixIcon: (onVisibilityToggle == null)
          ? (controller.text.isNotEmpty
              ? _buildDeleteContentIcon(controller)
              : null)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.text.isNotEmpty)
                  _buildDeleteContentIcon(controller),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: onVisibilityToggle,
                    child: Icon(
                      obscureText! ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ],
            ),
      hintText: focusVariable ? null : title,
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      labelText: focusVariable ? title : null,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        letterSpacing: 1.0,
      ),
      helperText: helperText,
      helperStyle: const TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        letterSpacing: 1.0,
      ),
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
    );
  }

  Widget _buildDeleteContentIcon(TextEditingController controller) {
    return GestureDetector(
      onTap: () => controller.clear(),
      child: const Icon(
        Icons.clear_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildUsernameWidget(Key key) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
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
        ]),
        focusNode: _usernameFocusNode,
        controller: _usernameController,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(
          _usernameController,
          widget.language == "Magyar" ? "Felhasználónév" : "Username",
          _isUsernameFocused,
          null,
        ),
      ),
    );
  }

  Widget _buildEmailWidget(Key key) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
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
        ]),
        focusNode: _emailFocusNode,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(
          _emailController,
          widget.language == "Magyar" ? "E-mail cím" : "E-mail address",
          _isEmailFocused,
          widget.language == "Magyar"
              ? "pl: valaki@kiszolgalo.hu"
              : "eg: example@example.com",
        ),
      ),
    );
  }

  Widget _buildPasswordWidget(Key key) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: FormBuilderTextField(
        name: "password",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
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
        decoration: _decorationForInput(
          _passwordController,
          widget.language == "Magyar" ? "Jelszó" : "Password",
          _isPasswordFocused,
          widget.language == "Magyar"
              ? "Min. 8 karakter, Max. 20 karakter,\n1 kisbetű, 1 nagybetű, és 1 szám."
              : "Min. 8 characters, Max. 20 characters,\n1 lowercase, 1 uppercase, and 1 number.",
          onVisibilityToggle: () {
            setState(() {
              _isPasswordNotVisible = !_isPasswordNotVisible;
            });
          },
          obscureText: _isPasswordNotVisible,
        ),
      ),
    );
  }

  Widget _buildPasswordConfirmWidget(Key key) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 30),
      child: FormBuilderTextField(
        name: "password_confirm",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.equal(_passwordController.text,
              errorText: widget.language == "Magyar"
                  ? "A jelszavak nem egyeznek meg!"
                  : "The passwords do not match!",
              checkNullOrEmpty: false),
        ]),
        focusNode: _passwordConfirmFocusNode,
        controller: _passwordConfirmController,
        obscureText: _isPasswordConfirmNotVisible,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(
          _passwordConfirmController,
          widget.language == "Magyar" ? "Jelszó újra" : "Confirm password",
          _isPasswordConfirmFocused,
          null,
          onVisibilityToggle: () {
            setState(() {
              _isPasswordConfirmNotVisible = !_isPasswordConfirmNotVisible;
            });
          },
          obscureText: _isPasswordConfirmNotVisible,
        ),
      ),
    );
  }

  Widget _buildSignupWidget(BuildContext context, Key key) {
    return Row(
      children: [
        Expanded(
          //teljes szélességben legyen
          flex: 1,
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
                      //ha megnyomódott akkor lépjen ki a billentyűzetből
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
                  //minden kijelzőn egységes 20-as méret
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
    return const Expanded(
      flex: 0,
      child: Row(
        children: [
          Expanded(
            //teljes szélességben legyen
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Chatex",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//SignUp OSZTÁLY VÉGE -----------------------------------------------------------------------------
