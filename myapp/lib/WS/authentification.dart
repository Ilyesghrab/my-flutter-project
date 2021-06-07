import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:expedition/globals.dart' as globals;

class ServiceAuthentification
{
  String username;
  String password;
  ServiceAuthentification(this.username,this.password);

  Future<int> authenticate() async
  {
    var envelope = '''
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:exp="urn:microsoft-dynamics-schemas/codeunit/ExpeditionMobile">
   <soapenv:Header/>
   <soapenv:Body>
      <exp:LogIn>
         <exp:login>$username</exp:login>
         <exp:pw>$password</exp:pw>
         <exp:statut>1</exp:statut>
         <exp:userName></exp:userName>
      </exp:LogIn>
   </soapenv:Body>
</soapenv:Envelope>
    ''';

    print(envelope);
    //print(client.toString());
    print(globals.url);
    http.Response response = await globals.client.post(
        globals.url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/ExpeditionMobile:LogIn",
        },
        body: envelope
    );
    //if (res.statusCode==401)
    if (response.statusCode == 401)
    {
      return 401;
    }
    print("res.statusCode ==> ${response.statusCode}");
    print("res.reasonPhrase ==> ${response.reasonPhrase}");
    print("res.statusCode ==> ${response.body}");

    var storeDocument = xml.parse(response.body);
    var StatusXML = storeDocument
        .findAllElements('statut')
        .first;

    var usernameXML = storeDocument
        .findAllElements('userName')
        .first;
    print(usernameXML.text);
    globals.username=usernameXML.text;
    globals.login=this.username;
    print("LOGIN = ${globals.login}");
    if (StatusXML=="")
    {
      return -1;
    }
    return int.parse(StatusXML.text);
  }

}