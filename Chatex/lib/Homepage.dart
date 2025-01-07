import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatex/Auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }
  Widget _userUid() {
    return Text((user?.email ?? 'Felhasználó email'));
  }
  Widget _title() {
    return const Text('Chatex');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Kijelentkezés'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }

}