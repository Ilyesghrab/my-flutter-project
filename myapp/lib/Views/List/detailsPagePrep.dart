import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Outils/AnimatedFlipCounter.dart';
import 'package:myapp/Outils/FadeAnimation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DetailsPagePrep extends StatefulWidget {
  final designation;
  final quantityPrep;
  final quatite;
  final reference;

  DetailsPagePrep(
      {this.designation, this.quantityPrep, this.quatite, this.reference});

  @override
  _DetailsPagePrepState createState() => _DetailsPagePrepState();
}

class _DetailsPagePrepState extends State<DetailsPagePrep> {
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
                    tag: widget.designation,
                    child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFF7A9BEE), width: 3),
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage("assets/images/jante.jpg"),
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
                      Text(widget.designation,
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
                          Text("Qte: ${widget.quatite}",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20.0,
                                  color: Colors.grey)),
                        ),
                        Container(height: 25.0, color: Colors.grey, width: 1.0),
                        FadeAnimation(
                          1.4,
                          Text("Ref: ${widget.reference}",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20.0,
                                  color: Colors.grey)),
                        ),
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
                              _buildInfoCard(
                                  'Designation', '${widget.designation}', ''),
                            ),
                            SizedBox(width: 10.0),
                            FadeAnimation(
                              1.4,
                              _buildInfoCard(
                                  'Reference', '${widget.reference}', ''),
                            ),
                            SizedBox(width: 10.0),
                            FadeAnimation(
                                1.4,
                                _buildInfoCard(
                                    'Quantit??', '${widget.quatite}', '')),
                            SizedBox(width: 10.0),
                            FadeAnimation(
                              1.4,
                              _buildInfoCard('Quantit?? Prepar??',
                                  '${widget.quantityPrep}', ''),
                            )
                          ],
                        )),
                    SizedBox(height: 20.0),
                    FadeAnimation(
                      1.4,
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: buildPercent(),
                        /*child: Container(
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
                                  
                                },
                                child: Text('Scan Product',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat')),
                              ),
                                ),
                          ),*/
                      ),
                    ),
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
            width: 100.0,
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

  Widget buildPercent() {
    double sum =
        (double.parse(widget.quantityPrep) / double.parse(widget.quatite));
    int p = (sum * 100).round();
    Color c;
    if ((p >= 0) && (p <= 10))
      c = Color(0xFF7A9BEE);
    else if ((p > 10) && (p <= 20))
      c = Color(0xFF7A9BEE);
    else if ((p > 20) && (p <= 40))
      c = Color(0xFF7A9BEE);
    else if ((p > 40) && (p <= 50))
      c = Color(0xFF7A9BEE);
    else if ((p > 50) && (p <= 60))
      c = Color(0xFF7A9BEE);
    else if ((p > 60) && (p <= 70))
      c = Color(0xFF7A9BEE);
    else if ((p > 70) && (p <= 80))
      c = Color(0xFF7A9BEE);
    else if ((p > 80) && (p <= 90))
      c = Color(0xFF7A9BEE);
    else if ((p > 90) && (p <= 100)) c = Color(0xFF7A9BEE);
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1500,
      lineHeight: 25,

      //radius: 50.0,
      //lineWidth: 5.0,
      percent: sum,
      center: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedFlipCounter(
            duration: Duration(milliseconds: 1200),
            value: p,
            /* pass in a number like 2014 */
            color: Colors.black,
            size: 13,
          ),
          Text("%")
        ],
      ), //new Text("$p%"),
      progressColor: c,
    );
  }
}
