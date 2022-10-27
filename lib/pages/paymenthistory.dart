import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/payment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show get;


class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<Payment> payments = [];
  late Future<List<Payment>> payment;

  //final productListKey = GlobalKey<ProductListState>();
  @override
  void initState() {
    super.initState();
    payment = getPaymenthistory();
  }

  Future<List<Payment>> getPaymenthistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailValue = prefs.getString('email');
    final response = await http.get(Uri.parse(
        ("${Env.URL_PREFIX}/fetch_payment_history.php?customer_email=$emailValue")));

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Payment> payment = items.map<Payment>((json) {
      return Payment.fromJson(json);
    }).toList();
    setState(() {
      payments = payment;
    });
    return payment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payment History',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepOrangeAccent,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.deepOrangeAccent,
              radius: 30,
              child: Icon(Icons.arrow_back),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Center(
            child: SingleChildScrollView(
                        child: Column(
                    children: [
                       ListView.separated(
                           separatorBuilder: (context, index) => const Divider(
                             color: Colors.black,
                           ),
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric( vertical: 10.0, horizontal: 8.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: payments.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data =payments[index];
                        return Container(
                          padding:
                              const EdgeInsets.fromLTRB(14.0, 1.0, 2.0, 7.4),
                          height: 90,
                          color: Colors.deepOrange[50],
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4.0,
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Payment ID : ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0),
                                    children: [
                                      TextSpan( text:'${data.paymentID}\n',
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w100
                                          )
                                      ),
                                    ]
                                ),
                              ),

                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Restaurant : ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0),
                                    children: [
                                      TextSpan( text:'${data.restuarant}\n',
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w100
                                          )
                                      ),
                                    ]
                                ),
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Amount : ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0),
                                    children: [
                                      TextSpan( text:'${NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 2).format(int.parse(data.amount))}\n',
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w100
                                          )
                                      ),
                                    ]
                                ),
                              ),
                               RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Date : ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0),
                                    children: [
                                      TextSpan( text:'${data.date_payment}\n',
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w100
                                          )
                                      ),
                                    ]
                                ),
                              ),
                            ],

                          ),
                        );
                      })
                ]
                )
            )
        )
    );
  }
}
