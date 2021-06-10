import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:project/class/ooorequest.dart';
import 'package:project/web_service/connectWS.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'class/employee.dart';
import 'customdrawer0.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Conge extends StatefulWidget {
  String no;

  Conge(String no) {
    this.no = no;
  }

  @override
  _CongeState createState() {
    return _CongeState(this.no);
  }
}

String frenshdate(String ch) {
  String month;
  String day;

  month = ch.substring(0, ch.indexOf("/"));

  String ch1 = ch.substring(month.length + 1);

  day = ch1.substring(0, ch1.indexOf("/"));

  String ch3 = ch1.substring(day.length + 1);

  String r = day + "/" + month + "/" + ch3;

  String hour;

  hour = r.substring(0, r.indexOf(":") + 1);

  String rest = r.substring(r.indexOf(":") + 1);

  String min = rest.substring(0, rest.indexOf(":"));

  String rest2 = rest.substring(rest.indexOf(":"));

  String sec = rest2.substring(0, rest2.indexOf(" "));

  String partday = rest2.substring(rest2.indexOf(" "));

  String r2 = hour + min + partday;

  return r2;
}

createDeleteDialog(BuildContext context) {
  Color gr = HexColor("#05445E");
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.SCALE,
    title: 'Avertissement :',
    desc: 'Cette demande va être Supprimée',
    btnOkText: "Supprimer",
    btnOkColor: gr,
    btnOkOnPress: () {},
  )..show();
}

String onlydate(String ch) {
  List<String> t;
  String aux;
  ch = ch.substring(0, ch.indexOf(" "));
  t = ch.split("/");
  aux = t[0];
  t[0] = t[1];
  t[1] = aux;
  ch = t[0] + "/" + t[1] + "/" + t[2];
  return ch;
}

createcancelDialog(BuildContext context) {
  Color gr = HexColor("#05445E");
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.SCALE,
    title: 'Avertissement :',
    desc: 'Cette demande va être Annuler',
    btnOkText: "Annuler",
    btnOkColor: Colors.grey[500],
    btnOkOnPress: () {
      //Annuler la demande
      //changer le status de 0 à 1
    },
  )..show();
}

createDetailDialog(BuildContext context, OOOrequest t) {
  Color gr = HexColor("#05445E");
  String bpod = "";
  String epod = "";
  bool iscaneled = false;
  if (t.beginPartOfDay == "0" || t.beginPartOfDay == "2") {
    bpod = "1er Partie";
  }
  if (t.beginPartOfDay == "1") bpod = "2eme Partie";
  if (t.endPartOfDay == "1" || t.endPartOfDay == "2") {
    epod = "2eme Partie";
  }
  if (t.reqStatusId == "2") iscaneled = true;
  String inst = t.instruction == "" ? "aucune note trouvée!" : t.instruction;
  if (t.endPartOfDay == "0") epod = "1er Partie";
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.NO_HEADER,
    animType: AnimType.SCALE,
    customHeader: CircleAvatar(
      backgroundColor: gr,
      radius: 45,
      child: Icon(
        Icons.access_time_sharp,
        color: Colors.white,
        size: 45,
      ),
    ),
    body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Conge :",
                  style: TextStyle(color: gr),
                ),
                Container(
                  width: 100,
                  child: Text(
                    "\t\t ${t.description}",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  "description :",
                  style: TextStyle(color: gr),
                ),
                Container(
                  width: 150,
                  child: Text(
                    "\t\t${t.detail}",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Date de debut :",
                  style: TextStyle(color: gr),
                ),
                Container(
                  width: 100,
                  child: Text(
                    "\t\t ${onlydate(t.beginDate)}",
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  "Date de fin :",
                  style: TextStyle(color: gr),
                ),
                Container(
                  width: 100,
                  child: Text(
                    "\t\t  ${onlydate(t.endDate)}",
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Partie de debut :",
                  style: TextStyle(color: gr),
                ),
                Text(
                  "\t\t $bpod\n",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  "Partie de fin :",
                  style: TextStyle(color: gr),
                ),
                Text(
                  "\t\t $epod\n",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Nombre de jours :",
                  style: TextStyle(color: gr),
                ),
                Text(
                  "\t\t ${t.nbOfDays}\n",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  "Nombre d'heurs :",
                  style: TextStyle(color: gr),
                ),
                Text(
                  "\t\t ${t.nbOfHours}\n",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
        Visibility(
          visible: iscaneled,
          child: Center(
            child: Column(
              children: [
                Text("Note:", style: TextStyle(color: gr)),
                Text(
                  "$inst",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Visibility(
              visible: t.reqStatusId == "0",
              child: RaisedButton(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "Annuler",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    return createcancelDialog(context);
                  }),
            ),
            RaisedButton(
                child: Text(
                  "Fermer",
                  style: TextStyle(color: Colors.white),
                ),
                color: gr,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        )
      ],
    ),
    /*btnOkOnPress: () {
      if (t.reqStatusId == "0")
        return createcancelDialog(context);
      else
        return createDeleteDialog(context);
    },*/
  )..show();
}

class _CongeState extends State<Conge> {
  String no;
  Future<List<OOOrequest>> tasks;
  Future<List<OOOrequest>> tasks1;

  bool pb = false;
  _CongeState(String no) {
    this.no = no;
  }
  Future<String> langg;
  String lang;
  Future<Employee> e;
  Employee ee;
  Future<List<OOOrequest>> getlist() async {
    try {
      ConnectWS ws = new ConnectWS(
          "<EmployeeId>${this.no}</EmployeeId>", "GetAllOOORequests");
      List<OOOrequest> t = await ws.ooorequestselect();

      int n = t.length;

      if (t == null) {
        setState(() {
          pb = true;
        });
        return [];
      } else {
        setState(() {
          pb = false;
        });
        List<OOOrequest> a = List<OOOrequest>();
        setState(() {
          for (int i = 0; i < n; i++) {
            print("i=$i");
            a.add(t[n - 1 - i]);
          }
        });
        return a;
      }
    } catch (ex) {
      setState(() {
        pb = true;
      });
    }
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Attention !!"),
            content: Text("vous etes sûre ?"),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Annuler"),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  /* final snackBar = SnackBar(
                    content: Text('Yay! A SnackBar!'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar); */
                },
                child: Text(
                  "Confirmer",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  Future<Employee> getemployee() async {
    try {
      //String type = await FlutterIp.networkType;
      ConnectWS ws = new ConnectWS("<No>$no</No>", "SelectEmployeeByNo");
      Employee emp = await ws.employeeselect();
      print("ee");
      if (emp != null) {
        setState(() {
          // print(type);
          pb = false;
        });
        return emp;
      } else {
        setState(() {
          pb = true;
        });
        return null;
      }
    } catch (ex) {}
  }

  convert() async {
    ee = await this.e;
    lang = await this.langg;
  }

  bool vi = false;
  List<String> items = [
    "Tous",
    "Approuver",
    "Refuser",
    "En attente",
    "Annuler",
  ];
  ScrollController _rrectController = ScrollController();
  List<OOOrequest> filtredlist(List<OOOrequest> a, String s) {
    List<OOOrequest> r = [];

    for (int i = 0; i < a.length; i++) {
      if (a[i].reqStatusId == s) r.add(a[i]);
    }
    if (r == [])
      setState(() {
        vi = true;
      });
    else
      setState(() {
        vi = false;
      });
    return r;
  }

  final searchcontroller = TextEditingController();
  Color bg = Colors.white;
  Color bg2 = HexColor("#75E6DA");
  Color bg3 = HexColor("#189AB4");
  Color bg4 = HexColor("#05445E");
  Color cr1 = HexColor("#BE3144");
  Color cr2 = HexColor("#3A4750");
  Color cr3 = HexColor("#303841");
  Color gr = HexColor("#006400");
  String selecteditem;
  List<OOOrequest> aaa = [];
  int ok = 0;
  List<String> docs = ["1", "2", "3", "2", "3", "2", "1", "3", "3", "2"];
  List<String> docs1 = ["1", "2", "3", "2", "3", "2", "1", "3", "3", "2"];
  List<String> docs2 = ["1", "2", "3", "2", "3", "2", "1", "3", "3", "2"];
  @override
  Future<int> listlength(Future<List<OOOrequest>> a) async {
    List<OOOrequest> r = await a;
    return r.length;
  }

  serchinlist(ch, ta) async {
    bool auxvi = vi;
    ch = ch.toLowerCase();
    List<OOOrequest> a = [];
    List<OOOrequest> con = aaa.length == 0 && ok == 0 ? await ta : aaa;
    print("in serching list");

    if (ch.isNotEmpty) {
      setState(() {
        vs = true;
      });
      if (con.length != 0) {
        for (var i = 0; i < con.length; i++) {
          if (con[i].description.toLowerCase().contains(ch) ||
              con[i].beginDate.toLowerCase().contains(ch) ||
              con[i].endDate.toLowerCase().contains(ch) ||
              con[i].reqDetail.toLowerCase().contains(ch) ||
              con[i].detail.toLowerCase().contains(ch)) a.add(con[i]);
        }
        if (a.isNotEmpty) {
          setState(() {
            vi = false;
            tasks = Future.sync(() => a);
          });
        } else
          setState(() {
            vi = true;
            tasks = Future.sync(() => []);
          });
      }
    } else {
      List<OOOrequest> con1 = aaa.length == 0 && ok == 0 ? await ta : aaa;

      setState(() {
        vs = false;
        vi = con1.length == 0;
        tasks = Future.sync(() => aaa.length == 0 && ok == 0 ? ta : aaa);
      });
    }
  }

  Future<String> getlang() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    print(sharedPrefs.getKeys());
    return sharedPrefs.getString("la").toString();
  }

  void initState() {
    tasks = getlist();
    tasks1 = getlist();

    this.e = this.getemployee();
    this.langg = getlang();
    setState(() {
      convert();
    });
    super.initState();
  }

  bool vs = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    /* var ws = ConnectWS("<EmployeeId>" + no + "</EmployeeId>", "EmployeeProfil");
    Future<Map> vr = ws.employeeselect(context);
    vr.toString();
    print("hi    $vr");
    String dara = vr.toString(); */
    String dara = "email";
    String sh;

    if (this.ee == null)
      setState(() {
        dara = sh = "...";
      });
    else
      setState(() {
        dara = this.ee.email;
        sh = this.ee.img;
      });
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Mes demandes Congés",
          ),
          backgroundColor: bg4,
        ),
        drawer: Custom_drawer0(bg4: bg4, no: no, gr: gr, lang: lang, e: ee),
        body: RefreshIndicator(
          onRefresh: refreshinglist,
          child: Column(
            children: [
              ///chercher
              Container(
                decoration: BoxDecoration(color: bg4),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Container(
                        decoration: BoxDecoration(color: bg4),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                                controller: searchcontroller,
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: cr1),
                                    focusedBorder: OutlineInputBorder(
                                      gapPadding: 0.0,
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(color: cr1),
                                    ),
                                    hoverColor: Colors.white,
                                    prefixIcon: Icon(Icons.search, color: cr1),
                                    suffix: Visibility(
                                      child: InkWell(
                                          child: Icon(
                                            Icons.cancel,
                                            color: cr1,
                                            size: 25,
                                          ),
                                          onTap: () {
                                            searchcontroller.clear();
                                            setState(() {
                                              vs = false;
                                              if (aaa.length == 0 && ok == 0) {
                                                tasks =
                                                    Future.sync(() => tasks1);
                                                vi = false;
                                              } else {
                                                if (aaa.length == 0 &&
                                                    ok == 1) {
                                                  vi = true;
                                                } else {
                                                  vi = false;
                                                  tasks =
                                                      Future.sync(() => aaa);
                                                }
                                              }
                                            });
                                          }),
                                      visible: vs,
                                    ),
                                    hintText: "Chercher..."),
                                onChanged: (ch) {
                                  serchinlist(ch, tasks1);
                                }),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: DropdownButton(
                              focusColor: Colors.white,
                              hint:
                                  /*Text(
                              "Filtrer...",
                              style: TextStyle(color: bg4),
                            ),*/
                                  RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.bookmark,
                                          color: Colors.black, size: 18),
                                    ),
                                    TextSpan(text: "  "),
                                    TextSpan(
                                        text: "Tous",
                                        style: TextStyle(color: bg4)),
                                  ],
                                ),
                              ),
                              value: selecteditem,
                              dropdownColor: bg,
                              items: items.map((e) {
                                Color cr;
                                switch (e) {
                                  case "Annuler":
                                    cr = Colors.grey[500];
                                    break;
                                  case "En attente":
                                    cr = Colors.orange[800];
                                    break;
                                  case "Refuser":
                                    cr = Colors.red[700];
                                    break;
                                  case "Approuver":
                                    cr = Colors.green;
                                    break;
                                }
                                return DropdownMenuItem(
                                  child:
                                      /*Text(
                                  e,
                                  style: TextStyle(color: bg4),
                                  
                                ),*/
                                      RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(Icons.bookmark,
                                              color: cr, size: 18),
                                        ),
                                        TextSpan(text: "  "),
                                        TextSpan(
                                            text: e,
                                            style: TextStyle(color: bg4)),
                                      ],
                                    ),
                                  ),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (value) async {
                                print("here ${searchcontroller.value.text}");

                                List<OOOrequest> a = await tasks;
                                List<OOOrequest> a1 = await tasks1;

                                print("length :${a.length}");

                                setState(() {
                                  ok = 1;
                                  selecteditem = value;

                                  if (value == "Approuver") {
                                    a = filtredlist(a1, "3");
                                    aaa = a;
                                    if (a.length == 0)
                                      vi = true;
                                    else
                                      vi = false;
                                  }
                                  if (value == "Refuser") {
                                    a = filtredlist(a1, "2");
                                    aaa = a;
                                    if (a.length == 0)
                                      vi = true;
                                    else
                                      vi = false;
                                  }
                                  if (value == "En attente") {
                                    a = filtredlist(a1, "0");
                                    aaa = a;

                                    if (a.length == 0)
                                      vi = true;
                                    else
                                      vi = false;
                                  }
                                  if (value == "Annuler") {
                                    a = filtredlist(a1, "1");
                                    aaa = a;
                                    print(a.length);
                                    if (a.length == 0)
                                      vi = true;
                                    else
                                      vi = false;
                                  }
                                  if (value == "Tous") {
                                    a = a1;
                                    vi = false;
                                    aaa = a;
                                  }
                                  tasks = Future.sync(() => a);
                                });
                                if (searchcontroller.value.text != "") {
                                  setState(() {
                                    serchinlist(
                                        searchcontroller.value.text.trim(),
                                        aaa);
                                  });
                                }
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                  visible: vi,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Aucune damande trouvée ..."),
                  )),

              ///fin chercher
              Visibility(
                visible: !pb,
                child: FutureBuilder<List<OOOrequest>>(
                    future: tasks,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<OOOrequest>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Expanded(
                          child: DraggableScrollbar.rrect(
                            controller: _rrectController,
                            /* labelTextBuilder: (double offset) =>
                                Text("${(offset ~/ 100) + 1}"),*/
                            backgroundColor: cr1,
                            child: ListView.builder(
                              controller: _rrectController,
                              //key: PageStorageKey<String>("page_5document"),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                int st =
                                    int.parse(snapshot.data[index].reqStatusId);

                                Color cr;
                                switch (st) {
                                  case 1:
                                    cr = Colors.grey[500];
                                    break;
                                  case 0:
                                    cr = Colors.orange[800];
                                    break;
                                  case 2:
                                    cr = Colors.red[700];
                                    break;
                                  case 3:
                                    cr = Colors.green;
                                    break;
                                }
                                OOOrequest t = snapshot.data[index];
                                String date = frenshdate(t.reqDetail);
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ListTile(
                                        onTap: () {
                                          return createDetailDialog(context, t);
                                        },
                                        title: Text(
                                          "${t.description}",
                                          style: TextStyle(
                                            color: bg4,
                                            fontSize: 22,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${t.detail}\nDéposer le $date\n",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        leading: Container(
                                          decoration: BoxDecoration(
                                              color: cr,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Text(""),
                                          width: 40,
                                          height: 40,
                                        ),
                                        trailing: Icon(
                                          Icons.more_vert,
                                          color: bg4,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 10,
                                      color: bg4,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return /*Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              child: Text(
                                "chargement...",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: bg4,
                                ),
                              ),
                            ));*/
                            Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SpinKitFadingCube(
                            color: bg4,
                            size: 50.0,
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
        /* floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /*    Navigator.pushNamed(context, "/formc", arguments: {});
          print("hello");
        */
          /* return Dialog(
            
          );*/

        },
        label: Text("Ajouter une demande"),
        icon: Icon(
          Icons.add,
          size: 25,
        ),
        backgroundColor: bg4,
      ),*/
        /*floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: Text("Retour"),
                  backgroundColor: cr1,
                  icon: Icon(Icons.arrow_back),
                  heroTag: null,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    /*    Navigator.pushNamed(context, "/formc", arguments: {});
          print("hello");
        */
                    /* return Dialog(
            
          );*/
                  },
                  label: Text("Ajouter une demande"),
                  heroTag: null,
                  icon: Icon(
                    Icons.add,
                    size: 25,
                  ),
                  backgroundColor: bg4,
                )
              ],
            ),
          )*/
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                Navigator.pushNamed(context, "/formc", arguments: {"no": ee});

                /* return Dialog(
            
          );*/
              }
            } catch (ex) {
              Fluttertoast.showToast(
                  msg: "Problème de connection !",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1);
            }
          },
          child: Icon(
            Icons.add,
            size: 25,
          ),
          backgroundColor: cr1,
        ));
  }

  Future<Null> refreshinglist() async {
    setState(() {
      tasks = getlist();
      tasks1 = getlist();

      this.e = this.getemployee();
      this.langg = getlang();

      convert();
    });
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}

class Customtile extends StatelessWidget {
  IconData icon;
  Color cr;
  String text;
  Function ontap;
  bool isv;
  Color bg4 = HexColor("#05445E");
  Customtile(this.icon, this.text, this.ontap, this.cr, this.isv);
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isv,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(this.icon, color: cr),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      this.text,
                      style: TextStyle(fontSize: 25, color: cr),
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_right, color: cr)
            ],
          ),
          splashColor: bg4,
          onTap: this.ontap,
        ),
      ),
    );
  }
}
