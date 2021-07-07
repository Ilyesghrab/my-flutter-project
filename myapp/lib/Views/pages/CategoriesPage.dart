import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Data/data.dart';
import 'package:myapp/Data/inventories.dart';
import 'package:myapp/Data/livraisons.dart';
import 'package:myapp/Data/receptions.dart';
import 'package:myapp/Data/scanners.dart';
import 'package:myapp/Data/transferts.dart';
import 'package:myapp/Data/categories.dart';
import 'package:myapp/Models/livraison.dart';
import 'package:myapp/Views/List/ListPrepCom.dart';
import 'package:myapp/Views/List/dropDownReclass.dart';
import 'package:myapp/Views/List/listPurchase.dart';
import 'package:myapp/Views/List/listTransfert.dart';
import 'package:myapp/Outils/Scanner/scan.dart';
import 'package:myapp/Models/inventory.dart';

import 'package:myapp/Views/Livraison/listDetailsload.dart';
import 'package:myapp/Views/pages/HomePage.dart';
import 'package:myapp/Views/List/mylist.dart';
import 'package:myapp/Sidebar/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:myapp/Models/category.dart';
import 'package:myapp/Models/scanner.dart';
import 'package:myapp/Models/transfert.dart';
import 'package:myapp/Models/reception.dart';
import 'package:myapp/Models/produit.dart';
import 'package:myapp/Views/pages/parametre.dart';

class CategoriesPage extends StatefulWidget with NavigationStates {
  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  // Current selected
  int current = 0;

  // Handle Indicator
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  List<Produit> tems = List.of(Data.produits);
  List<Category> items = List.of(Categories.categoris);
  List<Inventory> itemss = List.of(Inventories.inventoris);
  List<Reception> ritems = List.of(Receptions.receptions);
  List<Transfert> titems = List.of(Transferts.transferts);
  List<Livraison> litems = List.of(Livraisons.deliveries);
  List<Scanner> sitems = List.of(Scanners.scanners);
  String qrCodeResult = "Not Yet Scanned";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  color: Colors.grey[400],
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.QUESTION,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Warning',
                      desc: 'Are you sure you want to quit ?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    )..show();
                  },
                ),
                Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Param()),
                            );
                          },
                          child: Container(
                            height: 51,
                            width: 59,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/ilyes.jpg'))),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Home PAGE',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 18.0)),
                Text('Ilyes Ghrab',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0))
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 199,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(55.0)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16, right: 6),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 199,
                  width: 344,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Color(item.backgroundColor),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: SvgPicture.asset(item.cardElementTop),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SvgPicture.asset(item.cardElementBottom),
                      ),
                      Positioned(
                        left: 29,
                        top: 48,
                        child: Text(
                          'Category Name',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Positioned(
                        left: 29,
                        top: 65,
                        child: Text(
                          item.categoryName,
                          style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                      Positioned(
                        right: 21,
                        top: 35,
                        child: Image.asset(
                          item.imageUrl,
                          width: 27,
                          height: 27,
                        ),
                      ),
                      Positioned(
                        left: 29,
                        bottom: 45,
                        child: Text(
                          'DESCRIPTION',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      Positioned(
                        left: 29,
                        bottom: 21,
                        child: Text(
                          item.description,
                          style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 12, top: 29, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Categories',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  Row(
                    children: map<Widget>(
                      items,
                      (index, selected) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          height: 9,
                          width: 9,
                          margin: EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: current == index
                                  ? Colors.teal[600]
                                  : Colors.teal[600]),
                        );
                      },
                    ),
                  )
                ]),
          ),
          Container(
            height: 123,
            child: ListView.builder(
              itemCount: (sitems.length) &
                  (itemss.length) &
                  (ritems.length) &
                  (titems.length) &
                  (litems.length),
              padding: EdgeInsets.only(left: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      current = index;
                    });
                  },
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListPrepCom()),
                          );
                        },
                        child: OperationCat(
                            operation: sitems[index].scannerName,
                            selectedIcon: sitems[index].selectedIcon,
                            unselectedIcon: sitems[index].unselectedIcon,
                            isSelected: current == index,
                            context: this),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyList()),
                          );
                        },
                        child: OperationCat(
                            operation: itemss[index].inventoryName,
                            selectedIcon: itemss[index].selectedIcon,
                            unselectedIcon: itemss[index].unselectedIcon,
                            isSelected: current == index,
                            context: this),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListPurchase()),
                          );
                        },
                        child: OperationCat(
                            operation: ritems[index].receptionName,
                            selectedIcon: ritems[index].selectedIcon,
                            unselectedIcon: ritems[index].unselectedIcon,
                            isSelected: current == index,
                            context: this),
                      ),
                      InkWell(
                        onTap: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Option',
                            desc: 'Please choose action to continue',
                            btnCancelText: "Reclassifica-\ntion",
                            btnCancelColor: Colors.lightBlue[900],
                            btnCancelIcon: Icons.outbond,
                            btnCancelOnPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DropDownRec()),
                              );
                            },
                            btnOkText: "Transfert",
                            btnOkColor: Colors.purple[700],
                            btnOkIcon: Icons.transfer_within_a_station_outlined,
                            btnOkOnPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListTransfert()),
                              );
                            },
                          )..show();
                        },
                        child: OperationCat(
                            operation: titems[index].transfertName,
                            selectedIcon: titems[index].selectedIcon,
                            unselectedIcon: titems[index].unselectedIcon,
                            isSelected: current == index,
                            context: this),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListDetailsload()),
                          );
                        },
                        child: OperationCat(
                            operation: litems[index].livraisonName,
                            selectedIcon: litems[index].selectedIcon,
                            unselectedIcon: litems[index].unselectedIcon,
                            isSelected: current == index,
                            context: this),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 12, top: 10, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Product',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    child: Icon(Icons.qr_code_rounded, color: Colors.teal[600]),
                  ),
                ]),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(right: 20, left: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal[600],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              avatarWidget("amortisseur", "Amortisseur"),
              avatarWidget("feua", "Feux arriére"),
              avatarWidget("feuav", "Feux avant"),
              avatarWidget("jante", "Jante"),
              avatarWidget("pneu", "Pneu"),
              avatarWidget("radio", "Radio CD"),
            ]),
          ),
        ]),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.teal[600],
          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.white,
          height: 50,
          items: <Widget>[
            InkWell(
              child: Icon(Icons.supervised_user_circle_outlined,
                  size: 20, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Param()),
                );
              },
            ),
            InkWell(
              child: Icon(Icons.qr_code_scanner, size: 20, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanPage()),
                );
              },
            ),
            InkWell(
              child: Icon(Icons.home, size: 20, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
            ),
            InkWell(
              child:
                  Icon(Icons.list_alt_rounded, size: 20, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyList()),
                );
              },
            ),
            InkWell(
              child: Icon(
                Icons.exit_to_app,
                size: 20,
                color: Colors.black,
              ),
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.QUESTION,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Warning',
                  desc: 'Are you sure you want to quit ?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                )..show();
                /*  confirmationDialog(context, "Confirm Exiting App",
                    positiveText: "Exit", positiveAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                });*/
                //Navigator.push(
                // context,
                // MaterialPageRoute(builder: (context) => HomePage()),
              },
            ),
          ],
          animationDuration: Duration(milliseconds: 200),
          index: 2,
          animationCurve: Curves.bounceInOut,
          onTap: (index) {
            debugPrint("Current Index is $index");
          },
        ),
      );

  /* Widget buildCategories() => Container(
        height: 250,
        child: GridView(
          primary: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5 / 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          children: categories
              .map((category) => CategoryHeaderWidget(category: category))
              .toList(),
        ),
      );*/

  /*children: [
          /*Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 15),
            child: Text(
              'Popular',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),*/
          Container(
              height: 240,
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: categories
                  .map((category) => CategoryDetailWidget(
                        category: category,
                        onSelectedCategory: (category) {},
                      ))
                  .toList(),  
            ),
              )
        ],*/
  /*Widget buildP(Produit it) {
    return Container(
      height: 150,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.grey[200]),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 10),
        itemCount: Items.length,
        itemBuilder: (context, index) {
          final it = Items[index];
          return Container(
              margin: EdgeInsets.only(right: 10),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage(it.imgPath), fit: BoxFit.contain),
                  border: Border.all(color: Colors.teal[600], width: 2)),
              child: Stack(
                children: <Widget>[
                  Text(
                    it.foodName,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w700),
                  )
                ],
              ));
        },
      ),
    );
  }*/
}

class OperationCat extends StatefulWidget {
  final String operation;
  final String selectedIcon;
  final String unselectedIcon;
  final bool isSelected;
  CategoriesPageState context;

  OperationCat(
      {this.operation,
      this.selectedIcon,
      this.unselectedIcon,
      this.isSelected,
      this.context});

  @override
  _OperationCatState createState() => _OperationCatState();
}

class _OperationCatState extends State<OperationCat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 123,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              blurRadius: 5,
              spreadRadius: 3,
              offset: Offset(8.0, 6.0),
            )
          ],
          borderRadius: BorderRadius.circular(15),
          color: widget.isSelected
              ? Colors.grey[200]
              : Colors.teal[600]), //reverse
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(widget.isSelected
              ? widget.unselectedIcon
              : widget.selectedIcon), //reverse
          SizedBox(
            height: 9,
          ),
          Text(
            widget.operation,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: widget.isSelected
                    ? Colors.teal[600]
                    : Colors.white), //reverse
          )
        ],
      ),
    );
  }
}

Container avatarWidget(String img, String name) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    height: 150,
    width: 120,
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100],
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(8.0, 6.0),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.grey[200]),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage('assets/images/$img.jpg'),
                  fit: BoxFit.contain),
              border: Border.all(color: Colors.teal[600], width: 2)),
        ),
        Text(
          name,
          style: TextStyle(
              fontSize: 16,
              color: Colors.teal[600],
              fontFamily: 'avenir',
              fontWeight: FontWeight.w700),
        )
      ],
    ),
  );
}
