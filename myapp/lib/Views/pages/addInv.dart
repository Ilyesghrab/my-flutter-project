import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/Views/List/listProd.dart';
import 'package:myapp/Views/List/mylist.dart';
import 'package:myapp/Outils/FadeAnimation.dart';
import 'package:myapp/WS/InventaireWs.dart';

class AddInv extends StatefulWidget {
  @override
  AddInvState createState() => AddInvState();
}

class AddInvState extends State<AddInv> {
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

  final Barcodecontroller = TextEditingController();
  final Itemcontroller = TextEditingController();
  final Countcontroller = TextEditingController();
  String bc;
  String ds;
  String cn;

  Widget _buildBarcode() {
    return TextFormField(
      controller: Barcodecontroller,
      decoration: InputDecoration(
          icon: Icon(Icons.qr_code, color: Colors.lightBlue[900]),
          hintText: "Bar code item",
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

  Widget _buildItem() {
    return TextFormField(
      controller: Itemcontroller,
      decoration: InputDecoration(
          icon: Icon(Icons.tag, color: Colors.lightBlue[900]),
          hintText: "Item number",
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

  Widget _buildCount() {
    return TextFormField(
      controller: Countcontroller,
      decoration: InputDecoration(
          icon: Icon(Icons.calculate, color: Colors.lightBlue[900]),
          hintText: "Counting",
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
                  MaterialPageRoute(builder: (context) => MyList()),
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
                                      child: _buildBarcode()),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildItem()),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildCount()),
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
                              Text('Vrac Quantity',
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
                                        if (_counter > 0)
                                          setState(() {
                                            decrement();
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
                                    Text('$_counter',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 15.0)),
                                    InkWell(
                                      onTap: increment,
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
                          height: 10,
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
                                String bc = Barcodecontroller.value.text.trim();
                                String cnt = Countcontroller.value.text.trim();
                                String itno = Itemcontroller.value.text.trim();
                                String count1 = _counterQ.toString();
                                String count2 = _counter.toString();
                                String config =
                                    "<cab:inventoryNum>INV2101</cab:inventoryNum>" +
                                        "<cab:itemNo>" +
                                        itno +
                                        "</cab:itemNo>" +
                                        "<cab:itemBarCode>" +
                                        bc +
                                        "</cab:itemBarCode>" +
                                        "<cab:quantity>" +
                                        count1 +
                                        "</cab:quantity>" +
                                        "<cab:userId>C02</cab:userId>" +
                                        "<cab:terminalId></cab:terminalId>" +
                                        "<cab:vracQuantity>" +
                                        count2 +
                                        "</cab:vracQuantity>" +
                                        "<cab:comptage>" +
                                        cnt +
                                        "</cab:comptage>" +
                                        "<cab:binCode></cab:binCode>";
                                try {
                                  var ws =
                                      InventaireWs(config, "inventory_Entry");
                                  sucess = await ws.InsertInv();
                                } catch (e) {
                                  print("Exception ==> ");
                                  print(e.toString());
                                }
                                if (sucess) {
                                  Fluttertoast.showToast(
                                      msg: "Item added",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1);
                                }
                                ;
                                return {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListProd()))
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
