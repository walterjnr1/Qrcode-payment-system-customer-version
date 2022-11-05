import 'package:flutter/material.dart';
import 'package:customer_version_qrcode_payment_system/pages/pay.dart';
import 'package:customer_version_qrcode_payment_system/pages/paymenthistory.dart';
import 'package:customer_version_qrcode_payment_system/pages/profile.dart';
import 'package:customer_version_qrcode_payment_system/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/customer.dart';
import '../widgets/slider.dart';
import 'package:customer_version_qrcode_payment_system/pages/fundwallet.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  final formatBalance  = NumberFormat("#,###", "en_US");

  late Future<Customers> futureCustomer;
  @override
  void initState() {
    super.initState();
    futureCustomer = getcustomerdetails();
  }

  logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Login()));
  }

  Future<Customers> getcustomerdetails() async {
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
          children: const [
            Expanded(child:Text("CUSTOMER DASHBOARD",
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
            ),
          ],
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(7),
        child: Column(
            children: [
            CarouselSliderSection,
            const SizedBox(height: 11),
            ]//<------
        ),
      ),
      drawer: Container(
      width: 250,
    child: Drawer(
        child: FutureBuilder<Customers>(
            future: futureCustomer,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                accountName:  Text(snapshot.data!.cust_name),
                accountEmail:  Text("Balance: ${NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 2).format(int.parse(snapshot.data!.balance))}"),
               currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      // "https://protocoderspoint.com/wp-content/uploads/2019/10/mypic-300x300.jpg",
                      "${Env.URL_PREFIX}/${snapshot.data!.photo}",
                      width: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.deepOrangeAccent,
                ),
              ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Sign Up'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RegisterCustomer()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('Fund Wallet'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CheckOutPage(passed_name: snapshot.data!.cust_name,passed_phone: snapshot.data!.phone,passed_email: snapshot.data!.email,)));

              },
              ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Payment History'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PaymentHistory()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.euro),
              title: const Text('Pay'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Pay()));

              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_box_outlined),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Profile()));

              },

            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('logout'),
              onTap: () {
                logout();
              },

            ),
          ],
        );
              }else{
                return const CircularProgressIndicator();
              }
            }
        ),
      ),
      )
    );
  }
}
