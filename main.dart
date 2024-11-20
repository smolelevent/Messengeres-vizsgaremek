import 'package:flutter/material.dart';
import 'package:world_time_kl/pages/home.dart';
import 'package:world_time_kl/pages/loading.dart';
import 'package:world_time_kl/pages/choose_location.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/", //default route when loaded
    routes: {
      "/": (context) => Loading(), //default base directory
      "/home": (context) => Home(),
      "/location": (context) => ChooseLocation(),
    },
  ));
}
