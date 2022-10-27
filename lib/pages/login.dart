import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_payment_system/UI_Model/Theme.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_payment_system/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/customer.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  TextEditingController txtemail_f = TextEditingController();
  TextEditingController txtpassword_f = TextEditingController();

  Future login() async {
    var url = "${Env.URL_PREFIX}/login.php";

    var response = await http.post(Uri.parse(url), body: {
      "txtemail": txtemail_f.text,
      "txtpassword": txtpassword_f.text,
    });
    var data = json.decode(response.body);
    if (data == "Success") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', txtemail_f.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Invalid Login details",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 3,
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
              children: const [
                Expanded(
                  child: Text(
                    "",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: Colors.deepOrangeAccent,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(Icons.arrow_back),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 700,
              color: Colors.deepOrangeAccent[200],
              alignment: Alignment.center,
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 24.0, right: 24.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: const BoxDecoration(
                                  color: ArgonColors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5,
                                          color: ArgonColors.muted))),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: const [
                                  Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text("Customer Login Form",
                                            style: TextStyle(
                                                color: ArgonColors.text,
                                                fontSize: 16.0)),
                                      )),

                                  // Divider()
                                ],
                              )),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.63,
                              color: const Color.fromRGBO(244, 245, 247, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children:  [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Email:',
                                              ),
                                               controller:   txtemail_f,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Password',
                                              ),
                                               controller:   txtpassword_f,
                                              obscureText: true,

                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: TextButton(
                                              child: Text(
                                                "Not Yet a Customer, Register Here >>",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              onPressed: ()  {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const RegisterCustomer()),
                                                );
                                              },
                                            ),
                                          ),
                                        ],

                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 60,

                                                  // elevated button created and given style
                                                  // and decoration properties
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.deepOrangeAccent,

                                                        shape: const StadiumBorder()),
                                                    onPressed: () {
                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      // we had used future delayed to stop loading after
                                                      // 3 seconds and show text "submit" on the screen.
                                                      Future.delayed(const Duration(seconds: 5), (){
                                                        setState(() {
                                                          isLoading = true;
                                                          login();
                                                          isLoading = false;
                                                        });
                                                      }
                                                      );
                                                    }, child:  isLoading? Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,

                                                    // as elevated button gets clicked we will see text"Loading..."
                                                    // on the screen with circular progress indicator white in color.
                                                    //as loading gets stopped "Submit" will be displayed
                                                    children: const [
                                                      Text('Loading...', style: TextStyle(fontSize: 15),),
                                                      SizedBox(width: 10,),
                                                      CircularProgressIndicator(color: Colors.white,),
                                                    ],
                                                  ) : const Text('Login',style: TextStyle(fontSize: 15)),

                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      )),
                ),
              ]),
            )
          ],
        ));
  }
}
