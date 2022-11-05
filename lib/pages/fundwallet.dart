import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:customer_version_qrcode_payment_system/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../model/customer.dart';


class CheckOutPage extends StatefulWidget {
  final String passed_name,passed_phone,passed_email;
  const CheckOutPage({Key? key, required this.passed_name, required this.passed_phone, required this.passed_email}) : super(key: key);
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}
class _CheckOutPageState extends State<CheckOutPage> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
 // final currencyController = TextEditingController();
 final currencyController = "NGN";

  //final narrationController = TextEditingController();
  //final publicKeyController = TextEditingController();
  final publicKeyController = "FLWPUBK_TEST-2c7a9c3062c7ef43c062e7c1a0463bd1-X";

  // final publicKeyController = TextEditingController(text: "FLWPUBK_TEST-2c7a9c3062c7ef43c062e7c1a0463bd1-X");
    //final encryptionKeyController = TextEditingController();
  //final emailController = TextEditingController();
  //final emailController = TextEditingController(text: "newleastpaysolution@gmail.com");
 // final emailController = widget.passed_email;

  // final phoneNumberController = TextEditingController();
 // final phoneNumberController = TextEditingController(text: "08067361023");

  String selectedCurrency = "";

  bool isTestMode = true;
  final pbk = "FLWPUBK_TEST";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutterwave Payment'),
        backgroundColor: Colors.deepOrangeAccent,
        elevation:0,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[

              Container(
                width: double.infinity,
                height: 70,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: amountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(hintText: "Amount"),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Amount is required",
                ),
              ),
              Container(
                width: double.infinity,
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: ElevatedButton(
                  onPressed: _onPressed,
                  child: const Text('Start Payment'),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(240, 80),
                      primary: Colors.deepOrangeAccent),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onPressed() {
    if (this.formKey.currentState!.validate()) {
      this._handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {
    final style = FlutterwaveStyle(
      appBarText: "FlutterWave Payment",
      buttonColor: Colors.deepOrangeAccent,
      buttonTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      appBarColor:  Colors.deepOrangeAccent,
      dialogCancelTextStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      dialogContinueTextStyle: const TextStyle(
        color: Colors.green,
        fontSize: 15,

      ),
      mainBackgroundColor: Colors.white,
      mainTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15.5,
          letterSpacing: 2
      ),
      dialogBackgroundColor: Colors.white54,
      appBarIcon: const Icon(Icons.euro, color: Colors.white),
      buttonText: "Pay NGN${amountController.text}",

      // NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 2).format(amountController.text)

      appBarTitleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );

    final Customer customer = Customer(
        name: widget.passed_name,
        phoneNumber: widget.passed_phone,
        email: widget.passed_email
    );

    final subAccounts = [
      SubAccount(id: "RS_1A3278129B808CB588B53A14608169AD", transactionChargeType: "flat", transactionPercentage: 25),
      SubAccount(id: "RS_C7C265B8E4B16C2D472475D7F9F4426A", transactionChargeType: "flat", transactionPercentage: 50)
    ];

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        style: style,
        publicKey: this.publicKeyController.toString().trim().isEmpty
            ? this.getPublicKey()
            : this.publicKeyController.toString().trim(),
        currency: 'NGN',
        redirectUrl: "https://google.com",
        txRef: Uuid().v1(),
        amount: amountController.text.toString().trim(),
        customer: customer,
        // subAccounts: subAccounts,
        paymentOptions: "card, payattitude, barter",
        customization: Customization(title: "Test Payment"),
        isTestMode: false);
    final ChargeResponse response = await flutterwave.charge();
    if (response != null) {
      showLoading(response.status.toString());
      print("${response.toJson()}");
    } else {
      showLoading("No Response!");
    }
  }

  String getPublicKey() {
    if (isTestMode) return "FLWPUBK_TEST-895362a74986153380262d89bfdc9b8a-X";
    // "FLWPUBK_TEST-02b9b5fc6406bd4a41c3ff141cc45e93-X";
    return "FLWPUBK-aa4cd0b443404147d2d8229a37694b00-X";
  }


  Future<Customers> fundwallet(BuildContext context) async {
    String amt;
    amt = amountController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailValue = prefs.getString('email');
    final response = await http.put(
      Uri.parse(
          '${Env.URL_PREFIX}/fund_customer_balance.php?amt=$amt&email=$emailValue'),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Dashboard()));
      return Customers.fromJson(jsonDecode(response.body));
    } else {
// If the server did not return a 200 OK response,
// then throw an exception.
      throw Exception('Failed to update album.');
    }
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Icon(Icons.check_circle),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontStyle: FontStyle.normal),
              ),
              onPressed: () => fundwallet(context),

            ),
          ],
        );
      },
    );
  }
}

