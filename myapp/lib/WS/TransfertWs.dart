import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:myapp/Models/Transfert&Reclass/Transfert_Header.dart';
import 'package:myapp/Models/Inventaire/inventory_Entry.dart';
import 'package:myapp/Models/Inventaire/inventory_Header.dart';
import 'package:myapp/Models/Reception/purchase_Entry.dart';
import 'package:myapp/Models/Authentification/user.dart';
import 'package:myapp/Models/Transfert&Reclass/tranfer_Line.dart';
import 'package:myapp/Views/pages/CategoriesPage.dart';
import 'package:http/http.dart' as http;
import 'package:ntlm/ntlm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class TransfertWs {
  String config;
  String nomtable;
  TransfertWs(this.config, this.nomtable);
  String ip = "Ip";
  String webserv = "Webserv";
  String port = "Port";

  //Liste Transfert*************************************************************************************

  Future<List<TransfertH>> getAllT() async {
    List<TransfertH> getTrans = [];
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportTransfert>" +
          config +
          "</cab:ExportTransfert>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportTransfert",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var Data = storeDocument.findAllElements('vARJson').first;

      String dataStr = Data.text;
      String trans;
      String prov;
      String dest;
      String date;
      while (dataStr != null) {
        trans = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("trans==> $trans");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        prov = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("prov==> $prov");

        dest = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("dest==> $dest");

        if (dataStr.indexOf("\",") == -1) // Last
        {
          date = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\"}"));
          dataStr = null;
        } else {
          date = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
          dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        }
        print("date==> $date");

        TransfertH t = TransfertH(trans, prov, dest, date);
        getTrans.add(t);
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
    return getTrans;
  }

  //Get status*************************************************************************************

  Future<bool> getStatusTransfert() async {
    bool status;
    String recvd;
    String shipd;
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String ip = sharedPrefs.getString('Ip');
    String port = sharedPrefs.getString('Port');
    String webserv = sharedPrefs.getString('Webserv');
    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
            "<soapenv:Body>";
    envelope = envelope + "<cab:GetStatus>" + config + "</cab:GetStatus>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:GetStatus",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");

      var storeDocument = xml.parse(response.body);

      recvd = storeDocument.findAllElements('receive').first.text;

      shipd = storeDocument.findAllElements('shipped').first.text;
    } catch (Exception) {
      print("Exception in service getStatusTransfert");
      print(Exception.toString());
    }
    return status;
  }

  //Export Line transfert*************************************************************************************

  Future<List<TransferL>> getTransferLine() async {
    List<TransferL> getTline = [];
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportLineTransfert>" +
          config +
          "</cab:ExportLineTransfert>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportLineTransfert",
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
      String designation;
      String qte;
      String qte_prep;
      while (dataStr != null) {
        reference = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("reference==> $reference");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        designation = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("designation==> $designation");

        qte = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("qte==> $qte");

        if (dataStr.indexOf("\",") == -1) // Last
        {
          qte_prep = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\"}"));
          dataStr = null;
        } else {
          qte_prep = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
          dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        }
        print("qte_prep==> $qte_prep");

        TransferL a = TransferL(
          reference,
          designation,
          qte,
          qte_prep,
        );
        getTline.add(a);
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
    return getTline;
  }

  //FindItem Transfert*************************************************************************************

  Future<TransferL> getItemTransfert() async {
    TransferL article;
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportLineTransfert>" +
          config +
          "</cab:ExportLineTransfert>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportLineTransfert",
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

      print("qte ==> $qte");
      article = TransferL(reference, designation, qte, "");
    } catch (Exception) {
      print(Exception.toString());
      return TransferL("", "", "-1", "");
    }
    return article;
  }

//Insert line Transfert*************************************************************************************
  Future<String> insertArticleToTransfert() async {
    var storeDocument;
    List<TransferL> articles = List<TransferL>();
    try {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String ip = sharedPrefs.getString('Ip');
      String port = sharedPrefs.getString('Port');
      String webserv = sharedPrefs.getString('Webserv');
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:InsertLigneTransfert_DetailJson>" +
          config +
          "</cab:InsertLigneTransfert_DetailJson>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:InsertLigneTransfert_DetailJson",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      storeDocument = xml.parse(response.body);
      print(response.body);
      var Data = storeDocument.findAllElements('vARJson').first;

      if (Data.text == "{}") {
        return "false";
      }
      var jsonData = Data.text;
      print(Data.text);
      print("jsonData ==> $jsonData");
      //print("DATA ===>");

      String dataStr = Data.text;

      String reference;
      String designation;
      String qt;
      String qte_prepare;
      String EmpSource;
      String EmpDest;

      while (dataStr != null) {
        reference = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("reference==> $reference");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        designation = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("designation==> $designation");

        qt = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("qt==> $qt");

        qte_prepare = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("qte_prepare==> $qte_prepare");

        EmpSource = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("EmpSource==> $EmpSource");

        EmpDest = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("EmpDest==> $EmpDest");

        TransferL a = TransferL(reference, designation, qt, qte_prepare);
        articles.add(a);
      }
    } catch (Exception) {
      print(Exception.toString());
      Fluttertoast.showToast(
          msg: "Quantité(s) ajoutés avec succés",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    }
    return "true";
  }
}
