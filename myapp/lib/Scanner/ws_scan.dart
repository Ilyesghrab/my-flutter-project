import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ws_Scan extends StatefulWidget {
  @override
  _Ws_ScanState createState() => _Ws_ScanState();
}

class _Ws_ScanState extends State<Ws_Scan> {
  String qrCode;
  String address = "address";
  String port = "port";
  String ns = "espace de nom";
  String ins = "instance";
  String radd = "192.176.1.3";
  String res = "HRVsion";
  Future<String> getadd() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _address = sp.getString("AdresseIp");

    return _address;
  }

  Future<String> getnamespace() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _ns = sp.getString("NameSpace");
    return _ns;
  }

  Future<String> getins() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _ins = sp.getString("WS");
    return _ins;
  }

  Future<String> getport() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _port = sp.getString("Port");
    return _port;
  }

  @override
  void initState() {
    super.initState();
    getadd().then(updateadd);
    getport().then(updateport);
    getins().then(updateins);
    getnamespace().then(updatens);
  }

  void updateadd(String _add) {
    setState(() {
      this.address = _add;
    });
  }

  void updateport(String _add) {
    setState(() {
      this.port = _add;
    });
  }

  void updatens(String _add) {
    setState(() {
      this.ns = _add;
    });
  }

  void updateins(String _add) {
    setState(() {
      this.ins = _add;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color cr1 = HexColor("#BE3144");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.qr_code),
          backgroundColor: cr1,
          onPressed: () => Qr_scan()),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address",
              style: TextStyle(fontSize: 20, color: Colors.blue[800]),
            ),
            Flexible(
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: address,
                ),
                style: TextStyle(fontSize: 20),
                readOnly: true,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Esapce de nom : ",
              style: TextStyle(fontSize: 20, color: Colors.blue[800]),
            ),
            TextFormField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: ns,
              ),
              style: TextStyle(fontSize: 20),
              readOnly: true,
            ),
          ],
        ),
      )),
    );
  }

  Future<void> Qr_scan() async {
    List<String> fh, sh, hh;

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Fermer',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode == "-1" ? "Address" : qrCode;
        fh = qrCode.split(":");
        address = fh[0];
        sh = fh[1].split("/");
        port = sh[0];
        ins = sh[1];
        sp.setString("AdresseIp", address);
        sp.setString("Port", port);
        sp.setString("WS", ins);
        hh = ins.split(".");

        ns = hh[0].substring(2);
        sp.setString("NameSpace", ns);
      });
    } catch (ex) {
      qrCode = 'erreur au scan';
    }
  }
}
