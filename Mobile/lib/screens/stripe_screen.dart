import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

class PaymentSheetScreen extends StatefulWidget {
  static String routeName = "paymentSheetScreen";


  @override
  State<PaymentSheetScreen> createState() => _PaymentSheetScreenState();
}

class _PaymentSheetScreenState extends State<PaymentSheetScreen> {
  Map<String, dynamic>? paymentIntentData;
  bool _init = true;

 @override
 void initState() {
    // TODO: implement initState
    super.initState();
   makePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Future<void> makePayment() async {
    final cart = Provider.of<Cart>(context, listen: false);
    try {
      paymentIntentData =
          await createPaymentIntent(cart.totalAmount.toInt().toString(), 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  testEnv: true,
                  style: ThemeMode.dark,
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'ANNIE'));
          // .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print(e);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('displaySaiiiiiiii!!!');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51K7c3jLZFf69SCa4rzCK1hj8Ld4bev3uQrbP1lcEN5n7Y1wQull8RRhA9ohxGrgmvmL74ynBLCPLGm7I3SZaUcL300ux0Yw8hL',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
