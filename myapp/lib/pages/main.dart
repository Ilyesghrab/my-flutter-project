import 'package:flutter/material.dart';
import 'package:myapp/pages/CategoriesPage.dart';
import 'package:ntlm/ntlm.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));

  /*NTLMClient client = new NTLMClient(
    domain: "",
    workstation: "",
    username: "ilyes",
    password: "1234",
  );

  client
      .get(Uri.parse(
          "http://192.168.1.17:7047/BC140/WS/CRONUS%20France%20S.A./Codeunit/CAB"))
      .then((res) {
    print(res.body);
  });*/
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return CategoriesPage();
  }
}
