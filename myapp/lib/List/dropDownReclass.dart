import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/List/listArticleReclass.dart';
import 'package:myapp/List/listProd.dart';
import 'package:myapp/List/mylist.dart';
import 'package:myapp/Outils/FadeAnimation.dart';
import 'package:myapp/Outils/custom_dropdown.dart';
import 'package:myapp/WS/InventaireWs.dart';
import 'package:myapp/WS/ReclassificationWs.dart';
import 'package:myapp/model/magasin_Rec.dart';
import 'package:myapp/model/model_reclass.dart';
import 'package:myapp/model/nom_reclass.dart';
import 'package:myapp/pages/CategoriesPage.dart';

class DropDownRec extends StatefulWidget {
  @override
  DropDownRecState createState() => DropDownRecState();
}

class DropDownRecState extends State<DropDownRec> {
  int _counter = 0;
  int _counterQ = 0;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool pb = false;
  final Barcodecontroller = TextEditingController();
  final Itemcontroller = TextEditingController();
  final Countcontroller = TextEditingController();
  String bc;
  String ds;
  String cn;
  String mgSrc;
  String mgDest;
  String modele;
  String nom;
  Map<String, String> params = Map<String, String>();
  Future<List<ModelR>> getModel;
  Future<List<NomR>> getNom;
  Future<List<MagasinRec>> getMag;

  Future<List<ModelR>> getlist() async {
    try {
      String config = "<cab:vARJson></cab:vARJson>";
      ReclassificationWs ws = new ReclassificationWs(config, "model_reclass");

      List<ModelR> t = await ws.getAllM();
      int n = t.length;
      print(n.toString());
      if (t == null) {
        setState(() {
          pb = true;
        });
        return [];
      } else {
        setState(() {
          pb = false;
        });
        List<ModelR> a = [];
        setState(() {
          for (int i = 0; i < n; i++) {
            print("i=$i");
            a.add(t[n - 1 - i]);
          }
        });
        return a;
      }
    } catch (ex) {
      print("ex: $ex");
      setState(() {
        pb = true;
      });
    }
  }

  Future<List<NomR>> getlistN() async {
    try {
      String config =
          "<cab:modele>RECLASS</cab:modele>" + "<cab:vARJson></cab:vARJson>";
      ReclassificationWs ws = new ReclassificationWs(config, "nom_reclass");

      List<NomR> t = await ws.getAllN();
      int n = t.length;
      print(n.toString());
      if (t == null) {
        setState(() {
          pb = true;
        });
        return [];
      } else {
        setState(() {
          pb = false;
        });
        List<NomR> a = [];
        setState(() {
          for (int i = 0; i < n; i++) {
            print("i=$i");
            a.add(t[n - 1 - i]);
          }
        });
        return a;
      }
    } catch (ex) {
      print("ex: $ex");
      setState(() {
        pb = true;
      });
    }
  }

  Future<List<MagasinRec>> getlistMag() async {
    try {
      String config = "<cab:vARJson></cab:vARJson>";
      ReclassificationWs ws = new ReclassificationWs(config, "magasin_Rec");

      List<MagasinRec> t = await ws.getAllMag();
      int n = t.length;
      print(n.toString());
      if (t == null) {
        setState(() {
          pb = true;
        });
        return [];
      } else {
        setState(() {
          pb = false;
        });
        List<MagasinRec> a = [];
        setState(() {
          for (int i = 0; i < n; i++) {
            print("i=$i");
            a.add(t[n - 1 - i]);
          }
        });
        return a;
      }
    } catch (ex) {
      print("ex: $ex");
      setState(() {
        pb = true;
      });
    }
  }

  @override
  void initState() {
    getModel = getlist();
    getNom = getlistN();
    getMag = getlistMag();
    super.initState();
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
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
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
                        "Transfert Line",
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
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 48.0, left: 32.0, right: 32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            loadModel(),
                            SizedBox(
                              height: 20,
                            ),
                            loadName(),
                            SizedBox(
                              height: 20,
                            ),
                            loadMg("Source"),
                            SizedBox(
                              height: 20,
                            ),
                            loadMgDest("Destinantion"),
                            SizedBox(
                              height: 50,
                            ),
                            FadeAnimation(
                                1.6,
                                InkWell(
                                  onTap: () async {
                                    if (!_formKey.currentState.validate()) {
                                      return null;
                                    }
                                    _formKey.currentState.save();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsReclassement(modele, nom,
                                                    mgSrc, mgDest)));
                                  },
                                  child: Container(
                                    height: 50,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.lightBlue[900]),
                                    child: Center(
                                      child: Text(
                                        "Validate",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )),
                          ]),
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

  Widget loadModel() {
    return FutureBuilder<List<ModelR>>(
        future: getModel,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CupertinoActivityIndicator();
          } else {
            //print("yaaw${snapshot.data.type}");
            return Listener(
              onPointerUp: (_) => FocusScope.of(context).unfocus(),
              onPointerDown: (_) => FocusScope.of(context).unfocus(),
              child: new DropdownButtonFormField<String>(
                validator: (String value) {
                  if (value == null) {
                    return "Choisir le modèle";
                  }
                  return null;
                },
                isExpanded: true,
                iconSize: 30,
                iconEnabledColor: Colors.lightBlue[900],
                iconDisabledColor: Colors.lightBlue[900],
                decoration: InputDecoration(
                  labelText: 'Modele',
                  labelStyle: TextStyle(color: Colors.lightBlue[900]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue[900]),
                  ),
                  //),
                  border: InputBorder.none,
                ),
                items: snapshot.data.map((ModelR m) {
                  return new DropdownMenuItem<String>(
                    value: m.model,
                    child: new Text(m.des),
                  );
                }).toList(),
                onSaved: (v) {
                  modele = v;
                },
                onChanged: (v) {
                  setState(() {
                    modele = v;
                  });
                },
              ),
            );
          }
        });
  }

  Widget loadName() {
    return FutureBuilder<List<NomR>>(
        future: getNom,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CupertinoActivityIndicator();
          } else {
            //print("yaaw${snapshot.data.type}");
            return Listener(
              onPointerUp: (_) => FocusScope.of(context).unfocus(),
              onPointerDown: (_) => FocusScope.of(context).unfocus(),
              child: new DropdownButtonFormField<String>(
                //disabledHint: Text("Choisir le modèle avant"),
                validator: (String value) {
                  if (value == null) {
                    return "Choisir le nom";
                  }
                  return null;
                },
                isExpanded: true,
                iconSize: 30,
                iconEnabledColor: Colors.lightBlue[900],
                iconDisabledColor: Colors.lightBlue[900],
                decoration: InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: Colors.lightBlue[900]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue[900]),
                  ),
                  //),
                  border: InputBorder.none,
                ),
                items: snapshot.data.map((NomR n) {
                  return new DropdownMenuItem<String>(
                    value: n.nom,
                    child: new Text(n.des),
                  );
                }).toList(),
                onSaved: (v) {
                  nom = v;
                },
                onChanged: (v) {
                  setState(() {
                    nom = v;
                  });
                },
              ),
            );
          }
        });
  }

  Widget loadMg(String mg) {
    return FutureBuilder<List<MagasinRec>>(
        future: getMag,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CupertinoActivityIndicator();
          } else {
            return Listener(
              onPointerUp: (_) => FocusScope.of(context).unfocus(),
              onPointerDown: (_) => FocusScope.of(context).unfocus(),
              child: new DropdownButtonFormField<String>(
                validator: (String value) {
                  if (value == null) {
                    return "Choisir le magasin $mg";
                  }
                  return null;
                },
                isExpanded: true,
                iconSize: 30,
                iconEnabledColor: Colors.lightBlue[900],
                iconDisabledColor: Colors.lightBlue[900],
                decoration: InputDecoration(
                  labelText: "Magasin $mg",
                  labelStyle: TextStyle(color: Colors.lightBlue[900]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue[900]),
                  ),
                  border: InputBorder.none,
                ),
                items: snapshot.data.map((MagasinRec m) {
                  return new DropdownMenuItem<String>(
                    value: m.code,
                    child: new Text(m.nom),
                  );
                }).toList(),
                onSaved: (v) {
                  mgSrc = v;
                },
                onChanged: (v) {
                  setState(() {
                    mgSrc = v;
                  });
                },
              ),
            );
          }
        });
  }

  Widget loadMgDest(String mg) {
    return FutureBuilder<List<MagasinRec>>(
        future: getMag,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CupertinoActivityIndicator();
          } else {
            return Listener(
              onPointerUp: (_) => FocusScope.of(context).unfocus(),
              onPointerDown: (_) => FocusScope.of(context).unfocus(),
              child: new DropdownButtonFormField<String>(
                validator: (String value) {
                  if (value == null) {
                    return "Choisir le magasin $mg";
                  }
                  return null;
                },
                isExpanded: true,
                iconSize: 30,
                iconEnabledColor: Colors.lightBlue[900],
                iconDisabledColor: Colors.lightBlue[900],
                decoration: InputDecoration(
                  labelText: "Magasin $mg",
                  labelStyle: TextStyle(color: Colors.lightBlue[900]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue[900]),
                  ),
                  border: InputBorder.none,
                ),
                items: snapshot.data.map((MagasinRec m) {
                  return new DropdownMenuItem<String>(
                    value: m.code,
                    child: new Text(m.nom),
                  );
                }).toList(),
                onSaved: (v) {
                  mgDest = v;
                },
                onChanged: (v) {
                  setState(() {
                    mgDest = v;
                  });
                },
              ),
            );
          }
        });
  }
}
