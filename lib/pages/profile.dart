import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../UI_Model/Theme.dart';
import '../model/customer.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late Future<Customers> futureCustomer;
  @override
  void initState() {
    super.initState();
    futureCustomer = GetCustomerDetails();
  }

  logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Login()));
  }
  Future<Customers> GetCustomerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailValue = prefs.getString('email');

    final response = await http.get(Uri.parse(("${Env.URL_PREFIX}/get_customer_details.php?email=$emailValue")));
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body) as List;
      debugPrint(response.body);
      return Customers.fromJson(res[0]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Expanded(
                child: Text("CUSTOMER PROFILE",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(' '),
                  GestureDetector(
                    onTap: () {
                      //logout();
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
          backgroundColor: Colors.deepOrangeAccent,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: Icon(Icons.arrow_back),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(children: <Widget>[

          Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                     image: AssetImage("assets/profile-screen-bg-min.png"),

                      fit: BoxFit.fitWidth)
              )
          ),


    FutureBuilder<Customers>(
    future: futureCustomer,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    return SafeArea(
            child: ListView(children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, top: 74.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrangeAccent,
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset:
                              Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: .0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 85.0, bottom: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                          color: Colors.deepOrangeAccent,
                                                borderRadius:
                                                BorderRadius.circular(3.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.deepOrangeAccent
                                                        .withOpacity(0.3),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),

                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 40.0),
                                         Align(
                                          child: Text(snapshot.data!.cust_name,
                                              style: const TextStyle(
                                                  color: const Color.fromRGBO(
                                                      50, 50, 93, 1),
                                                  fontSize: 28.0)),
                                        ),
                                        const SizedBox(height: 10.0),

                                          Align(

                                                 child: Text(snapshot.data!.email,
                                              style: const TextStyle(
                                                  color: const Color.fromRGBO(
                                                      50, 50, 93, 1),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w200)),
                                        ),
                                        const Divider(
                                          height: 40.0,
                                          thickness: 1.5,
                                          indent: 32.0,
                                          endIndent: 32.0,
                                        ),
                                         Padding(
                                          padding: const EdgeInsets.only(
                                              left: 32.0, right: 32.0),
                                          child: Align(
                                            child: Text(
                                                snapshot.data!.cust_name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        82, 95, 127, 1),
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                    FontWeight.w200)
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15.0),
                                         Align(
                                            child: Text(
                                                snapshot.data!.phone,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        82, 95, 127, 1),
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                    FontWeight.w200)
                                            ),
                                        ),
                                        const SizedBox(height: 15.0),

                                        Text(
                                            snapshot.data!.address,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    82, 95, 127, 1),
                                                fontSize: 17.0,
                                                fontWeight:
                                                FontWeight.w200)
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                                              FractionalTranslation(
                          translation:  const Offset(0.0, -0.5),
                          child: Align(
                            child:  CircleAvatar(
                               backgroundImage: NetworkImage(
                                   "${Env.URL_PREFIX}/${snapshot.data!.photo}"
                               ),
                              radius: 55,
                            ),
                            alignment: const FractionalOffset(0.5, 0.0),
                          )
                      )

                    ]
                    ),
                  ],
                ),
              ),
            ]),
          );
    }else{
      return const CircularProgressIndicator();
    }
    }
    )
        ]
        )
    );
  }
}
