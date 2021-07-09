import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/Models/Livraison/loading.dart';
import 'package:myapp/Views/List/dropDownReclass.dart';
import 'package:myapp/Models/PreparationCommande/salesOrder.dart';

import 'package:http/http.dart' as http;
import 'package:myapp/Models/PreparationCommande/sales_Line.dart';
import 'package:ntlm/ntlm.dart';
import 'package:xml/xml.dart' as xml;

class LivraisonWs {
  String config;
  String nomtable;
  LivraisonWs(this.config, this.nomtable);

  //Liste details chargement*************************************************************************************

  Future<List<Loading>> getAllCh() async {
    List<Loading> getdetails = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.10";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportLoadingDetails>" +
          config +
          "</cab:ExportLoadingDetails>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportLoadingDetails",
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
      l = (l / 8) as double;

      for (int j = 0; j < l; j++) {
        String numBL = ch.substring(0, ch.indexOf(",") + 1);
        numBL = numBL.substring(numBL.indexOf(":") + 1, numBL.length - 1);
        numBL = numBL.substring(1, numBL.length - 1);
        print("numBL=====>${numBL.toString()}");

        ch = ch.substring(ch.indexOf(",") + 1);

        String numcom = ch.substring(0, ch.indexOf(",") + 1);
        numcom = numcom.substring(numcom.indexOf(":") + 1, numcom.length - 1);
        numcom = numcom.substring(1, numcom.length - 1);
        print("numcom=====>${numcom.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String codeClient = ch.substring(0, ch.indexOf(",") + 1);
        codeClient = codeClient.substring(
            codeClient.indexOf(":") + 1, codeClient.length - 1);
        codeClient = codeClient.substring(1, codeClient.length - 1);
        print("codeClient=====>${codeClient.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String nomClient = ch.substring(0, ch.indexOf(",") + 1);
        nomClient = nomClient.substring(
            nomClient.indexOf(":") + 1, nomClient.length - 1);
        nomClient = nomClient.substring(1, nomClient.length - 1);
        print("nomClient=====>${nomClient.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String adresse = ch.substring(0, ch.indexOf(",") + 1);
        adresse =
            adresse.substring(adresse.indexOf(":") + 1, adresse.length - 1);
        adresse = adresse.substring(1, adresse.length - 1);
        print("adresse=====>${adresse.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String dateBl = ch.substring(0, ch.indexOf(",") + 1);
        dateBl = dateBl.substring(dateBl.indexOf(":") + 1, dateBl.length - 1);
        dateBl = dateBl.substring(1, dateBl.length - 1);
        print("dateBl=====>${dateBl.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String mHT = ch.substring(0, ch.indexOf(",") + 1);
        mHT = mHT.substring(mHT.indexOf(":") + 1, mHT.length - 1);
        mHT = mHT.substring(1, mHT.length - 1);
        print("mHT=====>${mHT.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String mTTC = "";
        if (j < l - 1) {
          mTTC = ch.substring(0, ch.indexOf(",") + 1);
          mTTC = mTTC.substring(mTTC.indexOf(":") + 1, mTTC.length - 1);
          mTTC = mTTC.substring(1, mTTC.length - 1);
          ch = ch.substring(ch.indexOf(",") + 1);
        } else {
          mTTC = ch.substring(0, ch.indexOf("}") + 1);
          mTTC = mTTC.substring(mTTC.indexOf(":") + 1, mTTC.length - 1);
          mTTC = mTTC.substring(1, mTTC.length - 1);
          print("mTTC=====>${mTTC.toString()}");
        }

        /*var Data = storeDocument.findAllElements('vARJson').first;

      String dataStr = Data.text;
      String numBL;
      String numcom;
      String codeClient;
      String nomClient;
      String adresse;
      String dateBl;
      String mHT;
      String mTTC;
      if (dataStr == "{}") {
        dataStr = null;
      }
      while (dataStr != null) {
        numBL = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("numBL==> $numBL");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        numcom = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("numcom==> $numcom");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        codeClient = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("codeClient==> $codeClient");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        nomClient = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("nomClient==> $nomClient");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        adresse = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("adresse==> $adresse");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        dateBl = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("dateBl==> $dateBl");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        mHT = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("mHT==> $mHT");

        mTTC = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("mTTC==> $mTTC");*/

        Loading c = Loading(
            numBL, numcom, codeClient, nomClient, adresse, dateBl, mHT, mTTC);
        getdetails.add(c);
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
    return getdetails;
  }

  //Insert article Preparation*************************************************************************************

  Future<String> InsertPrep() async {
    List<SalesL> articles = [];
    var storeDocument;
    String port = "7047";
    String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
    String ip = "192.168.1.10";
    var envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
            "<soapenv:Body>";
    envelope = envelope +
        "<cab:InsertSalesLine_DetailPreparation>" +
        config +
        "</cab:InsertSalesLine_DetailPreparation>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:InsertSalesLine_DetailPreparation",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

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

        if (dataStr.indexOf("\",") == -1) // Last
        {
          qte_prepare = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\"}"));
          dataStr = null;
        } else {
          qte_prepare = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
          dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        }
        print("qte_prepare==> $qte_prepare");

        SalesL a = SalesL(reference, designation, qt, qte_prepare);
        articles.add(a);
      }
    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "Vous ne pouvez pas expédier plus de quantité !!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    }
  }

  //Export Sales line preparation*************************************************************************************

  Future<List<SalesL>> getExportLinePrep() async {
    List<SalesL> getLineP = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.10";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportSalesLinePreparation>" +
          config +
          "</cab:ExportSalesLinePreparation>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportSalesLinePreparation",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var Data = storeDocument.findAllElements('vARJson').first;

      //print("jsonData ==> $jsonData");

      String dataStr = Data.text;
      String reference;
      String designation;
      String qte;
      String qte_prepare;

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
          qte_prepare = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\"}"));
          dataStr = null;
        } else {
          qte_prepare = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
          dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        }
        print("qte_prepare==> ..");

        SalesL a = SalesL(reference, designation, qte, qte_prepare);
        getLineP.add(a);
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
    return getLineP;
  }

//Export scanned item inventory total*************************************************************************************

  Future<SalesL> getScannedSales(BuildContext context) async {
    SalesL sales;
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.10";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope =
          envelope + "<cab:FindItemSales>" + config + "</cab:FindItemSales>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:FindItemSales",
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

      if (qte == "-1") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Option',
          desc: 'Article not found !! Do you want to add it ?',
          btnCancelText: "No",
          btnCancelColor: Colors.red,
          btnCancelIcon: Icons.outbond,
          btnCancelOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DropDownRec()),
            );
          },
          btnOkText: "Ok",
          btnOkColor: Colors.green,
          btnOkIcon: Icons.transfer_within_a_station_outlined,
          btnOkOnPress: () {
            return null;
          },
        )..show();
      } else if (qte == "0") {
        Fluttertoast.showToast(
            msg: "Article not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);

        return null;
      }

      String reference = storeDocument.findAllElements('itemNo').first.text;
      print("REFERENCE ==> $reference");
      String designation =
          storeDocument.findAllElements('designation').first.text;
      print("designation ==> $designation");

      sales = SalesL(reference, designation, qte, "");
    } catch (Exception) {
      print("Exception in Service getItemToAddDetails (Reclassement)");
      print(Exception.toString());
    }
    return sales;
  }

  //FindItem inventory*************************************************************************************

}
