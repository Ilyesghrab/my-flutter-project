import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Views/List/detailsPage.dart';
import 'package:myapp/Views/List/listCount.dart';
import 'package:myapp/Views/List/mylist.dart';
import 'package:myapp/Views/pages/parametre.dart';
import 'package:myapp/WS/InventaireWs.dart';
import 'package:myapp/Models/Inventaire/inventory_Entry.dart';
import 'package:myapp/Views/pages/CategoriesPage.dart';
import 'package:myapp/Data/data.dart';
import 'package:myapp/Views/pages/HomePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:myapp/Outils/search_widget.dart';
import 'package:myapp/Outils/Scanner/scan.dart';
import 'package:myapp/Sidebar/bloc.navigation_bloc/navigation_bloc.dart';

import 'package:myapp/Models/produit.dart';
import 'package:myapp/Views/pages/myaccountpage.dart';

class ListCummul extends StatefulWidget with NavigationStates {
  String noInv;
  ListCummul(this.noInv);
  @override
  ListCummulState createState() => ListCummulState();
}

class ListCummulState extends State<ListCummul>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  Future<List<InventoryE>> getCummul;
  List<Produit> items = List.of(Data.produits);
  String query = '';
  String login;
  bool pb = false;

  Future<List<InventoryE>> getlistCummul() async {
    try {
      String config = "<cab:inventoryNum>${widget.noInv}</cab:inventoryNum>" +
          "<cab:terminalId></cab:terminalId>" +
          "<cab:comptage>1</cab:comptage>" +
          "<cab:vARJson></cab:vARJson>";
      InventaireWs ws = new InventaireWs(config, "inventory_Entry");

      List<InventoryE> t = await ws.getScannedCummul();
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
        List<InventoryE> a = [];
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
    getCummul = getlistCummul();
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
                      MaterialPageRoute(
                          builder: (context) => ListCount(widget.noInv)),
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
                Text('Items',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text('LIST cummul',
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
                                child: FutureBuilder<List<InventoryE>>(
                                    future: getCummul,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<InventoryE>>
                                            snapshot) {
                                      if (snapshot.data == null) {
                                        return CupertinoActivityIndicator();
                                      } else {
                                        return ListView.builder(
                                            itemCount: snapshot.data.length,
                                            //separatorBuilder: (context, index) => Divider(),
                                            itemBuilder: (context, index) {
                                              InventoryE t =
                                                  snapshot.data[index];
                                              return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0,
                                                      right: 10.0,
                                                      top: 10.0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) => DetailsPage(
                                                                    designation:
                                                                        t.des,
                                                                    emplacement: t
                                                                        .emplacement,
                                                                    quatite:
                                                                        t.qte,
                                                                    reference: t
                                                                        .ref)));
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
                                                                            image: AssetImage('assets/images/feuav.jpg')),
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
                                                                          "Reference: ${t.ref} | Quantity: ${t.qte}\nEmplacement ${t.emplacement}\n  ",
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

  /* Widget buildListTile(AsyncSnapshot snapshot) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsPage(
                      //heroTag: item.imgPath,
                      // foodName: snapshot.data.locationCd,
                      //foodPrice: snapshot.data.no,
                      )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Hero(
                      //tag: item.imgPath,
                      child: Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF21BFBD), width: 3),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/inventory.png")),
                    ),
                  )),
                  SizedBox(width: 10.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data.locationCd,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Text(snapshot.data.no,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey))
                      ])
                ])),
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                    onPressed: () {})
              ],
            )));
  }*/

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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanPage()),
        );
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
