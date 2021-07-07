import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/Views/List/dropDownReclass.dart';

import 'package:myapp/Views/List/listProd.dart';

import 'package:myapp/Outils/FadeAnimation.dart';
import 'package:myapp/WS/InventaireWs.dart';
import 'package:myapp/WS/ReclassificationWs.dart';
import 'package:myapp/Models/article.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddReclass extends StatefulWidget {
  String modele, nom, mgSrc, mgDest;

  AddReclass(this.modele, this.nom, this.mgSrc, this.mgDest);
  @override
  AddReclassState createState() => AddReclassState();
}

class AddReclassState extends State<AddReclass> {
  int _counter = 0;
  int _counterQ = 1;

  void incrementQ() {
    setState(() {
      _counterQ++;
    });
  }

  void decrementQ() {
    setState(() {
      _counterQ--;
    });
  }

  void increment() {
    setState(() {
      _counter++;
    });
  }

  void decrement() {
    setState(() {
      _counter--;
    });
  }

  Future<String> getItem() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _item = sp.getString("ItemNo");

    return _item;
  }

  final Barcodecontroller = TextEditingController();
  final Modelcontroller = TextEditingController();
  final Nomcontroller = TextEditingController();
  final MgOcontroller = TextEditingController();
  final MgDestcontroller = TextEditingController();
  final Doccontroller = TextEditingController();
  String bc;
  String ds;
  String cn;
  String itemNo = "itemNo";

  Future<String> loadArticle() async {
    //Article article;
    String config = "<cab:barCode>$itemNo</cab:barCode>" +
        "<cab:modele></cab:modele>" +
        "<cab:nom></cab:nom>" +
        "<cab:magasinOrigine></cab:magasinOrigine>" +
        "<cab:magasinDestination></cab:magasinDestination>" +
        "<cab:emplacementOrigine></cab:emplacementOrigine>" +
        "<cab:emplacementDestination></cab:emplacementDestination>" +
        "<cab:itemNo></cab:itemNo>" +
        "<cab:designation></cab:designation>" +
        "<cab:quantity>0</cab:quantity>" +
        "<cab:qteEmplacement>0</cab:qteEmplacement>";
    ReclassificationWs ws = new ReclassificationWs(config, "article");
    Article article = await ws.getAricleReclass(context);
    String count2 = _counterQ.toString();
    count2 = article.qte;
  }

  Widget _buildBarcode({@required String hintText}) {
    return TextFormField(
      controller: Barcodecontroller,
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.qr_code, color: Colors.lightBlue[900]),
          //hintText: "Bar code item",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Bar code is required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildModel({@required String hintText}) {
    return TextFormField(
      controller: Modelcontroller,
      decoration: InputDecoration(
          icon: Icon(Icons.model_training, color: Colors.lightBlue[900]),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Item number is required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildNom({@required String hintText}) {
    return TextFormField(
      controller: Nomcontroller,
      decoration: InputDecoration(
          icon: Icon(Icons.description, color: Colors.lightBlue[900]),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Counting number is required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildMagOrig({@required String hintText}) {
    return TextFormField(
      controller: MgOcontroller,
      decoration: InputDecoration(
          icon: Icon(Icons.outbond_outlined, color: Colors.lightBlue[900]),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Counting number is required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildMagDest({@required String hintText}) {
    return TextFormField(
      controller: MgDestcontroller,
      decoration: InputDecoration(
          icon:
              Icon(Icons.move_to_inbox_outlined, color: Colors.lightBlue[900]),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Counting number is required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildDoc({@required String hintText}) {
    return TextFormField(
      controller: Doccontroller,
      decoration: InputDecoration(
          icon: Icon(Icons.insert_drive_file_outlined,
              color: Colors.lightBlue[900]),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Counting number is required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {},
    );
  }

  @override
  void initState() {
    super.initState();
    getItem().then(updateItemNo);
    super.initState();
  }

  void updateItemNo(String _add) {
    setState(() {
      this.itemNo = _add;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.lightBlue[900],
          Colors.lightBlue[800],
          Colors.lightBlue[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DropDownRec()),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Insert",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.3,
                      Text(
                        "Item to counting",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        FadeAnimation(
                            1.4,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200],
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildBarcode(
                                          hintText: "Item Bar code: $itemNo")),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildModel(
                                          hintText: "Model: ${widget.modele}")),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildNom(
                                          hintText: "Name: ${widget.nom}")),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildMagOrig(
                                          hintText:
                                              "Magsin Origin: ${widget.mgSrc}")),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildMagDest(
                                          hintText:
                                              "Magasin Destination: ${widget.mgDest}")),
                                  /*Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildDoc(hintText: "documents")),*/
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1.4,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Quantity',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat')),
                              Container(
                                width: 125.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17.0),
                                    color: Colors.lightBlue[900]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        if (_counterQ > 0)
                                          setState(() {
                                            decrementQ();
                                          });
                                      },
                                      child: Container(
                                        height: 25.0,
                                        width: 25.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            color: Colors.lightBlue[900]),
                                        child: Center(
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text('$_counterQ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 15.0)),
                                    InkWell(
                                      onTap: incrementQ,
                                      child: Container(
                                        height: 25.0,
                                        width: 25.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            color: Colors.white),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.lightBlue[900],
                                            size: 20.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                            1.6,
                            InkWell(
                              onTap: () async {
                                bool sucess;

                                String count1 = _counterQ.toString();
                                String config = "<cab:itemNo>$itemNo</cab:itemNo>" +
                                    "<cab:modele>${widget.modele}</cab:modele>" +
                                    "<cab:nom>${widget.nom}</cab:nom>" +
                                    "<cab:magasinOrigine>${widget.mgSrc}</cab:magasinOrigine>" +
                                    "<cab:magasinDestination>${widget.mgDest}</cab:magasinDestination>" +
                                    "<cab:emplacementOrigine></cab:emplacementOrigine>" +
                                    "<cab:emplacementDestination></cab:emplacementDestination>" +
                                    "<cab:qte>" +
                                    count1 +
                                    "</cab:qte>" +
                                    "<cab:noDocument></cab:noDocument>";

                                try {
                                  var ws =
                                      ReclassificationWs(config, "article");
                                  sucess = await ws.InsertReclassement();
                                } catch (e) {
                                  print("Exception ==> ");
                                  print(e.toString());
                                }
                                if (sucess) {
                                  Fluttertoast.showToast(
                                      msg: "Ligne feuille added",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1);
                                }

                                return {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DropDownRec()))
                                };
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.lightBlue[900]),
                                child: Center(
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
