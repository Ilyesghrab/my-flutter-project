import 'dart:io';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Outils/rounded_button.dart';
import 'package:myapp/pages/CategoriesPage.dart';
import 'package:myapp/pages/Login.dart';
import 'package:myapp/Sidebar/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget with NavigationStates {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCodeResult = "Not Yet Scanned";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () => exit(0),
                tooltip: 'Close app',
                icon: Icon(Icons.close),
                label: Text("Exit"),
              ),
              FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CategoriesPage();
                        },
                      ),
                    );
                  },
                  backgroundColor: Colors.green,
                  icon: Icon(Icons.home),
                  label: Text("Home")),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  launch(('tel://28474761'));
                },
                icon: Icon(Icons.call),
                label: Text("help"),
                backgroundColor: Colors.red,
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Row(children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/sideImg.png'),
                    fit: BoxFit.cover)),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain)),
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline3,
                      children: [
                        TextSpan(
                          text: "Ma",
                        ),
                        TextSpan(
                          text: "Vision.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Connect to the application \nBy scanning the QRCode \nIn your Badge \n\nScan here",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .6,
                    child: RoundedButton(
                      text: "Open Scanner",
                      fontSize: 20,
                      press: () async {
                        String codeSanner =
                            await BarcodeScanner.scan(); //barcode scnner
                        setState(() {
                          qrCodeResult = codeSanner;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .6,
                    child: RoundedButton(
                      text: "LogIn",
                      fontSize: 20,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }

  Widget flatButton(String text, Widget widget) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white70,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: 3.0),
            borderRadius: BorderRadius.circular(20.0)),
      ),
      onPressed: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildWelcome() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Authentification',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      );
}
