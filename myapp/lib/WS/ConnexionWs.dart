import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/pages/myaccountpage.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class ConnexionWs {
  String config;
  String nomtable;
  ConnexionWs(this.config, this.nomtable);
  Future<List<User>> signIn(BuildContext context) async {
    //SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    //String ip = sharedPrefs.getString('AdresseIp');
    //String port = sharedPrefs.getString('Port');
    //String ws = sharedPrefs.getString('WS');
    //String namespace = sharedPrefs.getString('NameSpace');
    //String no = sharedPrefs.getString('no');
    String port = "7047";
    String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
    String namespace = "urn:microsoft-dynamics-schemas/codeunit/CAB";
    String ip = "desktop-44hhodu";
    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
            "<soapenv:Body>";

    envelope = envelope + "<cab:LogIn>" + config + "</cab:LogIn>";
    envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws + 'CAB');
      print(url);
      print(envelope);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CAB:LogIn",
            //"Host": ip + ":" + port,
          },
          body: envelope);

      var parse = xml.parse(response.body);
      var raw = parse;
      var elements = raw.findAllElements('login');
      if (elements.isEmpty) {
        Fluttertoast.showToast(
            msg: "login ou mot de passe incorrecte !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);

        return null;
      } //
      else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyAccountsPage()),
        );
      }
    } catch (ex) {
      print("ex: $ex");
      Fluttertoast.showToast(
          msg: "Problème de connection !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }
}
