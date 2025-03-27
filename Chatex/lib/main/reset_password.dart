import 'package:flutter/material.dart';
import 'package:chatex/logic/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.language});

  final String language;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordResetButtonDisabled = true;

  void _checkPasswordResetFieldValidation() {
    final isEmailValid =
        _formKey.currentState?.fields['email']?.isValid ?? false;
    setState(() {
      _isPasswordResetButtonDisabled = !(isEmailValid);
    });
  }

  void _validateEmailAddressField() {
    if (_emailFocusNode.hasFocus) {
      _formKey.currentState?.fields['email']?.validate();
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          shadowColor: Colors.deepPurpleAccent,
          elevation: 10,
        ),
        body: Stack(
          children: [
            FormBuilder(
              key: _formKey,
              onChanged: () {
                _validateEmailAddressField();
                _checkPasswordResetFieldValidation();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.language == "Magyar"
                          ? "A jelszó helyreállításához\nadja meg az e-mail címét!"
                          : "To reset your password\nenter your email address!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  _emailAddressFieldWidget(),
                  _passwordResetButtonWidget(),
                  _chatexWidget(),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.deepPurpleAccent,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _emailAddressFieldWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        name: "email",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.email(
              regex: RegExp(
                  r"^[a-zA-z0-9.!#$°&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-z]+",
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
              : widget.language == "Magyar"
                  ? "E-mail cím"
                  : "Email address",
          labelText: _isEmailFocused
              ? widget.language == "Magyar"
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

  Widget _passwordResetButtonWidget() {
    return Expanded(
      flex: 0,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 20.0,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[700],
                    disabledForegroundColor: Colors.white,
                    elevation: 5,
                  ),
                  onPressed: _isPasswordResetButtonDisabled || _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.saveAndValidate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              //TODO: mire megjelenik a toast message addigra tűnjön el a loading
                              await AuthService().resetPassword(
                                email: _emailController,
                                context: context,
                                language: widget.language,
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                  child: Text(
                    widget.language == "Magyar"
                        ? "Jelszó helyreállítása"
                        : "Reset password",
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
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Align(
          alignment: Alignment.bottomCenter,
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
    );
  }
}
