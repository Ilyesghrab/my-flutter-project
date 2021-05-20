import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project/web_service/connectWS.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:io';
import 'package:flutter_ip/flutter_ip.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  String user;
  String pass;
  IconData ic = Icons.visibility_off;
  bool ci = true;
  final passwordcontroller = TextEditingController();
  final logincontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void visibility() {
    setState(() {
      ci = !ci;
    });
  }

  Widget _buildPassword() {
    return TextFormField(
      obscureText: ci,
      controller: passwordcontroller,
      decoration: InputDecoration(
        labelText: 'Password',
        icon: Icon(Icons.lock),
        suffixIcon: InkWell(
          onTap: visibility,
          child: Icon(ci ? Icons.visibility_off : Icons.visibility),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (String value) {
        pass = value;
      },
    );
  }

  Widget _buildName() {
    return TextFormField(
      enableSuggestions: true,
      controller: logincontroller,
      decoration: InputDecoration(
        labelText: 'login',
        icon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        fillColor: cr1,
      ),
      maxLength: 16,
      validator: (String value) {
        if (value.isEmpty) {
          return 'login is Required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {
        user = value;
      },
    );
  }

  Color bg = HexColor("#D4F1F4");
  Color bg2 = HexColor("#75E6DA");
  Color bg3 = HexColor("#189AB4");
  Color bg4 = HexColor("#05445E");
  Color cr1 = HexColor("#BE3144");
  Color cr2 = HexColor("#3A4750");
  Color cr3 = HexColor("#303841");
  final GlobalKey<FormState> fkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(children: [
              Positioned(
                right: size.width * 0.05,
                top: size.height * 0.025,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                  child: InkWell(
                      child: Icon(Icons.settings,
                          color: Colors.white, size: size.width * 0.12),
                      onTap: () {
                        Navigator.pushNamed(context, "/scnm", arguments: {});
                      }),
                ),
              ),
              Column(
                children: [
                  /*Padding(
                    padding: EdgeInsets.fromLTRB(0, size.height * 0.06, 0, 0),
                    child: RichText(
                      text: TextSpan(
                          text: "HR",
                          style: TextStyle(
                            fontSize: 45,
                            color: bg4,
                            fontFamily: "Arvo",
                          ),
                          children: [
                            TextSpan(
                                text: "Vision",
                                style: TextStyle(fontSize: 35, color: bg3))
                          ]),
                    ),
                  ),*/
                  SizedBox(
                    height: size.height * 0.3,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, size.height * 0.19, 10, 0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70),
                        child: Form(
                          key: fkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildName(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildPassword(),
                              ),
                              SizedBox(
                                height: size.height * 0.07,
                              ),
                              ButtonTheme(
                                minWidth: size.width * 0.75,
                                height: size.height * 0.07,
                                child: RaisedButton.icon(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onPressed: () async {
                                    try {
                                      if (!fkey.currentState.validate()) return;
                                      //Requete a la base
                                      fkey.currentState.save();
                                      String login =
                                          logincontroller.value.text.trim();
                                      String pwd =
                                          passwordcontroller.value.text;
                                      var ws = ConnectWS(
                                          "<login>" +
                                              login +
                                              "</login><pwd>" +
                                              pwd +
                                              "</pwd>",
                                          "Login");
                                      SharedPreferences sprefs =
                                          await SharedPreferences.getInstance();
                                      sprefs.setString("no", login);
                                      String la = "1";
                                      sprefs.setString("la", la);
                                      ws.login(context);
                                    } on SocketException catch (_) {
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0)),
                                                child: Stack(
                                                  overflow: Overflow.visible,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  children: [
                                                    Container(
                                                      height: 200,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 70, 10, 10),
                                                        child: Column(
                                                          children: [
                                                            /* Text(
                                                                  'Alert !!',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: 20),
                                                                ),*/
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              'Connexion echouée',
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            RaisedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              color: bg4,
                                                              child: Text(
                                                                'Fermer',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: -20,
                                                        child: CircleAvatar(
                                                          backgroundColor: bg4,
                                                          radius: 35,
                                                          child: Icon(
                                                            Icons
                                                                .signal_wifi_off,
                                                            color: Colors.white,
                                                            size: 35,
                                                          ),
                                                        )),
                                                  ],
                                                ));
                                          });
                                    }

                                    /* var rawXmlResponse = response.body;
                                        print("response.body");
                                        print("DATAResult=" + response.body);*/
                                    /*} catch (e) {
                                        print(e);
                                      }*/
                                  },
                                  color: bg4,
                                  icon: Icon(
                                    Icons.login,
                                    color: bg,
                                  ),
                                  label: Text(
                                    "Connecter",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
