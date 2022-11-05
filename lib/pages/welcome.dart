import 'dart:async';
import 'package:flutter/material.dart';
import 'package:customer_version_qrcode_payment_system/pages/dashboard.dart';
import 'package:customer_version_qrcode_payment_system/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const   WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> {

  Future<String> getUser() async{
    await Future.delayed(const Duration(seconds: 7));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('email') ?? ""; /// since you are using username
    debugPrint("login in as $userToken");
    return userToken;
  }
  logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body:FutureBuilder<String>(
          future: getUser(),
          builder:((context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done){
              return splash();
            }else{
              if(snapshot.data==null || snapshot.data!.isEmpty){

                return const Login();
              }
              return  const Dashboard();
            }
          }),
        )
    );
  }
  Widget _textHeader(){
    return  const SizedBox(
      width: 1.0,
      height: 66.0,
    //  color: Colors.white70,
    );
  }
  Widget splash(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.deepOrangeAccent,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        Container(
      child: Padding(
          padding: const EdgeInsets.only(left: 35.0,top: 250.0,right: 16.0, bottom: 0),
        child: Container(
        height: 100.0,
        width: 100.0,

        decoration: const BoxDecoration(

          image: DecorationImage(

            image: AssetImage(
                'assets/logo.png'),
            //fit: BoxFit.fill,
          ),
          shape: BoxShape.circle,
        ),
      ),
    )
        ),
        const Padding(
        padding:  EdgeInsets.only(left: 35.0,right: 16.0, bottom: 40.0),
        child: SizedBox(
        width: double.infinity,
        child:   Text('Qr code Payment System - Customer version',
        textAlign: TextAlign.center,
        style:TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w200,
        )
        ),
        )
        )
      ]
    )
    );

  }
}