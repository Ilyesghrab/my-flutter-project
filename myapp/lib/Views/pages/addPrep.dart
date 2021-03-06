import 'package:flutter/material.dart';
import 'package:myapp/Views/List/listSalesLinePrep.dart';
import 'package:myapp/Outils/FadeAnimation.dart';
import 'package:myapp/WS/CommandPreparationWs.dart';
import 'package:myapp/Models/PreparationCommande/sales_Line.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPrep extends StatefulWidget {
  //String modele, nom, mgSrc, mgDest;
  String idCommande;
  AddPrep(this.idCommande);
  @override
  AddPrepState createState() => AddPrepState();
}

class AddPrepState extends State<AddPrep> {
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

  Future<String> getlog() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _address = sp.getString("Login");

    return _address;
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
  String login = "login";

  Future<String> loadArticle() async {
    //Article article;
    String config = "<cab:barCode>$itemNo</cab:barCode>" +
        "<cab:cde>${widget.idCommande}</cab:cde>" +
        "<cab:shelf></cab:shelf>" +
        "<cab:itemNo>$itemNo</cab:itemNo>" +
        "<cab:designation></cab:designation>" +
        "<cab:quantity>0</cab:quantity>";
    CommandPreparationWs ws = new CommandPreparationWs(config, "sales_line");
    SalesL salesL = await ws.getScannedSales(context);
  }

  Widget _buildBarcode({@required String hintText}) {
    return TextFormField(
      controller: Barcodecontroller,
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(Icons.qr_code, color: Colors.red[400]),
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
          icon: Icon(Icons.model_training, color: Colors.red[400]),
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
          icon: Icon(Icons.description, color: Colors.red[400]),
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
          icon: Icon(Icons.outbond_outlined, color: Colors.red[400]),
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
          icon: Icon(Icons.move_to_inbox_outlined, color: Colors.red[400]),
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
          icon: Icon(Icons.insert_drive_file_outlined, color: Colors.red[400]),
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
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.red[400], Colors.red[100], Colors.red[50]])),
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
                  MaterialPageRoute(
                      builder: (context) =>
                          ListSalesLinePrep(widget.idCommande)),
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
                                          hintText:
                                              "Item Bar code:    $itemNo")),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildModel(
                                          hintText:
                                              "Commande:    ${widget.idCommande}")),
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
                                    color: Colors.red[400]),
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
                                            color: Colors.red[400]),
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
                                            color: Colors.red[400],
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
                                String count1 = _counterQ.toString();
                                String config = "<cab:itemNo>$itemNo</cab:itemNo>" +
                                    "<cab:cde>${widget.idCommande}</cab:cde>" +
                                    "<cab:qte>" +
                                    count1 +
                                    "</cab:qte>" +
                                    "<cab:terminalID></cab:terminalID>" +
                                    "<cab:utilisateur>$login</cab:utilisateur>" +
                                    "<cab:vARJson></cab:vARJson>";

                                try {
                                  var ws =
                                      CommandPreparationWs(config, "article");
                                  ws.InsertPrep();
                                } catch (e) {
                                  print("Exception ==> ");
                                  print(e.toString());
                                }

                                return {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListSalesLinePrep(
                                                      widget.idCommande)))
                                      .then((_) => setState(() {}))
                                };
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.red[400]),
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
