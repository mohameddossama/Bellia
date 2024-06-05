import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:fluttercourse/paymob/constants.dart';

class PaymobManager {
  Dio dio = Dio();
  Future<String> payWithPaymob(int amount)async{
    try {
      String token = await getToken();
      int orderId = await getOrderId(token: token, amount: (100 * amount).toString());
      String paymentKey = await getPaymentKey(token: token, orderId: orderId.toString(), amount: (100 * amount).toString());
      return paymentKey;
    } catch (e) {
      print('============================Exception ${e.toString()}');
      rethrow;
    }
  }

  Future<String> getToken() async {
    try {
      Response response = await dio.post(
          'https://accept.paymob.com/api/auth/tokens',
          data: {"api_key": Constants.api_key});
      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getOrderId(
      {required String token, required String amount}) async {
    try {
      Response response = await dio
          .post('https://accept.paymob.com/api/ecommerce/orders', data: {
        'auth_token': token,
        'delivery_needed': 'true',
        'amount_cents': amount,
        'currency': 'EGP',
        'items': []
      });
      return response.data['id'];
    } catch (e) {
      rethrow;
    }
  }

  String? firstName;
  String? lastName;
  String? email;
  String? mobile;

  Future<String> getPaymentKey(
      {required String token,
      required String orderId,
      required String amount}) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        firstName = userData['first_name'] ?? '';
        lastName = userData['last_name'] ?? '';
        email = userData['email'] ?? '';
        mobile = userData['phone_number'] ?? '';
      } else {
        print(
            'User data not found for email: ${FirebaseAuth.instance.currentUser!.email}');
      }
      Response response = await dio
          .post('https://accept.paymob.com/api/acceptance/payment_keys',
          data: {
        'expiration':3600,
        'auth_token': token,
        'amount_cents': amount,
        'currency': 'EGP',
        'integration_id':4582928,
        'lock_order_when_paid': 'false',
        'order_id': orderId,
        "billing_data": {
          "apartment": "NA",
          "email": email,
          "floor": "NA",
          "first_name": firstName,
          "street": "NA",
          "building": "NA",
          "phone_number": mobile,
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "Egypt",
          "last_name": lastName,
          "state": "Alexandria"
        },
      });
      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }
}
