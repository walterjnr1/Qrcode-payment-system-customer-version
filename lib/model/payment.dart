
class Payment {
  final String paymentID;
  final String owner_username;
  final String customer_email;
  final String restuarant;
  final String amount;
  final String date_payment;

  Payment({
    required this.paymentID,
    required this.owner_username,
    required this.customer_email,
    required this.restuarant,
    required this.amount,
    required this.date_payment,

  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentID: json['paymentID'],
      owner_username: json['owner_username'],
      customer_email: json['customer_email'],
      restuarant: json['restuarant'],
      amount: json['amount'],
      date_payment: json['date_payment'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentID': paymentID,
      'owner_username': owner_username,
      'customer_email': customer_email,
      'restuarant': restuarant,
      'amount': amount,
      'date_payment': date_payment,
    };
  }

  Map<String, dynamic> toJson() => {
    'paymentID': paymentID,  'owner_username': owner_username,   'customer_email': customer_email,    'restuarant': restuarant,   'amount': amount,  'date_payment': date_payment,  };
}
class Env {
  //static String URL_PREFIX = "http://192.168.43.16/Qr_code_payment_system/customer";
static String URL_PREFIX = "https://qrcode.leastpayproject.com.ng/customer";

}