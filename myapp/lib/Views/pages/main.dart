import 'package:flutter/material.dart';
import 'package:myapp/Views/pages/CategoriesPage.dart';
import 'package:myapp/Views/pages/HomePage.dart';
import 'package:myapp/Views/pages/Login.dart';
import 'package:ntlm/ntlm.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
