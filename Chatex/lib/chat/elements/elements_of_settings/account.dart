//import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:developer';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _isUsernameFocused = false;

  File? _selectedImage;
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _usernameFocusNode.addListener(() {
      setState(() {
        _isUsernameFocused = _usernameFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    //String? username = Preferences.getUsername();
    final String? profilePic = Preferences.getProfilePicture();

    setState(() {
      //_usernameController.text = username;
      _profilePicture = profilePic; // Base64 stringet tárolunk
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

  Future<void> _updateProfilePicture() async {
    if (_selectedImage == null) {
      ToastMessages.showToastMessages(
        "Nincs kiválasztott kép!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
    } else {
      try {
        log(_profilePicture.toString());
        final response = await http.post(
          Uri.parse(
              "http://10.0.2.2/ChatexProject/chatex_phps/settings/update_profile_picture.php"),
          body: jsonEncode({
            "user_id": Preferences.getUserId(),
            "profile_picture": _profilePicture,
          }),
          headers: {"Content-Type": "application/json"},
        );
        final responseData = json.decode(response.body);
        log(responseData.toString());
        if (responseData["status"] == "success") {
          ToastMessages.showToastMessages(
            "Profilkép frissítve!",
            0.2,
            Colors.green,
            Icons.check,
            Colors.black,
            const Duration(seconds: 2),
            context,
          );

          await Preferences.setProfilePicture(_profilePicture!);
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
          "Kapcsolati hiba!",
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
          "Kapcsolati hiba!",
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

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.getPreferredLanguage() == "Magyar"
            ? "Fiók adatok"
            : "Account details",
      ),
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 5,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildProfilePicture() {
    if (_profilePicture == null || _profilePicture!.isEmpty) {
      return _defaultAvatar();
    }

    try {
      if (_profilePicture!.startsWith("data:image/svg+xml;base64,")) {
        final svgBytes = base64Decode(_profilePicture!.split(",")[1]);
        return Padding(
          padding: const EdgeInsets.only(right: 30),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.transparent,
            child: SvgPicture.memory(svgBytes, width: 120, height: 120),
          ),
        );
      } else if (_profilePicture!.startsWith("data:image/png;base64,") ||
          _profilePicture!.startsWith("data:image/jpeg;base64,") ||
          _profilePicture!.startsWith("data:image/jpg;base64,")) {
        final imageAsBytes = base64Decode(_profilePicture!.split(",")[1]);
        return Padding(
          padding: const EdgeInsets.only(right: 30),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: MemoryImage(imageAsBytes),
          ),
        );
      } else {
        log("Ismeretlen MIME-típus a profilképnél: $_profilePicture");
        return _defaultAvatar();
      }
    } catch (e) {
      log("Hiba a kép dekódolásakor: $e");
      return _defaultAvatar();
    }
  }

  Widget _defaultAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[600],
        child: const Icon(Icons.person, size: 50, color: Colors.white),
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
            errorText: Preferences.getPreferredLanguage() == "Magyar"
                ? "A felhasználónév túl rövid! (min 3)"
                : "The username is too short! (min 3)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.maxLength(
            20,
            errorText: Preferences.getPreferredLanguage() == "Magyar"
                ? "A felhasználónév túl hosszú! (max 20)"
                : "The username is too long! (max 20)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.required(
              errorText: Preferences.getPreferredLanguage() == "Magyar"
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
              : Preferences.getPreferredLanguage() == "Magyar"
                  ? "Felhasználónév"
                  : "Username",
          labelText: _isUsernameFocused
              ? Preferences.getPreferredLanguage() == "Magyar"
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

  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.deepPurpleAccent, thickness: 2);
  }

  Widget _buildUserDataText(
      String text, double left, double top, double right, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(top: top, left: left, right: right),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: _buildAppbar(),
        body: Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              //kell az expanded widget mivel akkor scrollable lesz a scrollableben ami túl nagy hashSizehoz vezet
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryTitle("Fiók adatai:"),
                  _buildDivider(),
                  _buildUserDataText("Felhasználónév:", 10, 5, 10, 20),
                  _buildUserDataText(
                      Preferences.getUsername().toString(), 20, 5, 10, 18),
                  _buildUserDataText("Email cím:", 10, 5, 10, 20),
                  _buildUserDataText(
                      Preferences.getEmail().toString(), 20, 5, 10, 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserDataText("Profil kép:", 10, 10, 10,
                          20), //TODO: képre kattintás
                      GestureDetector(
                        onTap: _pickProfilePicture,
                        child: _buildProfilePicture(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildCategoryTitle("Fiók adatainak módosítása:"),
                  _buildDivider(),
                  _buildUserDataText(
                      "Felhasználónév módosítása:", 10, 5, 10, 20),
                  _usernameWidget(),
                  ElevatedButton(
                    onPressed: _updateUsername,
                    child: const Text("Felhasználónév módosítása"),
                  ),
                  ElevatedButton(
                    onPressed: _updateProfilePicture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      disabledBackgroundColor: Colors.grey[700],
                      elevation: 5,
                    ),
                    child: const Text(
                      "Profilkép módosítása",
                      style: TextStyle(
                        color: Colors.white,
                        //fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
