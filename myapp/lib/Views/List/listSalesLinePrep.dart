import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Views/List/ListPrepCom.dart';

import 'package:myapp/Views/List/detailsPagePrep.dart';

import 'package:myapp/Views/List/mylist.dart';
import 'package:myapp/Outils/AnimatedFlipCounter.dart';
import 'package:myapp/Views/pages/parametre.dart';
import 'package:myapp/WS/CommandPreparationWs.dart';

import 'package:myapp/Models/PreparationCommande/sales_Line.dart';
import 'package:myapp/Views/pages/CategoriesPage.dart';
import 'package:myapp/Data/data.dart';
import 'package:myapp/Views/pages/HomePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:myapp/Outils/search_widget.dart';

import 'package:myapp/Outils/Scanner/scan.dart';
import 'package:myapp/Sidebar/bloc.navigation_bloc/navigation_bloc.dart';

import 'package:myapp/Models/produit.dart';
import 'package:myapp/Views/pages/addPrep.dart';
import 'package:myapp/Views/pages/myaccountpage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListSalesLinePrep extends StatefulWidget with NavigationStates {
  String idCommande;
  ListSalesLinePrep(this.idCommande);
  @override
  ListSalesLinePrepState createState() => ListSalesLinePrepState();
}

class ListSalesLinePrepState extends State<ListSalesLinePrep>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  String codeScanner;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  Future<List<SalesL>> getLineP;
  List<Produit> items = List.of(Data.produits);
  String query = '';
  String login;
  bool pb = false;
  String itemNo = "itemNo";
  Future<String> getItem() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _item = sp.getString("ItemNo");

    return _item;
  }

  Future<List<SalesL>> getlistC() async {
    try {
      String config = "<cab:orderNum>${widget.idCommande}</cab:orderNum>" +
          "<cab:vARJson></cab:vARJson>";
      CommandPreparationWs ws = new CommandPreparationWs(config, "sales_Line");

      List<SalesL> t = await ws.getExportLinePrep();
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
        List<SalesL> a = [];
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
    getLineP = getlistC();
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
                      MaterialPageRoute(builder: (context) => ListPrepCom()),
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
                          color: Colors.white,
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
                Text('Sales Line',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text('N??${widget.idCommande}',
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
                                child: FutureBuilder<List<SalesL>>(
                                    future: getLineP,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<SalesL>> snapshot) {
                                      if (snapshot.data == null) {
                                        return CupertinoActivityIndicator();
                                      } else {
                                        return ListView.builder(
                                            itemCount: snapshot.data.length,
                                            //separatorBuilder: (context, index) => Divider(),
                                            itemBuilder: (context, index) {
                                              SalesL t = snapshot.data[index];
                                              double sum =
                                                  (double.parse(t.qte_prepare) /
                                                      double.parse(t.qte));
                                              int p = (sum * 100).round();
                                              Color c;
                                              if ((p >= 0) && (p <= 10))
                                                c = Color.fromRGBO(
                                                    190, 33, 43, 1.0);
                                              else if ((p > 10) && (p <= 20))
                                                c = Color.fromRGBO(
                                                    236, 66, 49, 1.0);
                                              else if ((p > 20) && (p <= 40))
                                                c = Color.fromRGBO(
                                                    239, 91, 41, 1.0);
                                              else if ((p > 40) && (p <= 50))
                                                c = Color.fromRGBO(
                                                    247, 175, 66, 1.0);
                                              else if ((p > 50) && (p <= 60))
                                                c = Color.fromRGBO(
                                                    248, 237, 54, 1.0);
                                              else if ((p > 60) && (p <= 70))
                                                c = Color.fromRGBO(
                                                    216, 222, 51, 1.0);
                                              else if ((p > 70) && (p <= 80))
                                                c = Color.fromRGBO(
                                                    140, 199, 63, 1.0);
                                              else if ((p > 80) && (p <= 90))
                                                c = Color.fromRGBO(
                                                    58, 180, 71, 1.0);
                                              else if ((p > 90) && (p <= 100))
                                                c = Color.fromRGBO(
                                                    9, 150, 71, 1.0);
                                              return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0,
                                                      right: 10.0,
                                                      top: 10.0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => DetailsPagePrep(
                                                                designation: t
                                                                    .designation,
                                                                quantityPrep: t
                                                                    .qte_prepare,
                                                                quatite: t.qte,
                                                                reference: t
                                                                    .reference)));
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
                                                                        CircularPercentIndicator(
                                                                      animation:
                                                                          true,
                                                                      animationDuration:
                                                                          1500,
                                                                      radius:
                                                                          50.0,
                                                                      lineWidth:
                                                                          5.0,
                                                                      percent:
                                                                          sum,
                                                                      center:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          AnimatedFlipCounter(
                                                                            duration:
                                                                                Duration(milliseconds: 1200),
                                                                            value:
                                                                                p,
                                                                            color:
                                                                                Colors.black,
                                                                            size:
                                                                                13,
                                                                          ),
                                                                          Text(
                                                                              "%")
                                                                        ],
                                                                      ),
                                                                      progressColor:
                                                                          c,
                                                                    )
                                                                    /*Container(
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
                                                                            image: AssetImage('assets/images/jante.jpg')),
                                                                      ),
                                                                    )*/
                                                                    ),
                                                                SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "${t.designation}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontSize: 17.0,
                                                                              fontWeight: FontWeight.bold)),
                                                                      Text(
                                                                          "Reference: ${t.reference} | Quantity: ${t.qte}\nQuantity Prep ${t.qte_prepare}\n  ",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontSize: 15.0,
                                                                              color: Colors.grey))
                                                                    ])
                                                              ])),
                                                          /*IconButton(
                                                      icon: Icon(
                                                          Icons.arrow_back_ios),
                                                      color: Colors.black,
                                                      onPressed: () {})*/
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
                MaterialPageRoute(builder: (context) => Param()),
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
              "<cab:cde>${widget.idCommande}</cab:cde>" +
              "<cab:shelf></cab:shelf>" +
              "<cab:itemNo>$itemNo</cab:itemNo>" +
              "<cab:designation></cab:designation>" +
              "<cab:quantity>0</cab:quantity>";
          var ws = CommandPreparationWs(config, "sales_line");
          ws.getScannedSales(context);
        });

        return {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPrep(widget.idCommande)),
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
