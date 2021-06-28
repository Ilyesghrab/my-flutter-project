import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Data/data.dart';
import 'package:myapp/List/detailsPageRec.dart';
import 'package:myapp/List/dropDownReclass.dart';
import 'package:myapp/List/mylist.dart';
import 'package:myapp/Outils/search_widget.dart';
import 'package:myapp/Scanner/scan.dart';
import 'package:myapp/Sidebar/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:myapp/WS/ReclassificationWs.dart';
import 'package:myapp/model/feuille_Line.dart';
import 'package:myapp/model/produit.dart';
import 'package:myapp/pages/CategoriesPage.dart';
import 'package:myapp/pages/HomePage.dart';
import 'package:myapp/pages/addReclass.dart';
import 'package:myapp/pages/myaccountpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsReclassement extends StatefulWidget with NavigationStates {
  String modele, nom, mgSrc, mgDest;

  DetailsReclassement(this.modele, this.nom, this.mgSrc, this.mgDest);
  @override
  _DetailsReclassementState createState() => _DetailsReclassementState();
}

class _DetailsReclassementState extends State<DetailsReclassement>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  List<Produit> items = List.of(Data.produits);
  String query = '';
  String login;
  bool pb = false;
  Future<List<FeuilleL>> getFeuil;
  String quatity = "quantity";
  String itemNo = "itemNo";
  String designation = "designation";
  String qteEmplacement = "qteEmplacement";
  String codeScanner;

  Future<String> getQuantity() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _quantity = sp.getString("Quantity");

    return _quantity;
  }

  Future<String> getItem() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _item = sp.getString("ItemNo");

    return _item;
  }

  Future<String> getDesignation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _designation = sp.getString("Designation");

    return _designation;
  }

  Future<String> getQteEmpl() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _qteEmplacement = sp.getString("QteEmplacement");

    return _qteEmplacement;
  }

  Future<List<FeuilleL>> getlist() async {
    try {
      String config = "<cab:modele>${widget.modele}</cab:modele>" +
          "<cab:nom>${widget.nom}</cab:nom>" +
          "<cab:vARJson></cab:vARJson>";
      ReclassificationWs ws = new ReclassificationWs(config, "purchace_Entry");

      List<FeuilleL> t = await ws.getAllF();
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
        List<FeuilleL> a = [];
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
    getFeuil = getlist();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.value = _animationController.value;
    _animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(begin: Color(0xFF21BFBD), end: Colors.red)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.00, 1.00, curve: Curves.linear)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
                Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          color: Color(0xFF21BFBD),
                          onPressed: () {},
                        ),
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Transfert',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text("${widget.modele}|${widget.nom}",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 25.0))
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 25.0, right: 20.0),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height - 300.0,
                        child: Column(
                          children: <Widget>[
                            buildSearch(),
                            Expanded(
                                child: FutureBuilder<List<FeuilleL>>(
                                    future: getFeuil,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<FeuilleL>>
                                            snapshot) {
                                      if (snapshot.data == null) {
                                        return CupertinoActivityIndicator();
                                      } else {
                                        return ListView.builder(
                                            itemCount: snapshot.data.length,
                                            //separatorBuilder: (context, index) => Divider(),
                                            itemBuilder: (context, index) {
                                              FeuilleL t = snapshot.data[index];
                                              return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0,
                                                      right: 10.0,
                                                      top: 10.0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailsPageRec(
                                                                    designation:
                                                                        t.des,
                                                                    emplacement:
                                                                        t.emp,
                                                                    quatite:
                                                                        t.qte,
                                                                    article: t
                                                                        .article)));
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                              child: Row(
                                                                  children: [
                                                                Hero(
                                                                    tag: "",
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          60.0,
                                                                      height:
                                                                          60.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Colors.white,
                                                                            //0xFF21BFBD),
                                                                            width: 3),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .white,
                                                                        image: DecorationImage(
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            image: AssetImage('assets/images/feua.jpg')),
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "${t.des}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontSize: 17.0,
                                                                              fontWeight: FontWeight.bold)),
                                                                      Text(
                                                                          "Emplacement: ${t.emp}\nQuantity: ${t.qte}\nArticle: ${t.article}\n  ",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontSize: 15.0,
                                                                              color: Colors.grey))
                                                                    ])
                                                              ])),
                                                        ],
                                                      )));
                                            });
                                      }
                                    }))
                          ],
                        )),
                  )
                ]),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Transform(
                    transform: Matrix4.translationValues(
                        0.0, _translateButton.value * 2.0, 0.0),
                    child: buttonAdd(),
                  )),
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Transform(
                    transform: Matrix4.translationValues(
                        0.0, _translateButton.value, 0.0),
                    child: buttonScan(),
                  )),
          buttonToggle()
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFF21BFBD),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
          GestureDetector(
            child: Icon(Icons.supervised_user_circle_outlined,
                size: 20, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAccountsPage()),
              );
            },
          ),
          GestureDetector(
            child: Icon(Icons.qr_code_scanner, size: 20, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanPage()),
              );
            },
          ),
          GestureDetector(
            child: Icon(Icons.home, size: 20, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesPage()),
              );
            },
          ),
          GestureDetector(
            child: Icon(Icons.list_alt_rounded, size: 20, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyList()),
              );
            },
          ),
          GestureDetector(
            child: Icon(Icons.exit_to_app, size: 20, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ],
        animationDuration: Duration(milliseconds: 200),
        index: 3,
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          debugPrint("Current Index is $index");
        },
      ),
      drawer: Drawer(),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Product Name',
        onChanged: searchItem,
      );

  void searchItem(String query) {
    final items = Data.produits.where((produit) {
      final nameLower = produit.foodName.toLowerCase();
      final priceLower = produit.foodPrice.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          priceLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.items = items;
    });
  }

  Widget buttonAdd() {
    return Container(
        child: FloatingActionButton(
      onPressed: () {},
      tooltip: "Add",
      child: Icon(Icons.add),
    ));
  }

  Widget buttonScan() {
    return Container(
        child: FloatingActionButton(
      onPressed: () async {
        List<String> fh;
        SharedPreferences sp = await SharedPreferences.getInstance();
        String codeScanner = await BarcodeScanner.scan();
        setState(() {
          this.codeScanner = codeScanner == "-1" ? "itemNo" : codeScanner;
          fh = codeScanner.split(" ");
          itemNo = fh[0];
          sp.setString("ItemNo", itemNo);
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
          var ws = ReclassificationWs(config, "article");
          ws.getAricleReclass(context);
        });

        return {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddReclass(
                    widget.modele, widget.nom, widget.mgSrc, widget.mgDest)),
          )
        };
      },
      tooltip: "Scan",
      child: Icon(Icons.qr_code),
    ));
  }

  Widget buttonToggle() {
    return Container(
        child: FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: "Toggle",
      child: AnimatedIcon(
          icon: AnimatedIcons.menu_close, progress: _animationIcon),
    ));
  }

  animate() {
    if (!isOpened)
      _animationController.forward();
    else
      _animationController.reverse();
    isOpened = !isOpened;
  }
}
