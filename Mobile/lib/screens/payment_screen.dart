import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_application/helper/custom_route.dart';
import 'package:flutter_shop_application/providers/address.dart';
import 'package:flutter_shop_application/providers/addresses.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:flutter_shop_application/providers/local.dart';
import 'package:flutter_shop_application/providers/order.dart';
import 'package:flutter_shop_application/providers/voucher.dart';
import 'package:flutter_shop_application/screens/address/address_screen.dart';
import 'package:flutter_shop_application/screens/paypal_screen.dart';
import 'package:flutter_shop_application/screens/voucher_screen.dart';
import 'package:flutter_shop_application/widgets/address_item_widget.dart';
import 'package:flutter_shop_application/widgets/payment_widget.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'method_payment_screen.dart';
import 'order_screen.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = "/payment";

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isLoading = false;
  bool _isWait = false;
  Address? defaultAddress;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, dynamic>? paymentIntentData;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Voucher>(context, listen: false).fetchVouchers();
      Provider.of<Voucher>(context, listen: false).removeDefault();
    });
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    defaultAddress = Provider.of<Addresses>(context).defaultAddress;
    final defaultVoucher = Provider.of<Voucher>(context).voucherDefaulst;
    final local = Provider.of<Local>(context);
    final methodPayment = local.methobPayment();
    final discountVoucher = cart.totalAmount * defaultVoucher.percent / 100;
    final totalShipping =
        defaultAddress!.address.contains('Thành phố Thủ Đức') ? 0 : 1;
    final totalDiscount = discountVoucher > defaultVoucher.maxDiscount
        ? defaultVoucher.maxDiscount
        : cart.totalAmount * defaultVoucher.percent / 100;
    cart.updateTotalPayment(cart.totalAmount - totalDiscount - totalShipping);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Payment',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: _isWait
          ? Center(
              child: Lottie.asset('assets/images/loading_plane_paper.json'))
          : _isLoading
              ? Center(
                  child: Lottie.asset(
                  'assets/images/loading_shop.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ))
              : Container(
                  child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Divider(
                                thickness: 0.1.h, color: Colors.grey.shade200),
                            // ignore: unnecessary_null_comparison
                            defaultAddress != null
                                ? AddressItemWidget(
                                    name: defaultAddress!.fullName,
                                    phoneNumber: defaultAddress!.phoneNumber,
                                    // ignore: unnecessary_null_comparison
                                    address: defaultAddress!.address == null
                                        ? ''
                                        : defaultAddress!.address,
                                    handle: () {
                                      Navigator.of(context).push(CustomRoute(
                                          builder: (ctx) => AddressScreen()));
                                    })
                                : InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(CustomRoute(
                                          builder: (ctx) => AddressScreen()));
                                    },
                                    child: Container(
                                      child: Center(
                                          child: Text('No Address Now!')),
                                    ),
                                  ),
                            Divider(
                                thickness: 0.5.h, color: Colors.grey.shade200),
                            Row(
                              children: [
                                Icon(Icons.list_alt, color: Colors.lightBlue),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  'List Product',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.sp)),
                              height: 14.h * cart.items.length,
                              child: ListView.builder(
                                itemBuilder: (ctx, index) => PaymentWidget(
                                  id: cart.items.values.toList()[index].id,
                                  title:
                                      cart.items.values.toList()[index].title,
                                  price:
                                      cart.items.values.toList()[index].price,
                                  quanlity: cart.items.values
                                      .toList()[index]
                                      .quantily,
                                  imgUrl:
                                      cart.items.values.toList()[index].imgUrl,
                                  productId: cart.items.keys.toList()[index],
                                ),
                                itemCount: cart.items.length,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                              child: Row(
                                children: [
                                  Text('Total :',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Spacer(),
                                  Text('${cart.totalAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 11.sp,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                            Divider(
                                thickness: 0.5.h, color: Colors.grey.shade200),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => VoucherScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(LineAwesomeIcons.alternate_ticket,
                                        color: Colors.orangeAccent),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Text('Voucher',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    Spacer(),
                                    Text(
                                        // ignore: unnecessary_null_comparison
                                        defaultVoucher.title == null
                                            ? 'Choose Voucher'
                                            : defaultVoucher.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Icon(Icons.keyboard_arrow_right_rounded),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                                thickness: 0.5.h, color: Colors.grey.shade200),
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MethodPaymentScreen())),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(LineAwesomeIcons.comments_dollar,
                                        color: Colors.purple),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Text('Payment Options',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    Spacer(),
                                    Text(methodPayment,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Icon(Icons.keyboard_arrow_right_rounded),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                                thickness: 0.5.h, color: Colors.grey.shade200),
                            Container(
                                padding: EdgeInsets.all(8.0.sp),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Total amount of goods',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        Spacer(),
                                        Text(
                                            '${cart.totalAmount.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2)
                                      ],
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Row(
                                      children: [
                                        Text('Total shipping fee',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        Spacer(),
                                        Text(
                                            '- ${totalShipping.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2)
                                      ],
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Row(
                                      children: [
                                        Text('Total discount voucher',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        Spacer(),
                                        Text(
                                            '- ${totalDiscount.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2)
                                      ],
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        Text('Total payment',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                        Spacer(),
                                        Text(
                                            '${(cart.totalAmount - totalDiscount - totalShipping).toStringAsFixed(2)}',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13.sp,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    Divider(thickness: 0.5.h, color: Colors.grey.shade200),
                    Container(
                      child: Row(
                        children: [
                          Spacer(),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total payment',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.normal)),
                                SizedBox(height: 0.5.h),
                                Text(
                                    '\$ ${(cart.totalAmount - totalDiscount - totalShipping).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15.sp,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                              width: 30.w,
                              decoration: BoxDecoration(color: Colors.red),
                              child: TextButton(
                                  onPressed: defaultAddress == null
                                      ? () {}
                                      : () async {
                                          if (local.checkSelectPayment == 0) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: const Text(
                                                        'Please choose payment method!',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white))));
                                          } else if (local.checkSelectPayment ==
                                              2) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaypalPayment(
                                                          onFinish:
                                                              (number) async {
                                                            // payment done
                                                            print('order id: ' +
                                                                number);
                                                          },
                                                          id: defaultVoucher.id,
                                                          totalAmount:
                                                              cart.totalAmount,
                                                          voucher:
                                                              totalDiscount,
                                                          name: defaultAddress!
                                                              .fullName,
                                                          phoneNumber:
                                                              defaultAddress!
                                                                  .phoneNumber,
                                                          address:
                                                              defaultAddress!
                                                                  .address,
                                                          cart: cart
                                                              .items.values
                                                              .toList(),
                                                          discount:
                                                              defaultVoucher
                                                                  .percent,
                                                          shippingCost:
                                                              totalShipping
                                                                  .toStringAsFixed(
                                                                      0),
                                                        )));
                                          } else if (local.checkSelectPayment ==
                                              1) {
                                            makePayment();
                                            //makePayment();
                                            // order.addOrder(
                                            //           cart.items.values.toList(),
                                            //           cart.totalAmount,
                                            //           defaultAddress!.fullName,
                                            //           defaultAddress!.phoneNumber,
                                            //           defaultAddress!.address,
                                            //           true);
                                            //       Navigator.of(context)
                                            //           .pushReplacementNamed(
                                            //               OrderScreen.routeName);
                                            //       cart.clearCart();

                                          } else {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await Provider.of<Order>(context,
                                                    listen: false)
                                                .addOrder(
                                                    cart.items.values.toList(),
                                                    cart.totalAmount,
                                                    defaultAddress!.fullName,
                                                    defaultAddress!.phoneNumber,
                                                    defaultAddress!.address,
                                                    false)
                                                .then((value) => {
                                                      Provider.of<Voucher>(
                                                              context,
                                                              listen: false)
                                                          .deleteVoucher(
                                                              defaultVoucher
                                                                  .id),
                                                    });
                                            Provider.of<Voucher>(context,
                                                    listen: false)
                                                .removeDefault();
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    OrderScreen.routeName);
                                            cart.clearCart();
                                          }
                                        },
                                  child: Text(
                                    'Order Now',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )))
                        ],
                      ),
                    )
                  ],
                )),
    );
  }

  Future<void> makePayment() async {
    final cart = Provider.of<Cart>(context, listen: false);
    try {
      paymentIntentData = await createPaymentIntent(
          cart.total.toInt().toString(), 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              testEnv: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'ANNIE'));
      // .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(cart);
    } catch (e, s) {
      print(e);
    }
  }

  displayPaymentSheet(Cart cart) async {
    defaultAddress =
        Provider.of<Addresses>(context, listen: false).defaultAddress;
    try {
      await stripe.Stripe.instance
          .presentPaymentSheet(
              parameters: stripe.PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) async {
        // print('payment intent' + paymentIntentData!['id'].toString());
        // print(
        //     'payment intent' + paymentIntentData!['client_secret'].toString());
        // print('payment intent' + paymentIntentData!['amount'].toString());
        // print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Paid successfully")));
        await Provider.of<Order>(context, listen: false).addOrder(
            cart.items.values.toList(),
            cart.totalAmount,
            defaultAddress!.fullName,
            defaultAddress!.phoneNumber,
            defaultAddress!.address,
            true);
        Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
        cart.clearCart();
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on stripe.StripeException catch (e) {
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
