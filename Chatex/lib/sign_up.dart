import 'package:chatex/auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.onSubmit});
  //saját konstruktor
  const SignUp.withoutSubmit({super.key}) : onSubmit = null;
  final ValueChanged<String>? onSubmit;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isPasswordConfirmFocused = false;
  
  bool _isPasswordVisible = true;
  final bool _isPasswordMatching = true;


final _formKey = GlobalKey<FormBuilderState>();

/*
  final _formKey = GlobalKey<FormState>();

  String? _passwordValidator(String? value) {
  final text = _passwordController.value.text;
  if (text.isEmpty){
    return null;
  } else if (text.length < 8) {
    return 'A jelszó túl rövid! (min 8 karakter)';
  } else if (text.length > 20){
    return 'A jelszó túl hosszú! (max 20 karakter)';
  } else if (!RegExp(r'\p{Lu}', unicode: true).hasMatch(text)){
    return 'A jelszónak legalább 1 nagybetűt tartalmaznia kell!';
  } else if (!RegExp(r'\p{Ll}', unicode: true).hasMatch(text)){
    return 'A jelszónak legalább 1 kisbetűt tartalmaznia kell!';
  } else if (!RegExp(r'[0-9]').hasMatch(text)){
    return 'A jelszónak legalább 1 számot tartalmaznia kell!';
  } 
  /*else if (!_isPasswordMatching) {
    return 'A jelszavak nem egyeznek meg!';
  }*/ else {
    return null;
  }
}

String? _emailValidator(String? value){
  final text = _emailController.value.text;
if (text.isEmpty){
  return 'Az email cím üres!';
  } else if (!RegExp(r"^[a-zA-z0-9.!#$°&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-z]+").hasMatch('value')){
    return 'Az email cím érvénytelen!';
  } else {
    return null;
  }
}

String? _passwordConfirmValidator(String? value){
  final text = _passwordConfirmController.value.text;
    if (text != _passwordController.value.text) {
      return 'A jelszavak nem egyeznek meg!';
    } else {
      return null;
    }
  }
  */


  void _submit(){
    if(_passwordValidator == null && widget.onSubmit != null){
        widget.onSubmit!(_passwordController.value.text);
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
    _passwordConfirmFocusNode.addListener(() {
      setState(() {
        _isPasswordConfirmFocused = _passwordConfirmFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    super.dispose();
  }

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
          const SizedBox(
            height: 25,
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
    );
  }
    
  Widget _emailAddressWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: TextFormField(
        validator: _emailValidator,
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
          helperText: "Pl.: kugifej@gmail.com",
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
          child: TextField(
            focusNode: _passwordFocusNode,
            controller: _passwordController,
            obscureText: _isPasswordVisible,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              hintText: _isPasswordFocused ? null : "Jelszó",
              labelText: _isPasswordFocused ? "Jelszó" : null,
              helperText: "Legalább 8 karakter, 1 kisbetű,\n1 nagybetű, és 1 szám.",
              //errorText: _passwordValidator,
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
      child: TextField(
        focusNode: _passwordConfirmFocusNode,
        controller: _passwordConfirmController,
        obscureText: _isPasswordVisible,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          labelText: _isPasswordConfirmFocused ? "Jelszó újra" : null,
          hintText: _isPasswordConfirmFocused ? null : "Jelszó újra",
          errorText: _isPasswordMatching ? null : "A jelszavak nem egyeznek",
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
                elevation: 5,
              ),
              onPressed: () async {
                //_passwordController.value.text.isNotEmpty ? _submit : null;
                /*if (_formKey.currentState!.validate()) {
                  
                }*/

                await AuthService().register(
                    email: _emailController,
                    password: _passwordController,
                    context: context);
                },
              child: Text(                                                                                                                                                              //gg ez
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