import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product.dart';
import '../model/searchproduct.dart';
import 'login.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  const ProductList({Key? key, ProductList}) : super(key: key);

  @override
  ProductListState createState() =>ProductListState();
}
class ProductListState extends State<ProductList> {
  final formatBalance  = NumberFormat("#,###", "en_US");

  TextEditingController txtsearch_f = TextEditingController();
  // String total_livestock = "0";
  List<Product> products = [];
  String query = '';

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Login()));
  }

  late Future<List<Product>> product;
  final productListKey = GlobalKey<ProductListState>();
  @override
  void initState() {
    super.initState();
    product = getProductList();
  }

  Future<List<Product>> getProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username_value = prefs.getString('username');
    final response = await http.get(Uri.parse(
        ("${Env.URL_PREFIX}/fetch_product.php?username=${username_value}")));

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product> product = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();
    setState(() {
      //total_livestock = "${livestock.length}";
      products = product;
    });

    return product;
  }
  Future<List<Product_search>> getProductList_search() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username_value = prefs.getString('username');
    final response = await http.get(Uri.parse(
        ("${Env.URL_PREFIX}/searchproduct.php?query=${txtsearch_f.text}&username=${username_value}")));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product_search> product_search =items.map<Product_search>((json) {
      return Product_search.fromJson(json);
    }).toList();
    setState(() {
      //   total_livestock = "${livestock_search.length}";
    });

    List<Product> product = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();
    setState(() {
      products = product;
    });

    return product_search;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Product List',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
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
                padding: const EdgeInsets.all(14),
                scrollDirection: Axis.vertical,
                child: Column(
                    children: [
                      Container(
                        height: 40.0,
                        padding: const EdgeInsets.fromLTRB(13.0, 2.0, 2.0, 2.0),
                        alignment: Alignment.center,
                        child: TextField(
                          onChanged: (query) {
                            getProductList_search();
                            setState(() {
                              txtsearch_f.text.isEmpty ? getProductList() : getProductList_search();
                            });
                          },
                          controller: txtsearch_f,
                          decoration: InputDecoration(
                              labelText: "Search",
                              hintText: "Search Livestock",
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  txtsearch_f.text="";
                                  setState(() {
                                    txtsearch_f.text.isEmpty ? getProductList() : getProductList_search();
                                  });
                                },
                                icon: const Icon(Icons.cancel),
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)
                                  )
                              )
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                      ),

                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),

                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = products[index];

                            //delete Product
                            void deleteProduct(context) async {
                              await http.post(
                                Uri.parse("${Env.URL_PREFIX}/delete_product.php"),
                                body: {
                                  'txtproduct_no': data.product_no.toString(),
                                },
                              );
                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const ProductList(),
                                ),
                              );
                            }
                            void confirmDelete(context) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const Text('Are you sure you want to delete this?'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Icon(Icons.cancel),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                      ElevatedButton(
                                        child: const Icon(Icons.check_circle),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        onPressed: () => deleteProduct(context),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            return Container(
                                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 7.4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children:  [
                                              Text(
                                                'Product No: ${data.product_no}',
                                                style: const TextStyle(
                                                  fontSize: 12.5,
                                                  //height: 3.5, //You can set your custom height here
                                                  color: Colors.black,
                                                ),
                                              ),

                                              Text(
                                                'Product Name: ${data.product_name}',
                                                style:  const TextStyle(
                                                  fontSize: 12.5,
                                                  //height: 3.5, //You can set your custom height here
                                                  color: Colors.black,
                                                ),
                                              ),

                                              Text(
                                                'Amount: N${data.amount}',
                                                style: const TextStyle(
                                                  fontSize: 12.5,
                                                  color: Colors.black,
                                                ),
                                              ),

                                              ButtonBar(
                                                alignment: MainAxisAlignment.spaceBetween,
                                                buttonPadding: const EdgeInsets.symmetric(),
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  TextButton.icon(
                                                    icon: const Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.black,
                                                      size: 14,
                                                    ),
                                                    label: const Text('Delete',
                                                        style: TextStyle(fontSize: 10, color: Colors.black)),
                                                    onPressed: () => confirmDelete(context),
                                                  ),
                                                ],
                                              )
                                            ]
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[

                                          Image.network(
                                            "${Env.URL_PREFIX}/${data.photo}",
                                            width: 150,
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              );
                          }
                      ),
                    ]
                )
            )
        )
    );
  }
}
