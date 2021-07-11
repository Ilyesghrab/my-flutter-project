import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Views/List/listSalesLinePrep.dart';
import 'package:myapp/Views/List/mylist.dart';
import 'package:myapp/Views/pages/parametre.dart';
import 'package:myapp/WS/CommandPreparationWs.dart';

import 'package:myapp/Models/PreparationCommande/salesOrder.dart';
import 'package:myapp/Views/pages/CategoriesPage.dart';
import 'package:myapp/Data/data.dart';
import 'package:myapp/Views/pages/HomePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:myapp/Outils/search_widget.dart';
import 'package:myapp/Outils/slidable_widgetPrep.dart';
import 'package:myapp/Outils/Scanner/scan.dart';
import 'package:myapp/Sidebar/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:myapp/Models/produit.dart';
import 'package:myapp/Views/pages/addInv.dart';
import 'package:myapp/Views/pages/addPrep.dart';
import 'package:myapp/Views/pages/myaccountpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPrepCom extends StatefulWidget with NavigationStates {
  @override
  ListPrepComState createState() => ListPrepComState();
}

class ListPrepComState extends State<ListPrepCom>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  String codeScanner;
  String idCommande;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  Future<List<SalesOrder>> getOrders;
  List<Produit> items = List.of(Data.produits);
  String query = '';
  String itemNo = "itemNo";
  //String login;
  bool pb = false;
  Future<String> getItem() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _item = sp.getString("ItemNo");

    return _item;
  }

  Future<List<SalesOrder>> getlist() async {
    try {
      String config = "<cab:vARJson></cab:vARJson>";
      CommandPreparationWs ws =
          new CommandPreparationWs(config, "inventory_Header");

      List<SalesOrder> t = await ws.getAllO();
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
        List<SalesOrder> a = [];
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
    getOrders = getlist();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.value = _animationController.value;
    _animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(begin: Color(0xFF21BFBD), end: Color(0xFF21BFBD))
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
                      MaterialPageRoute(builder: (context) => CategoriesPage()),
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
                Text('Sales',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text('Order',
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
                                child: FutureBuilder<List<SalesOrder>>(
                                    future: getOrders,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<SalesOrder>>
                                            snapshot) {
                                      if (snapshot.data == null) {
                                        return CupertinoActivityIndicator();
                                      } else {
                                        return ListView.builder(
                                            itemCount: snapshot.data.length,
                                            //separatorBuilder: (context, index) => Divider(),
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      right: 2.0,
                                                      top: 2.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          child: Row(children: [
                                                        Hero(
                                                            tag: snapshot
                                                                .data[index]
                                                                .numOder,
                                                            child: Container(
                                                              width: 75.0,
                                                              height: 75.0,
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
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: AssetImage(
                                                                        'assets/images/inventory.png')),
                                                              ),
                                                            )),
                                                        SizedBox(width: 10.0),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .numOder,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          17.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .client,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          15.0,
                                                                      color: Colors
                                                                          .grey))
                                                            ])
                                                      ])),
                                                      IconButton(
                                                          icon: Icon(Icons
                                                              .arrow_forward_ios),
                                                          color: Colors.black,
                                                          onPressed: () {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ListSalesLinePrep(snapshot
                                                                        .data[
                                                                            index]
                                                                        .numOder)));
                                                          })
                                                    ],
                                                  ));
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
      /* floatingActionButton: Column(
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
      ),*/
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
        hintText: 'Name Or Location',
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
    /* return Container(
        child: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddInv()),
        );
      },
      tooltip: "Add",
      child: Icon(Icons.add),
    ));*/
  }

  Widget buttonScan() {
    /*return Container(
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
              "<cab:cde>101019</cab:cde>" +
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
            MaterialPageRoute(builder: (context) => AddPrep()),
          )
        };
      },
      tooltip: "Scan",
      child: Icon(Icons.qr_code),
    ));*/
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
