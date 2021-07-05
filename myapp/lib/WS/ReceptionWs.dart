import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/model/Purchase_Header.dart';
import 'package:myapp/model/inventory_Entry.dart';
import 'package:myapp/model/inventory_Header.dart';
import 'package:myapp/model/purchase_Entry.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/pages/CategoriesPage.dart';
import 'package:http/http.dart' as http;
import 'package:ntlm/ntlm.dart';
import 'package:xml/xml.dart' as xml;

class ReceptionWs {
  String config;
  String nomtable;
  ReceptionWs(this.config, this.nomtable);

  //Liste Inventaire*************************************************************************************

  Future<List<PurchaseH>> getAllP() async {
    List<PurchaseH> getPur = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.3";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportPurchaseOrder>" +
          config +
          "</cab:ExportPurchaseOrder>";
      envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportPurchaseOrder",
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
        String CommandeAchat = ch.substring(0, ch.indexOf(",") + 1);
        CommandeAchat = CommandeAchat.substring(
            CommandeAchat.indexOf(":") + 1, CommandeAchat.length - 1);
        CommandeAchat = CommandeAchat.substring(1, CommandeAchat.length - 1);
        print("CommandeAchat=====>${CommandeAchat.toString()}");

        ch = ch.substring(ch.indexOf(",") + 1);

        String Fournisseur = ch.substring(0, ch.indexOf(",") + 1);
        Fournisseur = Fournisseur.substring(
            Fournisseur.indexOf(":") + 1, Fournisseur.length - 1);
        Fournisseur = Fournisseur.substring(1, Fournisseur.length - 1);
        print("Fournisseur=====>${Fournisseur.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String Groupe = "";
        if (j < l - 1) {
          Groupe = ch.substring(0, ch.indexOf(",") + 1);
          Groupe = Groupe.substring(Groupe.indexOf(":") + 1, Groupe.length - 1);
          Groupe = Groupe.substring(1, Groupe.length - 1);
          ch = ch.substring(ch.indexOf(",") + 1);
        } else {
          Groupe = ch.substring(0, ch.indexOf("}") + 1);
          Groupe = Groupe.substring(Groupe.indexOf(":") + 1, Groupe.length - 1);
          Groupe = Groupe.substring(1, Groupe.length - 1);
          print("Groupe=====>${Groupe.toString()}");
        }
        PurchaseH t = new PurchaseH(CommandeAchat, Fournisseur, Groupe);
        getPur.add(t);
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
    return getPur;
  }

  //Insert Reception*************************************************************************************

  Future<bool> InsertReception() async {
    String port = "7047";
    String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
    String ip = "192.168.1.3";
    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
            "<soapenv:Body>";
    envelope =
        envelope + "<cab:InsertReception>" + config + "</cab:InsertReception>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:InsertReception",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var Data = storeDocument.findAllElements('InsertReception_Result');

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

  //Export scanned item purchase*************************************************************************************

  Future<List<PurchaseE>> getScannedCommand() async {
    List<PurchaseE> getPurE = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.3";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportScannedItemsPurchase>" +
          config +
          "</cab:ExportScannedItemsPurchase>";
      envelope = envelope + " </soapenv:Body> </soapenv:Envelope>";

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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportScannedItemsPurchase",
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
      String reference;
      String des;
      String barcode;
      String qte;
      if (dataStr == "{}") {
        dataStr = null;
      }
      while (dataStr != null) {
        reference = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("reference==> $reference");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        des = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("des==> $des");

        barcode = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("barcode==> $barcode");

        qte = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("qte==> $qte");

        PurchaseE a = PurchaseE(
          reference,
          des,
          barcode,
          qte,
        );
        getPurE.add(a);
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
    return getPurE;
  }

//Export scanned item inventory total*************************************************************************************

  Future<List<InventoryE>> getScannedCummul() async {
    List<InventoryE> getCummul = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.3";
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
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws + 'CAB');
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

}
