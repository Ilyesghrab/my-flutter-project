import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/model/inventory_Header.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/pages/CategoriesPage.dart';
import 'package:http/http.dart' as http;
import 'package:ntlm/ntlm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class ConnexionWs {
  String config;
  String nomtable;
  ConnexionWs(this.config, this.nomtable);

//LOGIN*************************************************************************************

  Future<List<User>> signIn(BuildContext context) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    //String ip = sharedPrefs.getString('AdresseIp');
    //String port = sharedPrefs.getString('Port');
    //String ws = sharedPrefs.getString('WS');
    //String namespace = sharedPrefs.getString('NameSpace');
    String config = sharedPrefs.getString('config');
    String port = "7047";
    String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
    String ip = "192.168.1.8";
    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
            "<soapenv:Body>";

    envelope = envelope + "<cab:LogIn>" + config + "</cab:LogIn>";
    envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";
    try {
      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws + 'CAB');
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CAB:LogIn",

            //"authorization": basicAuth,
            //"Host": ip + ":" + port,
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");

      var storeDocument = xml.parse(response.body);
      var raw = storeDocument;
      var stat = raw.findAllElements('statut').first;
      print(stat.text);

      //var raw = XmlDocument.parse(response.body);
      //print(raw.toString());
      //var raw = parse;
      //var elements = raw.findElements('login');
      if ((stat == null) | (stat.toString() == '')) {
        Fluttertoast.showToast(
            msg: "login ou mot de passe incorrecte !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);

        return null;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoriesPage()),
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

//Liste Inventaire*************************************************************************************

  Future<List<InventoryH>> getAll() async {
    String port = "7047";
    String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
    //String namespace = "urn:microsoft-dynamics-schemas/codeunit/CAB";
    String ip = "192.168.1.8";
    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
            "<soapenv:Body>";
    envelope =
        envelope + "<cab:ExportInventory>" + config + "</cab:ExportInventory>";
    envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";
    try {
      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws + 'CAB');
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction":
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportInventory",

            //"authorization": basicAuth,
            //"Host": ip + ":" + port,
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "probleme de connexion !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }
}
