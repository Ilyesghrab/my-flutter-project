import 'package:flutter/material.dart';
import 'package:myapp/WS/ReclassificationWs.dart';
import 'package:myapp/model/model_reclass.dart';
import 'package:myapp/model/nom_reclass.dart';

class CustomDropdown extends StatefulWidget {
  //final String text;
  //const CustomDropdown({Key key, @required this.text}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  Map<String, String> params = Map<String, String>();
  bool pb = false;
  String modele;
  String nom;
  String mgSrc;
  String mgDest;
  Future<List<ModelR>> getModel;
  Future<List<NomR>> getNom;

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

  @override
  void initState() {
    getModel = getlist();
    getNom = getlistN();
    super.initState();
  }

  @override
  Widget buildM(BuildContext context) {
    return FutureBuilder<List<ModelR>>(
        future: getModel,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return null;
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

  @override
  Widget buildN(BuildContext context) {
    return FutureBuilder<List<NomR>>(
        future: getNom,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return null;
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
                iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
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

  /*Widget loadMg(String mg) {
    return FutureBuilder<List<Magasin>>(
        future: ServiceGetMagasins().getMagasins(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print("ERROR HERE !${snapshot.error}");
          if (snapshot.data == null) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
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
                iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Magasin $mg",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: InputBorder.none,
                ),
                items: snapshot.data.map((Magasin m) {
                  return new DropdownMenuItem<String>(
                    value: m.code,
                    child: new Text(m.nom),
                  );
                }).toList(),
                onSaved: (v) {
                  if (mg == "source") {
                    mgSrc = v;
                  } else {
                    mgDest = v;
                  }
                },
                onChanged: (v) {
                  setState(() {
                    if (mg == "source") {
                      mgSrc = v;
                    } else {
                      mgDest = v;
                    }
                  });
                },
              ),
            );
          }
        });
  }*/

  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /*Container buttonSection() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 15.0),
        child: RaisedButton(
          onPressed: () async {
            if (!_formKey.currentState.validate()) {
              return null;
            }
            _formKey.currentState.save();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailsReclassement(modele, nom, mgSrc, mgDest)));
          },
          elevation: 0.0,
          padding: EdgeInsets.all(12),
          color: Color.fromRGBO(102, 158, 64, 1.0),
          child: Text('Valider', style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ));
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Container(
        child: Form(
          child: Column(
            children: <Widget>[
              buildM(context),
              SizedBox(
                height: 10,
              ),
              buildN(context),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
