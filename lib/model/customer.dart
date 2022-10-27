class Customers {

  final String email;
  final String password;
  final String phone;
  final String address;
  final String cust_name;
  final dynamic balance;
  final String photo;


  Customers({
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.cust_name,
    required this.balance,
    required this.photo,

  });

  factory Customers.fromJson(Map<String, dynamic> json) {
    return Customers(
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      cust_name: json['cust_name'],
      balance: json['balance'],
      photo: json['photo'],

    );
  }
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'phone': phone,
    'address': address,
    'cust_name': cust_name,
    'balance': balance,
    'photo': photo,

  };
}
class Env {
 //static String URL_PREFIX = "http://192.168.43.16/Qr_code_payment_system/customer";
static String URL_PREFIX = "https://qrcode.leastpayproject.com.ng/customer";
}