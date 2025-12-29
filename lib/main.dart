import 'package:flutter/material.dart';
import 'package:vibe2/Home/home.dart';

//import 'package:vibe2/splash.dart';
void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'DMSans', useMaterial3: false),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {'/splash': (context) => HomeScreen()},
    ),
  );
}
