import 'package:flutter/material.dart';
import 'package:myapp/List/mylist.dart';
import 'package:myapp/Outils/FadeAnimation.dart';

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
                        "Inventory",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                                    child: TextField(
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.qr_code),
                                          hintText: "Bar code item",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.tag),
                                          hintText: "Designation",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.calculate),
                                          hintText: "Counting",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
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
                            Container(
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
                            )),
                        SizedBox(
                          height: 50,
                        ),
                        /*FadeAnimation(
                            1.7,
                            Text(
                              "Continue with social media",
                              style: TextStyle(color: Colors.grey),
                            )),*/
                        SizedBox(
                          height: 30,
                        ),
                        /*Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeAnimation(
                                  1.8,
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.blue),
                                    child: Center(
                                      child: Text(
                                        "Facebook",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: FadeAnimation(
                                  1.9,
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        "Github",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        )*/
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
