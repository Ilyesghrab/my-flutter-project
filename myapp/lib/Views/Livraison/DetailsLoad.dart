import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Outils/FadeAnimation.dart';

class DetailsLoad extends StatefulWidget {
  final numBL;
  final numCom;
  final codeClient;
  final nomClient;
  final adresse;
  final dateBL;
  final montantHT;
  final montantTTC;

  DetailsLoad(
      {this.numBL,
      this.numCom,
      this.codeClient,
      this.nomClient,
      this.adresse,
      this.dateBL,
      this.montantHT,
      this.montantTTC});

  @override
  _DetailsLoadState createState() => _DetailsLoadState();
}

class _DetailsLoadState extends State<DetailsLoad> {
  var selectedCard = 'WEIGHT';
  int _counter = 0;

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

  String qrCodeResult = "Not Yet Scanned";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF7A9BEE),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Details',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
              color: Colors.white,
            )
          ],
        ),
        body: ListView(children: [
          Stack(children: [
            Container(
                height: MediaQuery.of(context).size.height - 82.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent),
            Positioned(
                top: 75.0,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height - 100.0,
                    width: MediaQuery.of(context).size.width)),
            Positioned(
                top: 20.0,
                left: (MediaQuery.of(context).size.width / 2) - 100.0,
                child: Hero(
                    tag: widget.nomClient,
                    child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFF7A9BEE), width: 3),
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage("assets/images/feua.jpg"),
                                fit: BoxFit.cover)),
                        height: 200.0,
                        width: 200.0))),
            Positioned(
                top: 250.0,
                left: 25.0,
                right: 25.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                      1.4,
                      Text(widget.nomClient,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal)),
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FadeAnimation(
                          1.4,
                          Text("N°BL: ${widget.numBL}",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20.0,
                                  color: Colors.grey)),
                        ),
                        Container(height: 25.0, color: Colors.grey, width: 1.0),
                        FadeAnimation(
                          1.4,
                          Text("Code Client: ${widget.codeClient}",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20.0,
                                  color: Colors.grey)),
                        ),
                        /*Container(
                          width: 125.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.0),
                              color: Color(0xFF7A9BEE)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: decrement,
                                child: Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Color(0xFF7A9BEE)),
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
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Colors.white),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF7A9BEE),
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )*/
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Container(
                        height: 150.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            FadeAnimation(
                              1.4,
                              _buildInfoCard('Numero', '${widget.numCom}', ''),
                            ),
                            SizedBox(width: 10.0),
                            FadeAnimation(
                              1.4,
                              _buildInfoCard(
                                  'Code Client', '${widget.codeClient}', ''),
                            ),
                            SizedBox(width: 10.0),
                            FadeAnimation(
                                1.4,
                                _buildInfoCard(
                                    'Adresse', '${widget.adresse}', '')),
                            SizedBox(width: 10.0),
                            FadeAnimation(
                              1.4,
                              _buildInfoCard('Date', '${widget.dateBL}', ''),
                            ),
                            SizedBox(width: 10.0),
                            FadeAnimation(
                              1.4,
                              _buildInfoCard(
                                  'Montant HT', '${widget.montantHT}', ''),
                            ),
                            SizedBox(width: 10.0),
                            FadeAnimation(
                              1.4,
                              _buildInfoCard(
                                  'Monatant TTc', '${widget.montantTTC}', ''),
                            )
                          ],
                        )),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(25.0),
                                bottomRight: Radius.circular(25.0)),
                            color: Color(0xFF7A9BEE)),
                        height: 50.0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              String codeSanner =
                                  await BarcodeScanner.scan(); //barcode scnner
                              setState(() {
                                qrCodeResult = codeSanner;
                              });
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ScanPage();
                                  },
                                ),
                              );*/
                            },
                            child: Text('Scan Product',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat')),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
          ])
        ]));
  }

  Widget _buildInfoCard(String cardTitle, String info, String unit) {
    return InkWell(
        onTap: () {
          selectCard(cardTitle);
        },
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color:
                  cardTitle == selectedCard ? Color(0xFF7A9BEE) : Colors.white,
              border: Border.all(
                  color: cardTitle == selectedCard
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 0.75),
            ),
            height: 100.0,
            width: 150.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                    child: Text(cardTitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color: cardTitle == selectedCard
                              ? Colors.white
                              : Colors.grey.withOpacity(0.7),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(info,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: cardTitle == selectedCard
                                    ? Colors.white
                                    : Color(0xFF7A9BEE),
                                fontWeight: FontWeight.normal)),
                        Text(unit,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: cardTitle == selectedCard
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                  )
                ])));
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}
