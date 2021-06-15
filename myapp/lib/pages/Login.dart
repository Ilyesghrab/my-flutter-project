import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Outils/rounded_button.dart';
import 'package:myapp/WS/InventaireWs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String user;
  String pass;
  String codeSanner;
  final passwordcontroller = TextEditingController();
  final logincontroller = TextEditingController();
  final statuscontroller = TextEditingController();
  final GlobalKey<FormState> fkey = GlobalKey<FormState>();
  bool ci = true;
  String login = "login";
  String statut = "status";
  String username = "username";

  //Scan**************
  Future<String> getlog() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _address = sp.getString("Login");

    return _address;
  }

  Future<String> getstat() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _ns = sp.getString("Statut");
    return _ns;
  }

  Future<String> getusername() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _ins = sp.getString("Username");
    return _ins;
  }

  @override
  void initState() {
    super.initState();
    getlog().then(updateLog);
    getstat().then(updateStat);
    getusername().then(updatUser);
    super.initState();
  }

  void updateLog(String _add) {
    setState(() {
      this.login = _add;
    });
  }

  void updateStat(String _add) {
    setState(() {
      this.statut = _add;
    });
  }

  void updatUser(String _add) {
    setState(() {
      this.username = _add;
    });
  }

  //scan******

  void visibility() {
    setState(() {
      ci = !ci;
    });
  }

  Widget textfield({@required String hintText}) {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: TextFormField(
          decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: hintText,
              hintStyle: TextStyle(
                letterSpacing: 2,
                color: Colors.black54,
                fontWeight: FontWeight.w800,
              ),
              fillColor: Colors.grey[50],
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  /*Widget _buildName() {
    return TextFormField(
      enableSuggestions: true,
      controller: logincontroller,
      decoration: InputDecoration(
          hintText: login,
          labelText: 'Login',
          icon: Icon(Icons.person),
          hintStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.grey[50],
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none)),
      maxLength: 16,
      validator: (String value) {
        if (value.isEmpty) {
          return 'login is Required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {
        user = value;
      },
    );
  }*/

  /*Widget _buildStatus() {
    return TextFormField(
      enableSuggestions: true,
      controller: statuscontroller,
      decoration: InputDecoration(
          hintText: statut,
          labelText: 'status',
          icon: Icon(Icons.online_prediction),
          hintStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.grey[50],
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none)),
      maxLength: 1,
      validator: (String value) {
        if (value.isEmpty) {
          return 'login is Required';
        }
        String s;
        value = value.trim();

        return null;
      },
      onSaved: (String value) {
        user = value;
      },
    );
  }*/

  Widget _buildPassword() {
    return TextFormField(
      obscureText: ci,
      controller: passwordcontroller,
      decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            fontWeight: FontWeight.normal,
          ),
          icon: Icon(Icons.lock),
          suffixIcon: InkWell(
            onTap: visibility,
            child: Icon(ci ? Icons.visibility_off : Icons.visibility),
          ),
          fillColor: Colors.grey[50],
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none)),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (String value) {
        pass = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/wallpaper.PNG"),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 35,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.lightBlue[100], width: 3),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/Capture1.PNG")),
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 370,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textfield(
                            hintText: "Login : $login",
                          ),
                          /*textfield(
                            hintText: username,
                          ),*/
                          textfield(
                            hintText: "Statut : $statut",
                          ),
                          /* Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildStatus(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildName(),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildPassword(),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: RoundedButton(
                              text: "LogIn",
                              fontSize: 20,
                              press: () async {
                                //String login =
                                // logincontroller.value.text.trim();
                                String pwd = passwordcontroller.value.text;
                                // String status =
                                // statuscontroller.value.text.trim();
                                String config = "<cab:login>" +
                                    login +
                                    "</cab:login><cab:pw>" +
                                    pwd +
                                    "</cab:pw><cab:statut>" +
                                    statut +
                                    "</cab:statut>" +
                                    "<cab:userName></cab:userName>";
                                var ws = InventaireWs(config, "user");

                                ws.signIn(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*Future<void> Qr_scan() async {
    List<String> fh;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String codeSanner = await BarcodeScanner.scan(); //barcode scnner
    setState(() {
      this.codeSanner = codeSanner == "-1" ? "login" : codeSanner;
      fh = codeSanner.split("/");
      login = fh[0];
      statut = fh[1];
      username = fh[2];
      sp.setString("Login", login);
      sp.setString("Statut", statut);
      sp.setString("Username", username);
      // qrCodeResult = codeSanner;
      print(sp.toString());
    });
    return {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      )
    };
  }*/
}
