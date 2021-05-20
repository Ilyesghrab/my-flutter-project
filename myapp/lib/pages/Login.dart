import 'package:flutter/material.dart';
import 'package:myapp/Outils/rounded_button.dart';
import 'package:myapp/Scanner/scan.dart';
import 'package:myapp/WS/ConnexionWs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String user;
  String pass;
  final passwordcontroller = TextEditingController();
  final logincontroller = TextEditingController();
  final statuscontroller = TextEditingController();
  final GlobalKey<FormState> fkey = GlobalKey<FormState>();
  bool ci = true;
  @override
  void initState() {
    super.initState();
  }

  void visibility() {
    setState(() {
      ci = !ci;
    });
  }

  Widget textfield({@required String hintText}) {
    return Material(
      elevation: 7,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      enableSuggestions: true,
      controller: logincontroller,
      decoration: InputDecoration(
          labelText: 'Login',
          icon: Icon(Icons.person),
          hintStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none)),
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

  Widget _buildStatus() {
    return TextFormField(
      enableSuggestions: true,
      controller: statuscontroller,
      decoration: InputDecoration(
          labelText: 'status',
          icon: Icon(Icons.online_prediction),
          hintStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none)),
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

  Widget _buildPassword() {
    return TextFormField(
      obscureText: ci,
      controller: passwordcontroller,
      decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            fontWeight: FontWeight.normal,
          ),
          icon: Icon(Icons.lock),
          suffixIcon: InkWell(
            onTap: visibility,
            child: Icon(ci ? Icons.visibility_off : Icons.visibility),
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/wallpaper.PNG"),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 35,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.lightBlue[100], width: 3),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/jante.jpg")),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 400,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /* textfield(
                          hintText: 'Username:  Ilyes',
                        ),*/
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildStatus(),
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
                          width: MediaQuery.of(context).size.width * .6,
                          child: RoundedButton(
                            text: "LogIn",
                            fontSize: 20,
                            press: () async {
                              try {
                                if (!fkey.currentState.validate()) return;
                                //Requete a la base
                                fkey.currentState.save();
                                String login =
                                    logincontroller.value.text.trim();
                                String pwd = passwordcontroller.value.text;
                                String status =
                                    statuscontroller.value.text.trim();
                                var ws = ConnexionWs(
                                    "<cab:login>" +
                                        login +
                                        "</cab:login><cab:pw>" +
                                        pwd +
                                        "</cab:pw><cab:statut>" +
                                        status +
                                        "</cab:statut>",
                                    "Login");
                                SharedPreferences sprefs =
                                    await SharedPreferences.getInstance();
                                sprefs.setString("no", login);
                                ws.getUsers(context);
                              } on SocketException catch (_) {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0)),
                                          child: Stack(
                                            overflow: Overflow.visible,
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Container(
                                                height: 200,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Fermer',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  top: -20,
                                                  child: CircleAvatar(
                                                    radius: 35,
                                                    child: Icon(
                                                      Icons.signal_wifi_off,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                                  )),
                                            ],
                                          ));
                                    });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
