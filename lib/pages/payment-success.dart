import 'package:flutter/material.dart';
import 'package:customer_version_qrcode_payment_system/pages/dashboard.dart';
import 'dashboard.dart';


class PaymentSuccess extends StatefulWidget {
  const   PaymentSuccess({Key? key}) : super(key: key);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}
class _PaymentSuccessState extends State<PaymentSuccess> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            )
          ],
          elevation: 0,
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: success());

  }

  Widget success(){
    return Container(

        width: double.infinity,
        height: double.infinity,
        color: Colors.deepOrangeAccent,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          //  scrollDirection: Axis.horizontal,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                const <Widget>[

                  Padding(
                    padding: EdgeInsets.only(left: 35.0,top: 170.0,right: 16.0, bottom: 0),

                    child: Icon(Icons.check_circle,
                        size: 120,
                        color: Colors.green
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 35.0,top: 0.0,right: 16.0, bottom: 200),
                    child:   Text('Payment Successful',
                        textAlign: TextAlign.center,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                    //   )
                  )
                ]
            )
        )
    );

  }
}