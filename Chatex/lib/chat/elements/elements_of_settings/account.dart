import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/logic/toast_message.dart';
import 'package:chatex/logic/preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _usernameController = TextEditingController();
  File? _selectedImage;
  String? _profilePicture; // Base64 formátumban tároljuk

  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text("Fiók beállításai"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePicture != null
                    ? MemoryImage(
                        base64Decode(_profilePicture!)) // Base64-ből kép
                    : const AssetImage("assets/logo.jpg")
                        as ImageProvider, // Alapértelmezett kép
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateProfilePicture,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: const Text("Profilkép módosítása"),
            ),
            const SizedBox(height: 20),
            FormBuilder(
              key: _formKey,
              child: FormBuilderTextField(
                name: "username",
                controller: _usernameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.minLength(3,
                      errorText: "Túl rövid! (min 3)"),
                  FormBuilderValidators.maxLength(20,
                      errorText: "Túl hosszú! (max 20)"),
                  FormBuilderValidators.required(errorText: "Nem lehet üres!"),
                ]),
                style: const TextStyle(color: Colors.white, fontSize: 20.0),
                decoration: const InputDecoration(
                  labelText: "Felhasználónév",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}
