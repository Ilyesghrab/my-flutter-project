import 'dart:io';

import 'package:flutter/material.dart';

import 'package:myapp/Outils/FadeAnimation.dart';

import 'package:myapp/Models/media_source.dart';
import 'package:myapp/Views/pages/CategoriesPage.dart';
import 'package:myapp/Views/pages/source_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Param extends StatefulWidget {
  @override
  ParamState createState() => ParamState();
}

class ParamState extends State<Param> {
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
  File fileMedia;
  MediaSource source;

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
  void initState() {
    super.initState();
    getlog().then(updateLog);
    getstat().then(updateStat);
    getusername().then(updatUser);
    getport().then(updatePort);
    getwebserv().then(updateWebserv);
    getIp().then(updateIp);
    getdomaine().then(updatedomaine);
    getworkstation().then(updateworkstation);
    getusernameNtlm().then(updateusernamentlm);
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

  void updatePort(String _add) {
    setState(() {
      this.port = _add;
    });
  }

  void updateWebserv(String _add) {
    setState(() {
      this.webserv = _add;
    });
  }

  void updateIp(String _add) {
    setState(() {
      this.ip = _add;
    });
  }

  void updatedomaine(String _add) {
    setState(() {
      this.domaine = _add;
    });
  }

  void updateworkstation(String _add) {
    setState(() {
      this.workstation = _add;
    });
  }

  void updateusernamentlm(String _add) {
    setState(() {
      this.usernamentlm = _add;
    });
  }

  String bc;
  String ds;
  String cn;

  Widget textfieldIP({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.desktop_windows_outlined),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  Widget textfieldPort({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.portable_wifi_off),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  Widget textfieldWeb({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.web_asset),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  Widget textfieldLog({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.person),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  Widget textfieldPass({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.lock_open),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  Widget textfieldDom({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.account_balance_wallet_outlined),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  Widget textfieldWork({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.computer),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  Widget textfieldUserntlm({@required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.person_search_outlined),
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.lightBlue[300],
          Colors.lightBlue[200],
          Colors.lightBlue[100]
        ])),
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
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
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
                              ? AssetImage("assets/images/mavision.png")
                              : FileImage(File(fileMedia.path)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Serveur Param",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
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
                                      child: textfieldIP(
                                          hintText: 'AdresseIp:   $ip')),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: textfieldPort(
                                          hintText: 'Port:   $port')),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: textfieldWeb(
                                          hintText: 'Webservice:   $webserv')),
                                ],
                              ),
                            )),
                        SizedBox(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Autentication NTLM",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
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
                                      child: textfieldDom(
                                          hintText: 'Domain NTLM:   $domaine')),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: textfieldWork(
                                          hintText:
                                              'Workstation NTLM:   $workstation')),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: textfieldUserntlm(
                                          hintText:
                                              'Username NTLM:   $usernamentlm')),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: textfieldPass(
                                          hintText:
                                              'Password NTLM:   *********')),
                                ],
                              ),
                            )),
                        SizedBox(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "User logIn",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
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
                                      child: textfieldLog(
                                          hintText: 'login:   $login')),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: textfieldPass(
                                          hintText: 'Password:   ******')),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 50,
                        ),
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
