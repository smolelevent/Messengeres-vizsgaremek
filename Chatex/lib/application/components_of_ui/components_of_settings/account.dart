import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';

//AccountSetting OSZTÁLY ELEJE --------------------------------------------------------------------
class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

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
  bool _isEditingUsername = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;

  String? _profilePicture = Preferences.getProfilePicture();
  File? _selectedImage;

  bool _hasChanges = false;
  bool _isFormValid = false;

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

    _usernameController.addListener(() {
      if (_isEditingUsername) setState(() {});
    });

    _emailController.addListener(() {
      if (_isEditingEmail) setState(() {});
    });

    _usernameController.addListener(_onAnyFieldChanged);
    _emailController.addListener(_onAnyFieldChanged);
    _passwordController.addListener(_onAnyFieldChanged);
    _passwordConfirmController.addListener(_onAnyFieldChanged);

    _usernameFocusNode.addListener(_onAnyFieldChanged);
    _emailFocusNode.addListener(_onAnyFieldChanged);
    _passwordFocusNode.addListener(_onAnyFieldChanged);
    _passwordConfirmFocusNode.addListener(_onAnyFieldChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
  }

  void _onAnyFieldChanged() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    final hasProfilePictureChanged = _selectedImage != null;

    setState(() {
      _isFormValid = isFormValid || hasProfilePictureChanged;
    });
  }

  Future<void> _pickProfilePicture() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final List<int> imageAsBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageAsBytes);
      String mimeType;

      if (pickedFile.path.endsWith(".svg")) {
        mimeType = "data:image/svg+xml;base64,";
      } else if (pickedFile.path.endsWith(".jpg")) {
        mimeType = "data:image/jpg;base64,";
      } else if (pickedFile.path.endsWith(".jpeg")) {
        mimeType = "data:image/jpeg;base64,";
      } else if (pickedFile.path.endsWith(".png")) {
        mimeType = "data:image/png;base64,";
      } else {
        ToastMessages.showToastMessages(
          "Nem támogatott fájlformátum!",
          0.2,
          Colors.red,
          Icons.image,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        return;
      }

      setState(() {
        _selectedImage = imageFile;
        _profilePicture = "$mimeType$base64Image";
      });

      ToastMessages.showToastMessages(
        "Kép kiválasztva! Most módosíthatod!",
        0.2,
        Colors.orange,
        Icons.image,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }

  // Future<void> _updateProfilePicture() async {
  //   if (_selectedImage == null) {
  //     ToastMessages.showToastMessages(
  //       "Nincs kiválasztott kép!",
  //       0.2,
  //       Colors.redAccent,
  //       Icons.error,
  //       Colors.black,
  //       const Duration(seconds: 2),
  //       context,
  //     );
  //   } else {
  //     try {
  //       log(_profilePicture.toString());
  //       final response = await http.post(
  //         Uri.parse(
  //             "http://10.0.2.2/ChatexProject/chatex_phps/settings/update_profile_picture.php"),
  //         body: jsonEncode({
  //           "user_id": Preferences.getUserId(),
  //           "profile_picture": _profilePicture,
  //         }),
  //         headers: {"Content-Type": "application/json"},
  //       );
  //       final responseData = json.decode(response.body);
  //       log(responseData.toString());
  //       if (responseData["status"] == "success") {
  //         ToastMessages.showToastMessages(
  //           "Profilkép frissítve!",
  //           0.2,
  //           Colors.green,
  //           Icons.check,
  //           Colors.black,
  //           const Duration(seconds: 2),
  //           context,
  //         );

  //         await Preferences.setProfilePicture(_profilePicture!);
  //       } else {
  //         ToastMessages.showToastMessages(
  //           "Hiba történt a frissítés során!",
  //           0.2,
  //           Colors.redAccent,
  //           Icons.error,
  //           Colors.black,
  //           const Duration(seconds: 2),
  //           context,
  //         );
  //       }
  //     } catch (e) {
  //       ToastMessages.showToastMessages(
  //         Preferences.getPreferredLanguage() == "Magyar"
  //             ? "Kapcsolati hiba a profilkép frissítése közben!"
  //             : "Connection error by updating profile picture!",
  //         0.2,
  //         Colors.redAccent,
  //         Icons.error,
  //         Colors.black,
  //         const Duration(seconds: 2),
  //         context,
  //       );
  //       log(e.toString());
  //     }
  //   }
  // }

  Future<void> _updateUsername() async {
    if (_usernameController.text.isEmpty) {
      //TODO: nem jól van le kezelve
      ToastMessages.showToastMessages(
        "A név nem lehet üres!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    } else {
      try {
        final response = await http.post(
          Uri.parse(
              "http://10.0.2.2/ChatexProject/chatex_phps/settings/update_username.php"),
          body: jsonEncode({"username": _usernameController.text}),
          headers: {"Content-Type": "application/json"},
        );

        final responseData = json.decode(response.body);
        if (responseData["status"] == "success") {
          ToastMessages.showToastMessages(
            "Felhasználónév frissítve!",
            0.2,
            Colors.green,
            Icons.check,
            Colors.black,
            const Duration(seconds: 2),
            context,
          );

          await Preferences.setUsername(_usernameController.text);
        } else {
          ToastMessages.showToastMessages(
            "Hiba történt a frissítés során!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2),
            context,
          );
        }
      } catch (e) {
        ToastMessages.showToastMessages(
          Preferences.getPreferredLanguage() == "Magyar"
              ? "Kapcsolati hiba a felhasználónév frissítése közben!"
              : "Connection error by updating username!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        log(e.toString());
      }
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: _buildAppbar(),
        body: _buildBody(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    //ez a metódus felépíti az appbar-t
    return AppBar(
      title: AutoSizeText(
        Preferences.isHungarian ? "Fiók kezelése" : "Account managment",
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            _buildDivider(
                Preferences.isHungarian ? "Fiók adatai" : "Account details"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        _buildEditableField(
                          title: Preferences.isHungarian
                              ? "Felhasználónév"
                              : "Username",
                          fieldName: "username",
                          initialValue: Preferences.getUsername(),
                          isEditing: _isEditingUsername,
                          focusNode: _usernameFocusNode,
                          focusVariable: _isUsernameFocused,
                          controller: _usernameController,
                          keyboardType: TextInputType.name,
                          onEditToggle: () {
                            setState(() {
                              _isEditingUsername = !_isEditingUsername;
                            });
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.minLength(
                              3,
                              errorText: Preferences.isHungarian
                                  ? "A felhasználónév túl rövid! (min 3)"
                                  : "The username is too short! (min 3)",
                              checkNullOrEmpty: false,
                            ),
                            FormBuilderValidators.maxLength(
                              20,
                              errorText: Preferences.isHungarian
                                  ? "A felhasználónév túl hosszú! (max 20)"
                                  : "The username is too long! (max 20)",
                              checkNullOrEmpty: false,
                            ),
                            FormBuilderValidators.required(
                                errorText: Preferences.isHungarian
                                    ? "A felhasználónév nem lehet üres!"
                                    : "The username cannot be empty!",
                                checkNullOrEmpty: false),
                          ]),
                        ),
                        _buildEditableField(
                          title:
                              Preferences.isHungarian ? "Email cím" : "Email",
                          fieldName: "email",
                          initialValue: Preferences.getEmail(),
                          isEditing: _isEditingEmail,
                          focusNode: _emailFocusNode,
                          focusVariable: _isEmailFocused,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onEditToggle: () {
                            setState(() {
                              _isEditingEmail = !_isEditingEmail;
                            });
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(
                                regex: RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                    unicode: true),
                                errorText: Preferences.isHungarian
                                    ? "Az email cím érvénytelen!"
                                    : "The email address is invalid!",
                                checkNullOrEmpty: false),
                            FormBuilderValidators.required(
                                errorText: Preferences.isHungarian
                                    ? "Az email cím nem lehet üres!"
                                    : "The email address cannot be empty!",
                                checkNullOrEmpty: false),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildProfilePicture(),
              ],
            ),
            _buildPasswordField(),
            const SizedBox(height: 30),
            _buildUpdateButtons(),
            const SizedBox(height: 30),
            _buildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    Widget image;
    if (_profilePicture == null || _profilePicture!.isEmpty) {
      return _defaultAvatar();
    }

    if (_profilePicture!.startsWith("data:image/svg+xml;base64,")) {
      final svgBytes = base64Decode(_profilePicture!.split(",")[1]);
      image = ClipOval(
        child: SvgPicture.memory(
          svgBytes,
          width: 120,
          height: 120,
          fit: BoxFit.fill,
        ),
      );
    } else if (_profilePicture!.startsWith("data:image/")) {
      final imageBytes = base64Decode(_profilePicture!.split(",")[1]);
      image = ClipOval(
        child: Image.memory(
          imageBytes,
          width: 120,
          height: 120,
          fit: BoxFit.fill,
        ),
      );
    } else {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Ismeretlen MIME-típus a profilképnél!"
            : "An unknown MIME type has been detected!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Ismeretlen MIME-típus a profilképnél: $_profilePicture");
      image = CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[600],
        child: const Icon(
          Icons.person,
          size: 50,
          color: Colors.white,
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 12),
          child: Text(
            Preferences.isHungarian ? "Profilkép:" : "Profile picture:",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            image,
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(
                Icons.edit,
                color: Colors.deepPurpleAccent,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required String title,
    required String fieldName,
    required String? initialValue,
    required bool isEditing,
    required VoidCallback onEditToggle,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    required FocusNode focusNode,
    required TextEditingController controller,
    required bool focusVariable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.deepPurpleAccent,
              ),
              onPressed: onEditToggle,
            ),
          ],
        ),
        if (isEditing)
          FormBuilderTextField(
            name: fieldName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              suffixIcon: controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () => controller.clear(),
                      child: const Icon(
                        Icons.clear_rounded,
                        color: Colors.white,
                      ),
                    )
                  : null,
              hintText: focusVariable ? null : title,
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
              labelText: focusVariable ? title : null,
              labelStyle: const TextStyle(
                color: Colors.white,
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
            ),
          )
        else
          AutoSizeText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            initialValue ?? "Hiba!",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              Preferences.isHungarian ? "Jelszó módosítása" : "Change password",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.deepPurpleAccent,
              ),
              onPressed: () {
                setState(() {
                  _isEditingPassword = !_isEditingPassword;
                });
              },
            ),
          ],
        ),
        if (_isEditingPassword)
          Column(
            children: [
              FormBuilderTextField(
                name: "password",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: Preferences.isHungarian
                          ? "A jelszó nem lehet üres!"
                          : "The password cannot be empty!",
                      checkNullOrEmpty: false),
                  FormBuilderValidators.minLength(8,
                      errorText: Preferences.isHungarian
                          ? "A jelszó túl rövid! (min 8 karakter)"
                          : "The password is too short! (min 8 characters)",
                      checkNullOrEmpty: false),
                  FormBuilderValidators.maxLength(20,
                      errorText: Preferences.isHungarian
                          ? "A jelszó túl hosszú! (max 20 karakter)"
                          : "The password is too long! (max 20 characters)",
                      checkNullOrEmpty: false),
                  FormBuilderValidators.hasUppercaseChars(
                      atLeast: 1,
                      regex: RegExp(r'\p{Lu}', unicode: true),
                      errorText: Preferences.isHungarian
                          ? "A jelszónak legalább 1 nagybetűt tartalmaznia kell!"
                          : "The password must contain at least 1 uppercase letter!",
                      checkNullOrEmpty: false),
                  FormBuilderValidators.hasLowercaseChars(
                      atLeast: 1,
                      regex: RegExp(r'\p{Ll}', unicode: true),
                      errorText: Preferences.isHungarian
                          ? "A jelszónak legalább 1 kisbetűt tartalmaznia kell!"
                          : "The password must contain at least 1 lowercase letter!",
                      checkNullOrEmpty: false),
                  FormBuilderValidators.hasNumericChars(
                      atLeast: 1,
                      regex: RegExp(r'[0-9]', unicode: true),
                      errorText: Preferences.isHungarian
                          ? "A jelszónak legalább 1 számot tartalmaznia kell!"
                          : "The password must contain at least 1 number!",
                      checkNullOrEmpty: false),
                ]),
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                obscureText: _isPasswordNotVisible,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_passwordController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordController.clear();
                            });
                          },
                        ),
                      IconButton(
                        icon: Icon(
                          _isPasswordNotVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordNotVisible = !_isPasswordNotVisible;
                          });
                        },
                      ),
                    ],
                  ),
                  hintText: _isPasswordFocused
                      ? null
                      : Preferences.isHungarian
                          ? "Jelszó"
                          : "Password",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: _isPasswordFocused
                      ? Preferences.isHungarian
                          ? "Jelszó"
                          : "Password"
                      : null,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                  helperText: Preferences.isHungarian
                      ? "Min. 8 karakter, Max. 20 karakter,\n1 kisbetű, 1 nagybetű, és 1 szám."
                      : "Min. 8 characters, Max. 20 characters,\n1 lowercase, 1 uppercase, and 1 number.",
                  helperStyle: const TextStyle(
                    color: Colors.white,
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
                ),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: "password_confirm",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: Preferences.isHungarian
                          ? "A mezőnek meg kell egyeznie a jelszó mezővel!"
                          : "The field must match the password field!",
                      checkNullOrEmpty: false),
                  FormBuilderValidators.equal(_passwordController.text,
                      errorText: Preferences.isHungarian
                          ? "A jelszavak nem egyeznek meg!"
                          : "The passwords do not match!",
                      checkNullOrEmpty: false),
                ]),
                focusNode: _passwordConfirmFocusNode,
                controller: _passwordConfirmController,
                obscureText: _isPasswordConfirmNotVisible,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_passwordConfirmController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordConfirmController.clear();
                            });
                          },
                        ),
                      IconButton(
                        icon: Icon(
                          _isPasswordConfirmNotVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordConfirmNotVisible =
                                !_isPasswordConfirmNotVisible;
                          });
                        },
                      ),
                    ],
                  ),
                  labelText: _isPasswordConfirmFocused
                      ? Preferences.isHungarian
                          ? "Jelszó újra"
                          : "Confirm password"
                      : null,
                  hintText: _isPasswordConfirmFocused
                      ? null
                      : Preferences.isHungarian
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
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildUpdateButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isFormValid ? _handleSave : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            shadowColor: Colors.deepPurpleAccent,
            disabledBackgroundColor: Colors.grey[700],
            elevation: _isFormValid ? 5 : 0,
          ),
          child: Text(
            Preferences.isHungarian ? "Módosítások mentése" : "Save changes",
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountButton() {
    return TextButton.icon(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.redAccent,
      ),
      label: Text(
        Preferences.isHungarian ? "Fiók törlése" : "Delete Account",
        style: const TextStyle(
          color: Colors.redAccent,
        ),
      ),
      onPressed: _confirmAccountDeletion,
    );
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await File(file.path).readAsBytes();
      final base64 = base64Encode(bytes);
      final ext = file.path.split('.').last.toLowerCase();
      String prefix;
      switch (ext) {
        case "svg":
          prefix = "data:image/svg+xml;base64,";
          break;
        case "png":
          prefix = "data:image/png;base64,";
          break;
        case "jpg":
          prefix = "data:image/jpg;base64,";
          break;
        case "jpeg":
          prefix = "data:image/jpeg;base64,";
          break;
        default:
          prefix = "";
      }

      if (prefix.isEmpty) {
        ToastMessages.showToastMessages(
          "Nem támogatott fájlformátum!",
          0.2,
          Colors.red,
          Icons.image,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        return;
      }

      setState(() {
        _profilePicture = "$prefix$base64";
        _selectedImage = File(file.path);
      });

      _onAnyFieldChanged();
    }
  }

  Future<void> _updateProfilePicture() async {
    if (_profilePicture == null) return;
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/settings/update_profile_picture.php"),
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
          "profile_picture": _profilePicture,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        Preferences.setProfilePicture(_profilePicture!);
        ToastMessages.showToastMessages(
          "Profilkép frissítve!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      } else {
        throw Exception("Frissítés sikertelen.");
      }
    } catch (e) {
      log(e.toString());
      ToastMessages.showToastMessages(
        "Hiba a frissítés során!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    final username = _formKey.currentState!.fields["username"]?.value;
    final email = _formKey.currentState!.fields["email"]?.value;
    final password = _formKey.currentState!.fields["password"]?.value;

    // TODO: implementáld az alábbiakhoz szükséges backend endpointokat
    log("✏️ Mentésre küldve:\nFelhasználónév: $username\nEmail: $email\nJelszó: $password");
  }

  Future<void> _confirmAccountDeletion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          Preferences.isHungarian
              ? "Biztosan törlöd a fiókodat?"
              : "Are you sure you want to delete your account?",
        ),
        content: Text(
          Preferences.isHungarian
              ? "Ez a művelet nem visszavonható!"
              : "This action cannot be undone.",
        ),
        actions: [
          TextButton(
            child: Text(Preferences.isHungarian ? "Mégse" : "Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text(
              Preferences.isHungarian ? "Törlés" : "Delete",
              style: const TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: delete_user.php endpoint
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Fiók törölve (demo)!"
            : "Account deleted (demo)!",
        0.2,
        Colors.orange,
        Icons.delete,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    }
  }
  //régik innentől -------------------------------------------------

  Widget _defaultAvatar() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 20),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[600],
        child: const Icon(Icons.person, size: 50, color: Colors.white),
      ),
    );
  }

  Widget _buildDivider(String title) {
    //ez a widget felépít egy elválasztót a kategóriák között
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//AccountSetting OSZTÁLY VÉGE ---------------------------------------------------------------------
