import 'package:flutter/cupertino.dart';

class Product {
  final String product_no;
  final String product_name;
  final int amount;
  final String photo;
  Product({
    required this.product_no,
    required this.product_name,
    required this.amount,
    required this.photo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_no: json['product_no'],
      product_name: json['product_name'],
      amount: json['amount'],
      photo: json['photo'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_no': product_no,
      'amount': amount,
      'product_name': product_name,
      'photo': photo,
    };
  }

  Map<String, dynamic> toJson() => {
    'product_no': product_no,
    'product_name': product_name,
    'amount': amount,
    'photo': photo,
  };
}
class Env {
  //static String URL_PREFIX = "http://192.168.43.16/Qr_code_payment_system/customer";
 static String URL_PREFIX = "https://qrcode.leastpayproject.com.ng/customer";

}