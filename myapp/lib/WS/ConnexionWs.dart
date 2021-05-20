import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class ConnexionWs {
  String config;
  String nomtable;
  ConnexionWs(this.config, this.nomtable);
  Future<List<User>> getUsers(BuildContext context) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String ip = sharedPrefs.getString('AdresseIp');
    //String port = sharedPrefs.getString('Port');
    // String ws = sharedPrefs.getString('WS');
    // String namespace = sharedPrefs.getString('NameSpace');
    String no = sharedPrefs.getString('no');
    String port = "7047";
    String ws = "CAB";
    String namespace = "urn:microsoft-dynamics-schemas/codeunit/CAB";

    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\">";

    //"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope = envelope +
        "<LogIn xmlns=\"" +
        namespace +
        "\"><login>" +
        no +
        "</login></LogIn>";
    envelope = envelope + " </soap:Body> </soap:Envelope>";

    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/LogIn",
            "Host": ip + ":" + port,
          },
          body: envelope);

      var raw = xml.parse(response.body);
      // Partie conditionnelle //
      // var elements = raw.findAllElements('MyTeam');

      /*return elements.map((element) {
      return User(element.findElements("SearchName").first.text,
          element.findElements("No").first.text);
    }).toList();*/
      var elements = raw.findAllElements('SearchName');
      if (elements.isEmpty) {
        Fluttertoast.showToast(
            msg: "login ou mot de passe incorrecte !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);

        return null;
      } //
      else {
        Navigator.pushReplacementNamed(context, "/CategoriesPage",
            arguments: {"no": no});
      }
    } catch (ex) {
      Fluttertoast.showToast(
          msg: "Problème de connection !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }
}
