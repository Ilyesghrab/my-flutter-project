import 'dart:io';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Outils/rounded_button.dart';
import 'package:myapp/Views/pages/Login.dart';
import 'package:myapp/Sidebar/bloc.navigation_bloc/navigation_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget with NavigationStates {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCodeResult = "Not Yet Scanned";
  String codeSanner;
  String login = "login";
  String statut = "status";
  String username = "username";
  String port = "Port";
  String webserv = "Webserv";
  String ip = "Ip";
  String domaine = "Domaine";
  String workstation = "Workstation";
  String usernamentlm = "UsernameNTLM";

  Future<String> getlog() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _address = sp.getString("Login");

    return _address;
  }

  Future<String> getstat() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _ns = sp.getString("Statut");
    return _ns;
  }

  Future<String> getusername() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _ins = sp.getString("Username");
    return _ins;
  }

  Future<String> getport() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String p = sp.getString("Port");
    return p;
  }

  Future<String> getwebserv() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String w = sp.getString("Webserv");
    return w;
  }

  Future<String> getIp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String i = sp.getString("Ip");
    return i;
  }

  Future<String> getdomaine() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String id = sp.getString("Domaine");
    return id;
  }

  Future<String> getworkstation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String iw = sp.getString("Workstation");
    return iw;
  }

  Future<String> getusernameNtlm() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String iu = sp.getString("UsernameNTLM");
    return iu;
  }

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
              /* FloatingActionButton.extended(
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
                  label: Text("Home")),*/
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
                    width: MediaQuery.of(context).size.width * .4,
                    child: RoundedButton(
                        text: "Log IN",
                        fontSize: 18,
                        press: () async {
                          List<String> fh;
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          String codeSanner =
                              await BarcodeScanner.scan(); //barcode scnner
                          setState(() {
                            this.codeSanner =
                                codeSanner == "-1" ? "login" : codeSanner;
                            fh = codeSanner.split("/");
                            login = fh[0];
                            statut = fh[1];
                            username = fh[2];
                            port = fh[3];
                            webserv = fh[4];
                            ip = fh[5];
                            domaine = fh[6];
                            workstation = fh[7];
                            usernamentlm = fh[8];
                            sp.setString("Login", login);
                            sp.setString("Statut", statut);
                            sp.setString("Username", username);
                            sp.setString("Port", port);
                            sp.setString("Webserv", webserv);
                            sp.setString("Ip", ip);
                            sp.setString("Domaine", domaine);
                            sp.setString("Workstation", workstation);
                            sp.setString("UsernameNTLM", usernamentlm);
                            // qrCodeResult = codeSanner;
                            print(sp.toString());
                          });
                          return {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            )
                          };
                        }),
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
