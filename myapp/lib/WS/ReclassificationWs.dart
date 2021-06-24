import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/model/feuille_Line.dart';

import 'package:myapp/model/inventory_Entry.dart';
import 'package:myapp/model/magasin_Rec.dart';

import 'package:myapp/model/model_reclass.dart';
import 'package:myapp/model/nom_reclass.dart';
import 'package:myapp/model/purchase_Entry.dart';

import 'package:http/http.dart' as http;
import 'package:ntlm/ntlm.dart';
import 'package:xml/xml.dart' as xml;

class ReclassificationWs {
  String config;
  String nomtable;
  ReclassificationWs(this.config, this.nomtable);

  //Liste Modéle*************************************************************************************

  Future<List<ModelR>> getAllM() async {
    List<ModelR> getModel = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.7";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope =
          envelope + "<cab:ExportModele>" + config + "</cab:ExportModele>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportModele",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var Data = storeDocument.findAllElements('vARJson').first;

      var jsonData = Data.text;
      print(Data.text);
      print("jsonData ==> $jsonData");
      //print("DATA ===>");

      String dataStr = Data.text;

      String idModele;
      String Designation;
      while (dataStr != null) {
        idModele = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("idModele==> $idModele");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        if (dataStr.indexOf("\",") == -1) // Last
        {
          Designation = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\"}"));
          dataStr = null;
        } else {
          Designation = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
          dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        }
        print("Designation==> $Designation");

        ModelR m = ModelR(idModele, Designation);
        getModel.add(m);
      }
    } catch (Exception) {
      print(Exception.toString());
    }
    return getModel;
  }

  //Liste Nom*****************************************************************************************
  Future<List<NomR>> getAllN() async {
    List<NomR> getNom = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.7";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope + "<cab:ExportNom>" + config + "</cab:ExportNom>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportNom",
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
        String Nom = ch.substring(0, ch.indexOf(",") + 1);
        Nom = Nom.substring(Nom.indexOf(":") + 1, Nom.length - 1);
        Nom = Nom.substring(1, Nom.length - 1);
        print("Nom=====>${Nom.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String Designation = "";
        if (j < l - 1) {
          Designation = ch.substring(0, ch.indexOf(",") + 1);
          Designation = Designation.substring(
              Designation.indexOf(":") + 1, Designation.length - 1);
          Designation = Designation.substring(1, Designation.length - 1);
          ch = ch.substring(ch.indexOf(",") + 1);
        } else {
          Designation = ch.substring(0, ch.indexOf("}") + 1);
          Designation = Designation.substring(
              Designation.indexOf(":") + 1, Designation.length - 1);
          Designation = Designation.substring(1, Designation.length - 1);
          print("Designation=====>${Designation.toString()}");
        }
        NomR t = new NomR(Nom, Designation);
        getNom.add(t);
      }
    } catch (Exception) {
      print(Exception.toString());
    }
    return getNom;
  }

  //Liste Magasin*****************************************************************************************

  Future<List<MagasinRec>> getAllMag() async {
    List<MagasinRec> getMag = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.7";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportMagasinOrigine>" +
          config +
          "</cab:ExportMagasinOrigine>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportMagasinOrigine",
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
        String Code = ch.substring(0, ch.indexOf(",") + 1);
        Code = Code.substring(Code.indexOf(":") + 1, Code.length - 1);
        Code = Code.substring(1, Code.length - 1);
        print("Code=====>${Code.toString()}");
        ch = ch.substring(ch.indexOf(",") + 1);

        String Nom = "";
        if (j < l - 1) {
          Nom = ch.substring(0, ch.indexOf(",") + 1);
          Nom = Nom.substring(Nom.indexOf(":") + 1, Nom.length - 1);
          Nom = Nom.substring(1, Nom.length - 1);
          ch = ch.substring(ch.indexOf(",") + 1);
        } else {
          Nom = ch.substring(0, ch.indexOf("}") + 1);
          Nom = Nom.substring(Nom.indexOf(":") + 1, Nom.length - 1);
          Nom = Nom.substring(1, Nom.length - 1);
          print("Nom=====>${Nom.toString()}");
        }
        MagasinRec t = new MagasinRec(Code, Nom);
        getMag.add(t);
      }
    } catch (Exception) {
      print(Exception.toString());
    }
    return getMag;
  }

  //Insert Reception*************************************************************************************

  Future<bool> InsertReception() async {
    String port = "7047";
    String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
    String ip = "192.168.1.7";
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

  //Export feuille transfert*************************************************************************************

  Future<List<FeuilleL>> getAllF() async {
    List<FeuilleL> getFeuil = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.7";
      var envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cab=\"urn:microsoft-dynamics-schemas/codeunit/CAB\"><soapenv:Header/>" +
              "<soapenv:Body>";
      envelope = envelope +
          "<cab:ExportLineFeuilleTransfert>" +
          config +
          "</cab:ExportLineFeuilleTransfert>";
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
                "urn:microsoft-dynamics-schemas/codeunit/CAB:ExportLineFeuilleTransfert",
          },
          body: envelope);
      print(response.statusCode);
      print("response.statusCode ==> ${response.statusCode}");
      print("response.reasonPhrase ==> ${response.reasonPhrase}");
      print("response.statusCode ==> ${response.body}");
      var storeDocument = xml.parse(response.body);

      var Data = storeDocument.findAllElements('vARJson').first;

      var jsonData = Data.text;
      print(Data.text);
      print("jsonData ==> $jsonData");
      //print("DATA ===>");

      String dataStr = Data.text;

      String emplacement;
      String article;
      String des;
      String qte;

      while (dataStr != null) {
        emplacement = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        print("emplacement==> $emplacement");
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);

        article = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("article==> $article");

        des = dataStr.substring(
            dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
        dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        print("des==> $des");

        if (dataStr.indexOf("\",") == -1) // Last
        {
          qte = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\"}"));
          dataStr = null;
        } else {
          qte = dataStr.substring(
              dataStr.indexOf(":\"") + 2, dataStr.indexOf("\","));
          dataStr = dataStr.substring(dataStr.indexOf("\",") + 2);
        }
        print("qte==> $qte");

        FeuilleL l = FeuilleL(emplacement, article, des, qte);
        getFeuil.add(l);
      }
    } catch (Exception) {
      print(Exception.toString());
    }
    return getFeuil;
  }

  //Export scanned item purchase*************************************************************************************

  Future<List<PurchaseE>> getScannedCommand() async {
    List<PurchaseE> getPurE = [];
    try {
      String port = "7047";
      String ws = "BC140/WS/CRONUS%20France%20S.A./Codeunit/";
      String ip = "192.168.1.7";
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
      String ip = "192.168.1.7";
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
