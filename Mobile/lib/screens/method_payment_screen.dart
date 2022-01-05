import 'package:flutter/material.dart';
import 'package:flutter_shop_application/widgets/methob_payment_widget.dart';

class MethodPaymentScreen extends StatelessWidget {
  const MethodPaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Payment methods',
          style: Theme.of(context).textTheme.subtitle1,
        )),
        body: Column(
          children: [
            MethobPaymentWidget(
                index: 1,
                image: 'assets/images/social.png',
                title: 'Striple payment',
                subtitle: 'Pay directly by Striple payment gateway'),
            MethobPaymentWidget(
                index: 2,
                image: 'assets/images/paypal.png',
                title: 'Paypal payment',
                subtitle: 'Pay directly by Paypal payment gateway'),
            MethobPaymentWidget(
                index: 3,
                image: 'assets/images/cod.jpg',
                title: 'COD',
                subtitle: 'Cash on delivery')
          ],
        ));
  }
}
