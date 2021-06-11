import 'package:flutter/material.dart';
import 'package:flutter_ui_login/connect/ClientsSQL.dart';
import 'package:flutter_ui_login/connect/ProduitsSQL.dart';
import 'package:flutter_ui_login/models/ClientsTable.dart';
import 'package:flutter_ui_login/models/Produits.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:ntlm/ntlm.dart' as ntlm;
//import 'package:flutterapp2/globales.dart' as globales;

class WebserviceGetItems {
  WebserviceGetItems(); //this.username,this.password);

  Future<int> getlistarticles(context) async {
    //  ntlm.NTLMClient client = new ntlm.NTLMClient(username: "HP", password: "nidhaldev", workstation: "DESKTOP-BATF7IS", domain: "192.168.1.8:7047");
/*
    ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Download, isDismissible: true, showLogs: false);

    pr.style(
        message: 'Téléchargement de la liste des articles ...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    pr.show();
*/
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String instance = sharedPrefs.getString('instance');
    String bd = sharedPrefs.getString('BD');
    String WS = sharedPrefs.getString('WS');
    String WORKSTATION = sharedPrefs.getString('WORKSTAT');
    String login = sharedPrefs.getString('LOG');
    String password = sharedPrefs.getString('PWD');
    try {
      var envelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:msv="urn:microsoft-dynamics-schemas/codeunit/$WS">
   <soapenv:Header/>
   <soapenv:Body>
      <msv:GetItems>
         <msv:vARJson></msv:vARJson>
      </msv:GetItems>
   </soapenv:Body>
</soapenv:Envelope>
    ''';

      //print("1==W  ");
      // print("1==W  YOUSSEF-PC\\youssef");

      ntlm.NTLMClient client = new ntlm.NTLMClient(
          username: login,
          password: password,
          workstation: WORKSTATION,
          domain: WORKSTATION,
          lmPassword: ntlm.lmHash(password),
          ntPassword: ntlm.ntHash(password));
      print(client.toString());
      http.Response response =
          await client.post("http://$ip:$port/$instance/WS/$bd/Codeunit/$WS",
              headers: {
                "Content-Type": "text/xml; charset=utf-8",
                "SOAPAction":
                    "urn:microsoft-dynamics-schemas/codeunit/$WS:GetItems",
              },
              body: envelope);
      if (response.statusCode != 200) {
        Fluttertoast.showToast(
            msg:
                "Une erreur s'est produite veuillez synchroniser ultérieurement!!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
        return 0;
      }
      Future<int> k = DBHelperProduits.deleteAll();

      if (response.statusCode == 401) {
        return 401;
      }
      print("res.statusCode ==> ${response.statusCode}");
      print("res.reasonPhrase ==> ${response.reasonPhrase}");
      print("res.statusCode ==> ${response.body}");

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
      l = (l / 7) as double;
      for (int j = 0; j < l; j++) {
        String ItemNo = ch.substring(0, ch.indexOf(",") + 1);

        ItemNo = ItemNo.substring(ItemNo.indexOf(":") + 1, ItemNo.length - 1);
        ItemNo = ItemNo.substring(1, ItemNo.length - 1);

        ch = ch.substring(ch.indexOf(",") + 1);

        String Description = ch.substring(0, ch.indexOf(",") + 1);
        Description = Description.substring(
            Description.indexOf(":") + 1, Description.length - 1);
        Description = Description.substring(1, Description.length - 1);

        ch = ch.substring(ch.indexOf(",") + 1);

        String UnitPrice = ch.substring(0, ch.indexOf(",") + 1);
        UnitPrice = UnitPrice.substring(
            UnitPrice.indexOf(":") + 1, UnitPrice.length - 1);
        UnitPrice = UnitPrice.substring(1, UnitPrice.length - 1);

        ch = ch.substring(ch.indexOf(",") + 1);

        String SalesUnitOfMeasure = ch.substring(0, ch.indexOf(",") + 1);
        SalesUnitOfMeasure = SalesUnitOfMeasure.substring(
            SalesUnitOfMeasure.indexOf(":") + 1, SalesUnitOfMeasure.length - 1);
        SalesUnitOfMeasure =
            SalesUnitOfMeasure.substring(1, SalesUnitOfMeasure.length - 1);

        ch = ch.substring(ch.indexOf(",") + 1);

        String CodeCategory = ch.substring(0, ch.indexOf(",") + 1);
        CodeCategory = CodeCategory.substring(
            CodeCategory.indexOf(":") + 1, CodeCategory.length - 1);
        CodeCategory = CodeCategory.substring(1, CodeCategory.length - 1);

        ch = ch.substring(ch.indexOf(",") + 1);

        String PourcentageTVA = ch.substring(0, ch.indexOf(",") + 1);
        PourcentageTVA = PourcentageTVA.substring(
            PourcentageTVA.indexOf(":") + 1, PourcentageTVA.length - 1);
        PourcentageTVA = PourcentageTVA.substring(1, PourcentageTVA.length - 1);

        ch = ch.substring(ch.indexOf(",") + 1);
        String QteUniteVente = "";
        if (j < l - 1) {
          QteUniteVente = ch.substring(0, ch.indexOf(",") + 1);
          QteUniteVente = QteUniteVente.substring(
              QteUniteVente.indexOf(":") + 1, QteUniteVente.length - 1);
          QteUniteVente = QteUniteVente.substring(1, QteUniteVente.length - 1);
          ch = ch.substring(ch.indexOf(",") + 1);
        } else {
          QteUniteVente = ch.substring(0, ch.indexOf("}") + 1);

          QteUniteVente = QteUniteVente.substring(
              QteUniteVente.indexOf(":") + 1, QteUniteVente.length - 1);
          QteUniteVente = QteUniteVente.substring(1, QteUniteVente.length - 1);
        }

        var envelope2 =
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:msv="urn:microsoft-dynamics-schemas/codeunit/$WS">
      <soapenv:Header/>
      <soapenv:Body>
      <msv:ExportPictureToBase64>
         <msv:iMG></msv:iMG>
         <msv:itemNo>$ItemNo</msv:itemNo>
      </msv:ExportPictureToBase64>

      </soapenv:Body>
      </soapenv:Envelope>''';
        ntlm.NTLMClient client = new ntlm.NTLMClient(
            username: login,
            password: password,
            workstation: WORKSTATION,
            domain: WORKSTATION,
            lmPassword: ntlm.lmHash(password),
            ntPassword: ntlm.ntHash(password));
        print(client.toString());
        http.Response response =
            await client.post("http://$ip:$port/$instance/WS/$bd/Codeunit/$WS",
                headers: {
                  "Content-Type": "text/xml; charset=utf-8",
                  "SOAPAction":
                      "urn:microsoft-dynamics-schemas/codeunit/$WS:ExportPicture",
                },
                body: envelope2);

        if (response.statusCode == 401) {
          return 401;
        }
        print("res.statusCode ==> ${response.statusCode}");
        print("res.reasonPhrase ==> ${response.reasonPhrase}");
        print("res.statusCode ==> ${response.body}");

        if (response.statusCode != 200)
          Fluttertoast.showToast(
              msg:
                  "Une erreur s'est produite veuillez synchroniser ultérieurement!!!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1);
        var StoreDocument2 = xml.parse(response.body);
        var StatusXML2 =
            StoreDocument2.findAllElements('iMG').first.children.toString();
        Future<Produits> dt = DBHelperProduits.save(Produits(
            int.parse(j.toString()),
            ItemNo,
            Description,
            UnitPrice,
            SalesUnitOfMeasure,
            CodeCategory,
            PourcentageTVA,
            QteUniteVente,
            StatusXML2));
      }
      Fluttertoast.showToast(
          msg: "La liste des articles est téléchargée avec succés ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    } catch (ex) {
      Fluttertoast.showToast(
          msg:
              "Une erreur s'est produite veuillez synchroniser ultérieurement!!!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    }
    /*    Future.delayed(Duration(seconds: 3)).then((value) {
      pr.hide().whenComplete(() {
        print(pr.isShowing());
      });
    });
     */

    return 0;
  }
}
