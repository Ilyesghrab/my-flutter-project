import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/Outils/FadeAnimation.dart';
import 'package:myapp/Outils/rounded_button.dart';
import 'package:myapp/WS/InventaireWs.dart';
import 'package:myapp/model/media_source.dart';
import 'package:myapp/pages/HomePage.dart';
import 'package:myapp/pages/source_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String user;
  String pass;
  String codeSanner;
  final passwordcontroller = TextEditingController();
  final logincontroller = TextEditingController();
  final statuscontroller = TextEditingController();
  final GlobalKey<FormState> fkey = GlobalKey<FormState>();
  bool ci = true;
  String login = "login";
  String statut = "status";
  String username = "username";
  File fileMedia;
  MediaSource source;

  //Scan**************
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

  @override
  void initState() {
    super.initState();
    getlog().then(updateLog);
    getstat().then(updateStat);
    getusername().then(updatUser);
    super.initState();
  }

  void updateLog(String _add) {
    setState(() {
      this.login = _add;
    });
  }

  void updateStat(String _add) {
    setState(() {
      this.statut = _add;
    });
  }

  void updatUser(String _add) {
    setState(() {
      this.username = _add;
    });
  }

  //scan******

  void visibility() {
    setState(() {
      ci = !ci;
    });
  }

  Widget textfield({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            Icons.person,
            color: Colors.lightBlue[300],
          ),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      obscureText: ci,
      controller: passwordcontroller,
      decoration: InputDecoration(
          hintText: 'Password',
          labelStyle: TextStyle(color: Colors.grey),
          icon: Icon(
            Icons.lock,
            color: Colors.lightBlue[300],
          ),
          suffixIcon: InkWell(
            onTap: visibility,
            child: Icon(
              ci ? Icons.visibility_off : Icons.visibility,
              color: Colors.lightBlue[300],
            ),
          ),
          //fillColor: Colors.grey[50],
          // filled: true,
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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.lightBlue[300], Colors.white, Colors.white])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(
                          1,
                          Text(
                            "Connexion",
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.3,
                          Text(
                            "Parameter",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ],
                  ),
                ),
                FadeAnimation(
                  1.3,
                  GestureDetector(
                    onTap: () => capture(MediaSource.image),
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 3.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: fileMedia == null
                              ? AssetImage("assets/images/Capture1.PNG")
                              : FileImage(File(fileMedia.path)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/wallpaper.PNG")),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        FadeAnimation(
                            1.4,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200],
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: textfield(
                                          hintText: 'Login:   $login')),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: textfield(
                                          hintText: 'Statut:   $statut')),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildPassword()),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 50,
                        ),
                        FadeAnimation(
                            1.6,
                            InkWell(
                              onTap: () async {
                                String pwd = passwordcontroller.value.text;
                                String config = "<cab:login>" +
                                    login +
                                    "</cab:login><cab:pw>" +
                                    pwd +
                                    "</cab:pw><cab:statut>" +
                                    statut +
                                    "</cab:statut>" +
                                    "<cab:userName></cab:userName>";
                                var ws = InventaireWs(config, "user");
                                ws.signIn(context);
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.lightBlue[300]),
                                child: Center(
                                  child: Text("Log In",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future capture(MediaSource source) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SourcePage(),
        settings: RouteSettings(
          arguments: source,
        )));
    if (result == null) {
      AssetImage("assets/images/mavision.png");
    } else {
      setState(() {
        fileMedia = result;
      });
    }
  }
}
