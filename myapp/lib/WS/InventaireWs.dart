import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/Models/Inventaire/inventory_Entry.dart';
import 'package:myapp/Models/Inventaire/inventory_Header.dart';
import 'package:myapp/Models/Authentification/user.dart';
import 'package:myapp/Views/pages/CategoriesPage.dart';
import 'package:http/http.dart' as http;
import 'package:ntlm/ntlm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class InventaireWs {
  String config;
  String nomtable;
  InventaireWs(this.config, this.nomtable);
  String ip = "Ip";
  String webserv = "Webserv";
  String port = "Port";

//LOGIN*************************************************************************************

  Future<int> signIn(BuildContext context) async {
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      //String namespace = sharedPrefs.getString('NameSpace');
      //String config = sharedPrefs.getString('config');
      //String port = "7047";
      //String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      //String ip = "192.168.1.10";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";

      envelope = envelope + "<cab:LogIn>" + config + "</cab:LogIn>";
      envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse("http://$ip:$port/BC140/WS/$webserv/Codeunit/CAB");
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
      var usernameXML = storeDocument.findAllElements('userName').first;
      //  String st = stat.toString();
      // int sts = int.parse(st);
      print(stat.text);
      print(stat.toXmlString());
      // print(usernameXML.text);

      if ((stat == null) | (stat.text != '0')) {
        Fluttertoast.showToast(
            msg: "login ou mot de passe incorrecte ! ",
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
    List<InventoryH> getInv = [];
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportInventory>" +
          config +
          "</cab:ExportInventory>";
      envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse("http://$ip:$port/BC140/WS/$webserv/Codeunit/CAB");
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction":
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportInventory",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var StatusXML =
          storeDocument.findAllElements('vARJson').first.children.toString();
      String s = StatusXML;
      s = s.substring(1, s.length - 1);

      String ch = s;
      double l = 0;
      for (int i = 0; i < s.length; i++) {
        if (s[i] == ",") l++;
      }
      l = l + 1;
      l = (l / 2) as double;

      for (int j = 0; j < l; j++) {
        String Inventaire = ch.substring(0, ch.indexOf(",") + 1);
        Inventaire = Inventaire.substring(
            Inventaire.indexOf(":") + 1, Inventaire.length - 1);
        Inventaire = Inventaire.substring(1, Inventaire.length - 1);
        print("Inventaire=====>${Inventaire.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String Magasin = "";
        if (j < l - 1) {
          Magasin = ch.substring(0, ch.indexOf(",") + 1);
          Magasin =
              Magasin.substring(Magasin.indexOf(":") + 1, Magasin.length - 1);
          Magasin = Magasin.substring(1, Magasin.length - 1);
          ch = ch.substring(ch.indexOf(",") + 1);
        } else {
          Magasin = ch.substring(0, ch.indexOf("}") + 1);
          Magasin =
              Magasin.substring(Magasin.indexOf(":") + 1, Magasin.length - 1);
          Magasin = Magasin.substring(1, Magasin.length - 1);
          print("Magasin=====>${Magasin.toString()}");
        }
        InventoryH t = new InventoryH(Inventaire, Magasin, "");
        getInv.add(t);
      }
    } catch (Exception) {
      print(Exception.toString());
      /*print(ex);
      Fluttertoast.showToast(
          msg: "probleme de connexion !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);*/
    }
    return getInv;
  }

//Liste Comptage*************************************************************************************

  Future<List<InventoryH>> getCoun() async {
    List<InventoryH> getC = [];
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope =
          envelope + "<cab:ExportCounting>" + config + "</cab:ExportCounting>";
      envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse("http://$ip:$port/BC140/WS/$webserv/Codeunit/CAB");
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction":
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportInventory",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var StatusXML =
          storeDocument.findAllElements('vARJson').first.children.toString();
      String s = StatusXML;
      s = s.substring(1, s.length - 1);

      String ch = s;
      double l = 0;
      for (int i = 0; i < s.length; i++) {
        if (s[i] == ",") l++;
      }
      l = l + 1;
      l = (l / 3) as double;

      for (int j = 0; j < l; j++) {
        String Inventaire = ch.substring(0, ch.indexOf(",") + 1);
        Inventaire = Inventaire.substring(
            Inventaire.indexOf(":") + 1, Inventaire.length - 1);
        Inventaire = Inventaire.substring(1, Inventaire.length - 1);
        print("Inventaire=====>${Inventaire.toString()}");

        ch = ch.substring(ch.indexOf(",") + 1);

        String Magasin = ch.substring(0, ch.indexOf(",") + 1);
        Magasin =
            Magasin.substring(Magasin.indexOf(":") + 1, Magasin.length - 1);
        Magasin = Magasin.substring(1, Magasin.length - 1);
        print("Inventaire=====>${Magasin.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);
        String Comptage = "";
        if (j < l - 1) {
          Comptage = ch.substring(0, ch.indexOf(",") + 1);
          Comptage = Comptage.substring(
              Comptage.indexOf(":") + 1, Comptage.length - 1);
          Comptage = Comptage.substring(1, Comptage.length - 1);
          ch = ch.substring(ch.indexOf(",") + 1);
        } else {
          Comptage = ch.substring(0, ch.indexOf("}") + 1);
          Comptage = Comptage.substring(
              Comptage.indexOf(":") + 1, Comptage.length - 1);
          Comptage = Comptage.substring(1, Comptage.length - 1);
          print("Magasin=====>${Comptage.toString()}");
        }
        InventoryH t = new InventoryH(Inventaire, Magasin, Comptage);
        getC.add(t);
      }
    } catch (Exception) {
      print(Exception.toString());
      /*print(ex);
      Fluttertoast.showToast(
          msg: "probleme de connexion !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);*/
    }
    return getC;
  }

  //Insert Inventory*************************************************************************************

  Future<bool> InsertInv() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String ip = sharedPrefs.getString('Ip');
    String port = sharedPrefs.getString('Port');
    String webserv = sharedPrefs.getString('Webserv');
    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
            "<soapenv:Body>";
    envelope =
        envelope + "<cab:InsertInventory>" + config + "</cab:InsertInventory>";
    envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";
    try {
      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse("http://$ip:$port/BC140/WS/$webserv/Codeunit/CAB");
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction":
                "urn:microsoft-dynamics-schemas/codeunit/CAB:InsertInventory",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var Data = storeDocument.findAllElements('InsertInventory_Result');

      if (Data.length <= 0) {
        return false;
      }
      return true;
    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "probleme de connexion",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }
  //Insert Item*************************************************************************************

  Future<bool> InsertItem() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String ip = sharedPrefs.getString('Ip');
    String port = sharedPrefs.getString('Port');
    String webserv = sharedPrefs.getString('Webserv');
    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
            "<soapenv:Body>";
    envelope = envelope + "<cab:InsertItem>" + config + "</cab:InsertItem>";
    envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";
    try {
      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse("http://$ip:$port/BC140/WS/$webserv/Codeunit/CAB");
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction":
                "urn:microsoft-dynamics-schemas/codeunit/CAB:CAB:InsertItem",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var Data = storeDocument.findAllElements('InsertItem_Result');

      if (Data.length <= 0) {
        return false;
      }
      return true;
    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "probleme de connexion",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  //Export scanned item inventory*************************************************************************************

  Future<List<InventoryE>> getScannedArticle() async {
    List<InventoryE> getE = [];
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportScannedItemsInventory>" +
          config +
          "</cab:ExportScannedItemsInventory>";
      envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse("http://$ip:$port/BC140/WS/$webserv/Codeunit/CAB");
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction":
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportScannedItemsInventory",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var StatusXML = storeDocument.findAllElements('vARJson').first;
      var jsonData = StatusXML.text;
      print("jsonData ==> $jsonData");

      String dataStr = StatusXML.text;
      String ref;
      String des;
      String emplacement;
      String qte;
      //String img;
      //print("dataStr ==> $dataStr");
      if (dataStr == "{}") {
        dataStr = null;
      }
      while ((dataStr != null)) {
        ref = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("ref==> $ref");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        des = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("des==> $des");

        emplacement = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("emplacement==> $emplacement");

        qte = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("qte==> $qte");

        InventoryE t = new InventoryE(ref, des, emplacement, qte);
        getE.add(t);
      }
    } catch (Exception) {
      print(Exception.toString());
      // print(ex);
      /*Fluttertoast.showToast(
          msg: "probleme de connexion !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);*/
    }
    return getE;
  }

//Export scanned item inventory total*************************************************************************************

  Future<List<InventoryE>> getScannedCummul() async {
    List<InventoryE> getCummul = [];
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportScannedItemsTotal>" +
          config +
          "</cab:ExportScannedItemsTotal>";
      envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse("http://$ip:$port/BC140/WS/$webserv/Codeunit/CAB");
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction":
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportScannedItemsTotal",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var StatusXML = storeDocument.findAllElements('vARJson').first;
      var jsonData = StatusXML.text;
      print("jsonData ==> $jsonData");

      String dataStr = StatusXML.text;
      String ref;
      String des;
      String emplacement;
      String qte;
      //String img;
      //print("dataStr ==> $dataStr");
      if (dataStr == "{}") {
        dataStr = null;
      }
      while ((dataStr != null)) {
        ref = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("ref==> $ref");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        des = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("des==> $des");

        emplacement = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("emplacement==> $emplacement");

        qte = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("qte==> $qte");

        InventoryE t = new InventoryE(ref, des, emplacement, qte);
        getCummul.add(t);
      }
    } catch (Exception) {
      print(Exception.toString());
      // print(ex);
      /*Fluttertoast.showToast(
          msg: "probleme de connexion !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);*/
    }
    return getCummul;
  }

  //FindItem inventory*************************************************************************************
  Future<InventoryE> getItemInventory() async {
    InventoryE article;
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:FindItemInventory>" +
          config +
          "</cab:FindItemInventory>";
      envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

      NTLMClient client = NTLMClient(
        domain: "",
        workstation: "DESKTOP-44HHODU",
        username: "ilyes",
        password: "1234",
      );
      var url = Uri.parse("http://$ip:$port/BC140/WS/$webserv/Codeunit/CAB");
      print(url);
      print(envelope);
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction":
                "urn:microsoft-dynamics-schemas/codeunit/CAB:FindItemInventory",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);
      print(storeDocument);
      String qte = storeDocument.findAllElements('quantity').first.text;
      print("QTE ==> $qte");

      String reference = storeDocument.findAllElements('itemNo').first.text;
      print("REFERENCE ==> $reference");
      String designation =
          storeDocument.findAllElements('designation').first.text;
      print("designation ==> $designation");

      article = InventoryE(reference, designation, "", qte);
    } catch (Exception) {
      print(Exception.toString());
      return InventoryE("", "", "-1", "");
    }
    return article;
  }
}
