import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/class/docrequest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:project/menu.dart';
import 'package:xml/xml.dart';
import 'login.dart';
import '../class/task.dart';
import '../class/employee.dart';
import '../class/ooorequest.dart';
import '../class/ooorequest.dart';
import '../class/typeconge.dart';

class ConnectWS {
  String ip = "192.168.1.16";
  String config;
  String nomtable;
  ConnectWS(this.config, this.nomtable);
  String getvalue(String ch) {
    String ch1;
    if (ch.length != null) {
      if (ch.substring(ch.indexOf(">")).length == 1)
        return "";
      else {
        ch1 = ch.substring(ch.indexOf(">") + 1);

        return ch1.length == 0 ? null : ch1.substring(0, ch1.indexOf("<"));
      }
    } else
      return null;
  }

  List<String> getffvalue(List<XmlElement> a) {
    List<String> r;
    for (int i = 0; i < a.length; i++) {
      a[i].toString();
      r.add(getvalue(a[i].toString()));
    }
    return r;
  }

  Future<List<Login>> login(BuildContext context) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    /*String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String ws = sharedPrefs.getString('WS');
    String namespace = sharedPrefs.getString('NameSpace');*/
    String no = sharedPrefs.getString("no");

    String port = "9097";
    String ws = "WSHRVision.asmx";
    String namespace = "HRVision";

    var envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope =
        envelope + "<Login xmlns=\"" + namespace + "\">" + config + "</Login>";
    envelope = envelope + "</soap:Body> </soap:Envelope>";
    try {
      //String external = await FlutterIp.externalIP;
      //print(external);

      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/Login",
            "Host": ip + ":" + port,
          },
          body: envelope);
      var parse = xml.parse(response.body);
      var raw = parse;
      // Partie conditionnelle //
      var elements = raw.findAllElements('SearchName');

      if (elements.isEmpty) {
        Fluttertoast.showToast(
            msg: "login ou mot de passe incorrecte !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);

        return null;
      } //
      else {
        /* Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          //String searchname =
             // raw.findAllElements('SearchName').first.firstChild.text;
          //  String adresse=raw.findAllElements('Address').first.firstChild.text;*/

        Navigator.pushReplacementNamed(context, "/menu", arguments: {"no": no});
        /*return Menu(); //wsParameters();
        }));*/
      }
      /* return elements.map((element){
    return Login(element.findElements("SearchName").first.text
      );
    }).toList();*/

    } catch (ex) {
      Fluttertoast.showToast(
          msg: "Problème de connection !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<Employee> employeeselect() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    /*String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String ws = sharedPrefs.getString('WS');
    String namespace = sharedPrefs.getString('NameSpace');*/

    String port = "9097";
    String ws = "WSHRVision.asmx";
    String namespace = "HRVision";
    String no = sharedPrefs.getString('no');

    var envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope = envelope +
        "<" +
        this.nomtable +
        " xmlns=\"" +
        namespace +
        "\">" +
        config +
        "</" +
        this.nomtable +
        ">";
    envelope = envelope + "</soap:Body> </soap:Envelope>";
    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/" + this.nomtable,
            "Host": ip + ":" + port,
          },
          body: envelope);
      var parse = xml.parse(response.body);
      var raw = parse;
      // Partie conditionnelle //
      var email = getvalue(raw.findAllElements('CompanyEmail').toString());
      var searchname = getvalue(raw.findAllElements('SearchName').toString());
      var img = getvalue(raw.findAllElements("Image").toString());
      var grid = getvalue(raw.findAllElements('GroupApproverId').toString());
      var jobdesc = getvalue(raw.findAllElements('JobDescription').toString());
      var id = getvalue(raw.findAllElements('No').toString());
      var FirstName = getvalue(raw.findAllElements('FirstName').toString());
      var LastName = getvalue(raw.findAllElements('LastName').toString());
      var Address = getvalue(raw.findAllElements('Address').toString());
      var city = getvalue(raw.findAllElements('City').toString());
      var mobilenumber =
          getvalue(raw.findAllElements('MobilePhoneNo').toString());
      var pass = getvalue(raw.findAllElements('Password').toString());
      var blncdys = getvalue(raw.findAllElements('BalanceDays').toString());
      var blnchours = getvalue(raw.findAllElements('BalanceHours').toString());
      var drtconge = getvalue(raw.findAllElements('DroitCongé').toString());
      Employee e = Employee(
          id,
          FirstName,
          LastName,
          searchname,
          email,
          Address,
          city,
          grid,
          blncdys,
          blnchours,
          drtconge,
          "birthdate",
          "personalnumbe",
          mobilenumber,
          img,
          jobdesc,
          pass);
      if (searchname.isEmpty) {
        Fluttertoast.showToast(
            msg: "employee introuvable!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);

        return null;
      } //
      else {
        print(e.searchname);
        return e;
      }
      /* return elements.map((element){
    return Login(element.findElements("SearchName").first.text
      );
    }).toList();*/

    } catch (ex) {
      Fluttertoast.showToast(
          msg: "Problème de connection !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<Task> detailedtask() async {
    // SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    /*String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String ws = sharedPrefs.getString('WS');
    String namespace = sharedPrefs.getString('NameSpace');*/

    String port = "9097";
    String ws = "WSHRVision.asmx";
    String namespace = "HRVision";

    var envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope = envelope +
        "<" +
        this.nomtable +
        " xmlns=\"" +
        namespace +
        "\">" +
        config +
        "</" +
        this.nomtable +
        ">";
    envelope = envelope + "</soap:Body> </soap:Envelope>";
    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/" + this.nomtable,
            "Host": ip + ":" + port,
          },
          body: envelope);
      var parse = xml.parse(response.body);

      var raw = parse;

      String desc = getvalue(raw.findAllElements("Detail").toString());

      String begindate = getvalue(raw.findAllElements("BeginDate").toString());
      String enddate = getvalue(raw.findAllElements("EndDate").toString());
      String nbh = getvalue(raw.findAllElements("NbOfHours").toString());
      String nbd = getvalue(raw.findAllElements("NbOfDays").toString());
      Task t = new Task("id", "type", "desc", "emid", "emjob", "reqdate", desc,
          begindate, enddate, nbd, nbh, "reqid");
      return t;
    } catch (ex) {
      Fluttertoast.showToast(
          msg: "$ex",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<List<Task>> appr() async {
    /*String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String ws = sharedPrefs.getString('WS');
    String namespace = sharedPrefs.getString('NameSpace');*/
    List<Task> a = List<Task>();
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String port = "9097";
    String ws = "WSHRVision.asmx";
    String namespace = "HRVision";
    String no = sharedPrefs.getString('no');
    String r;
    var envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope = envelope +
        "<" +
        this.nomtable +
        " xmlns=\"" +
        namespace +
        "\">" +
        config +
        "</" +
        this.nomtable +
        ">";
    envelope = envelope + "</soap:Body> </soap:Envelope>";
    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/" + this.nomtable,
            "Host": ip + ":" + port,
          },
          body: envelope);
      var parse = xml.parse(response.body);
      var raw1 = parse;

      xml.XmlElement x, raw;

      List<Task> tasks = new List<Task>();
      // Partie conditionnelle //
      List<xml.XmlElement> test = raw1.findAllElements('Task').toList();

      for (int i = 0; i < test.length; i++) {
        raw = test[i];
        String reqdate = raw.getElement('RequestDate').toString();
        reqdate = getvalue(reqdate);
        String id = getvalue(raw.getElement('TaskId').toString());
        String reqid = getvalue(raw.getElement("RequestId").toString());
        String type = getvalue(raw.getElement('TaskType').toString());
        String desc = getvalue(raw.getElement('Description').toString());

        String emid = getvalue(raw.getElement('ApplicantEmpId').toString());
        ConnectWS ws = new ConnectWS("<No>$emid</No>", "SelectEmployeeByNo");
        ConnectWS wst = new ConnectWS(
            "<EmployeeId>" +
                emid +
                "</EmployeeId><OOOReqId>" +
                reqid +
                "</OOOReqId>",
            "GetDetailsOOORequests");
        Employee emp = await ws.employeeselect();
        Task td = await wst.detailedtask();

        Task t = new Task(id, type, desc, emp.searchname, emp.jobdesc, reqdate,
            td.detail, td.begindate, td.enddate, td.nbdays, td.nbh, reqid);

        tasks.add(t);
      }

      if (true) {
        return tasks;
      } //
      else {
        print("groupvvvvvvvvvv");
        return a;
      }
      /* return elements.map((element){
    return Login(element.findElements("SearchName").first.text
      );
    }).toList();*/

    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "$ex",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  ///
////
  ///
  ///oooRequest select by no////
  ///
//
//

  Future<List<OOOrequest>> ooorequestselect() async {
    /*String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String ws = sharedPrefs.getString('WS');
    String namespace = sharedPrefs.getString('NameSpace');*/
    List<OOOrequest> a = List<OOOrequest>();

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    String port = "9097";
    String ws = "WSHRVision.asmx";
    String namespace = "HRVision";
    String no = sharedPrefs.getString('no');
    String r;
    var envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope = envelope +
        "<" +
        this.nomtable +
        " xmlns=\"" +
        namespace +
        "\">" +
        config +
        "</" +
        this.nomtable +
        ">";
    envelope = envelope + "</soap:Body> </soap:Envelope>";
    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/" + this.nomtable,
            "Host": ip + ":" + port,
          },
          body: envelope);
      var parse = xml.parse(response.body);
      var raw1 = parse;

      xml.XmlElement x, raw;

      List<OOOrequest> tasks = new List<OOOrequest>();
      // Partie conditionnelle //
      List<xml.XmlElement> test =
          raw1.findAllElements('MyOOORequests').toList();

      for (int i = 0; i < test.length; i++) {
        raw = test[i];
        String oooReqId = raw.getElement('OOOReqId').toString();
        oooReqId = getvalue(oooReqId);
        String oooId = getvalue(raw.getElement('OOOId').toString());
        String detail = getvalue(raw.getElement("Detail").toString());
        String reqStatusId = getvalue(raw.getElement('ReqStatusId').toString());
        String reqDetail = getvalue(raw.getElement('ReqDetail').toString());

        String singleDay = getvalue(raw.getElement('SingleDay').toString());
        String beginDate = getvalue(raw.getElement('BeginDate').toString());
        String beginPartOfDay =
            getvalue(raw.getElement('BeginPartOfDay').toString());
        String endDate = getvalue(raw.getElement('EndDate').toString());
        String endPartOfDay =
            getvalue(raw.getElement('EndPartOfDay').toString());
        String nbOfDays = getvalue(raw.getElement('NbOfDays').toString());
        String nbOfHours = getvalue(raw.getElement('NbOfHours').toString());
        String instruction = raw.getElement('Instruction').toString();
        instruction = getvalue(instruction);
        String description = getvalue(raw.getElement('Description').toString());
        OOOrequest t = new OOOrequest(
            oooReqId,
            oooId,
            detail,
            reqStatusId,
            reqDetail,
            singleDay,
            beginDate,
            beginPartOfDay,
            endDate,
            endPartOfDay,
            nbOfDays,
            nbOfHours,
            instruction,
            description);

        tasks.add(t);
      }

      if (true) {
        return tasks;
      } //
      else {
        print("groupvvvvvvvvvv");
        return a;
      }
      /* return elements.map((element){
    return Login(element.findElements("SearchName").first.text
      );
    }).toList();*/

    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "probleme de connexion !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

////doc selcet
  ///
  ////
  Future<List<Docrequest>> docrequestselect() async {
    /*String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String ws = sharedPrefs.getString('WS');
    String namespace = sharedPrefs.getString('NameSpace');*/
    List<Docrequest> a = List<Docrequest>();

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    String port = "9097";
    String ws = "WSHRVision.asmx";
    String namespace = "HRVision";
    String no = sharedPrefs.getString('no');
    String r;
    var envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope = envelope +
        "<" +
        this.nomtable +
        " xmlns=\"" +
        namespace +
        "\">" +
        config +
        "</" +
        this.nomtable +
        ">";
    envelope = envelope + "</soap:Body> </soap:Envelope>";
    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/" + this.nomtable,
            "Host": ip + ":" + port,
          },
          body: envelope);
      var parse = xml.parse(response.body);
      var raw1 = parse;

      xml.XmlElement x, raw;

      List<Docrequest> tasks = new List<Docrequest>();
      // Partie conditionnelle //
      List<xml.XmlElement> test =
          raw1.findAllElements('MyDocRequests').toList();

      for (int i = 0; i < test.length; i++) {
        raw = test[i];
        String oooReqId = raw.getElement('OOOReqId').toString();
        oooReqId = getvalue(oooReqId);
        String oooId = getvalue(raw.getElement('OOOId').toString());
        String detail = getvalue(raw.getElement("Detail").toString());
        String reqStatusId = getvalue(raw.getElement('ReqStatusId').toString());
        String reqdate = getvalue(raw.getElement('DateDemande').toString());
        String instruction = raw.getElement('Instruction').toString();
        instruction = getvalue(instruction);

        Docrequest t = new Docrequest(
            oooReqId, oooId, detail, reqStatusId, instruction, reqdate);

        tasks.add(t);
      }

      if (true) {
        return tasks;
      } //
      else {
        print("groupvvvvvvvvvv");
        return a;
      }
      /* return elements.map((element){
    return Login(element.findElements("SearchName").first.text
      );
    }).toList();*/

    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "$ex",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<List<Typeconge>> selecttypeconge() async {
    /*String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String ws = sharedPrefs.getString('WS');
    String namespace = sharedPrefs.getString('NameSpace');*/
    String port = "9097";
    String ws = "WSHRVision.asmx";
    String namespace = "HRVision";

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    String no = sharedPrefs.getString('no');
    String r;
    List<Typeconge> a = List<Typeconge>();
    var envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope =
        envelope + "<" + this.nomtable + " xmlns=\"" + namespace + "\"/>";
    envelope = envelope + "</soap:Body> </soap:Envelope>";
    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/" + this.nomtable,
            "Host": ip + ":" + port,
          },
          body: envelope);
      var parse = xml.parse(response.body);
      var raw1 = parse;

      xml.XmlElement x, raw;

      List<Typeconge> types = new List<Typeconge>();
      // Partie conditionnelle //
      List<xml.XmlElement> test = raw1.findAllElements('OutOfOffice').toList();
      for (int i = 0; i < test.length; i++) {
        raw = test[i];
        String oooId = getvalue(raw.getElement('OOOId').toString());
        String desc = getvalue(raw.getElement("Description").toString());
        Typeconge t = new Typeconge(oooId, desc);
        types.add(t);
      }
      return types;
    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "probleme de connexion",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<void> ooorequsetinsert() async {
    /*String ip = sharedPrefs.getString('AdresseIp');
    String port = sharedPrefs.getString('Port');
    String ws = sharedPrefs.getString('WS');
    String namespace = sharedPrefs.getString('NameSpace');*/
    String port = "9097";
    String ws = "WSHRVision.asmx";
    String namespace = "HRVision";
    print("here");
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    var envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> ";
    envelope =
        envelope + "<" + this.nomtable + " xmlns=\"" + namespace + "\"/>";
    envelope = envelope + "</soap:Body> </soap:Envelope>";
    try {
      var url = Uri.parse('http://' + ip + ':' + port + '/' + ws);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": namespace + "/" + this.nomtable,
            "Host": ip + ":" + port,
          },
          body: envelope);
      var parse = xml.parse(response.body);
      print(parse);
    } catch (ex) {
      print(ex);
      Fluttertoast.showToast(
          msg: "probleme de connexion",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }
}
