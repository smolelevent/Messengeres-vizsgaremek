import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';
import 'dart:io';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _usernameController = TextEditingController();
  File? _selectedImage;
  String? _profilePicture; // Base64 formátumban tároljuk
  bool _isUsernameFocused = false;
  final FocusNode _usernameFocusNode = FocusNode();

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

  // 🔹 Felhasználói adatok betöltése a Preferences-ből
  Future<void> _loadUserData() async {
    String? username = Preferences.getUsername();
    String? profilePic = Preferences.getProfilePicture();

    setState(() {
      _usernameController.text = username;
      _profilePicture = profilePic; // Base64 stringet tárolunk
    });
  }

  // 📸 Profilkép kiválasztása
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Kép konvertálása Base64 formátumba
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        _selectedImage = imageFile;
        _profilePicture = base64Image;
      });
    }
  }

  // 🔄 Profilkép frissítése (Preferences + szerver)
  Future<void> _updateProfilePicture() async {
    if (_selectedImage == null) {
      ToastMessages.showToastMessages(
          "Nincs kiválasztott kép!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
      return;
    }

    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/settings/update_profile_picture.php"),
      body: jsonEncode({"profile_picture": _profilePicture}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      ToastMessages.showToastMessages("Profilkép frissítve!", 0.2, Colors.green,
          Icons.check, Colors.black, const Duration(seconds: 2));

      // ✅ Preferences-ben is eltároljuk a módosított profilképet
      await Preferences.setProfilePicture(_profilePicture!);
    } else {
      ToastMessages.showToastMessages(
          "Hiba történt a frissítés során!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
    }
  }

  // ✏️ Felhasználónév módosítása
  Future<void> _updateUsername() async {
    if (_usernameController.text.isEmpty) {
      ToastMessages.showToastMessages(
          "A név nem lehet üres!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
      return;
    }

    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/settings/update_username.php"),
      body: jsonEncode({"username": _usernameController.text}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      ToastMessages.showToastMessages("Felhasználónév frissítve!", 0.2,
          Colors.green, Icons.check, Colors.black, const Duration(seconds: 2));

      // ✅ Preferences-ben is frissítjük
      await Preferences.setUsername(_usernameController.text);
    } else {
      ToastMessages.showToastMessages(
          "Hiba történt a frissítés során!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2));
    }
  }

  _buildAppbar() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: _buildAppbar(),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePicture != null
                      ? MemoryImage(//nem tudja megjeleníteni az idézőjel miatt
                          base64Decode(_profilePicture!)) // Base64-ből kép
                      : const AssetImage("assets/logo.jpg")
                          as ImageProvider, // Alapértelmezett kép
                ),
              ),
              ElevatedButton(
                onPressed: _updateProfilePicture,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text("Profilkép módosítása"),
              ),
            ],
          ),
          _usernameWidget(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateUsername,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
            ),
            child: const Text("Felhasználónév módosítása"),
          ),
        ],
      ),
    );
  }
}
