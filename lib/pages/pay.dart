import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:customer_version_qrcode_payment_system/pages/payment-success.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/customer.dart';

class Pay extends StatefulWidget {
  const Pay({Key? key}) : super(key: key);

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {

  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  bool gotValidQR = false; //toggle this value when you got a new qr code

  Future<Customers> updateCustomersBalance(event) async {

    //get email
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailValue = prefs.getString('email');

    String amt, username;

    //split and replace qrcode string
    String? str = result!.code;
    List<String> strarray = str!.split(' ');

     var amtxx=strarray[0].toString().replaceAll("[", " ") ;
     amt=amtxx.toString().replaceAll(",", " ") ;
    username=strarray[1].toString().replaceAll("]", " ");


    print(amt);
    print(username);

    final response = await http.post(Uri.parse("${Env.URL_PREFIX}/update_customer_balance.php?amt=$amt&email=$emailValue&amt_user=$amt&username=$username"),);
    if (response.statusCode == 200) {
      return Customers.fromJson(jsonDecode(response.body));

    } else {
// If the server did not return a 200 OK response,
// then throw an exception.
      throw Exception('Failed to update Balance.');
    }
  }


  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  void qr(QRViewController controller) {
    this.controller = controller;
      controller.scannedDataStream.listen((event)async {
        setState(() {
      result = event;
        updateCustomersBalance(result!.code);
      controller.pauseCamera();

        }
       );

      if(gotValidQR) {
        return;
      }
      gotValidQR = true;
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PaymentSuccess()));
      gotValidQR  = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QRcode Scanner"),

        elevation: 0,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: QRView(key: _gLobalkey, onQRViewCreated: qr),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: result != null
                    ? const Text('Qrcode Data Received ...')
                : const Text('Scan a code again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
