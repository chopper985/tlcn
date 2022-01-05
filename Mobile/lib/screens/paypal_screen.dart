import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:flutter_shop_application/providers/cart_item.dart';
import 'package:flutter_shop_application/providers/order.dart';
import 'package:flutter_shop_application/providers/paypal.dart';
import 'package:flutter_shop_application/providers/voucher.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'order_screen.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final double totalAmount;
  final num voucher;
  final String shippingCost;
  final int discount;
  final String id;
  final String name;
  final String phoneNumber;
  final String address;
  final List<CartItem> cart;

  PaypalPayment({
    required this.onFinish,
    required this.totalAmount,
    required this.voucher,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.cart,
    required this.id,
    required this.shippingCost,
    required this.discount,
  });

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var checkoutUrl;
  var executeUrl;
  var accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;
  bool _isLoading = false;
  late final AnimationController _controller;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
              Navigator.pop(context);
            },
          ),
        );
        // ignore: deprecated_member_use
        _scaffoldKey.currentState!.showSnackBar(snackBar);
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    List items = [];
    widget.cart.forEach((element) {
      items.add({
        "name": element.title,
        "quantity": element.quantily,
        "price": element.price.toString(),
        "currency": defaultCurrency["currency"]
      });
    });
    String subtotalAmount = widget.totalAmount.toString();
    String totalAmount = (int.parse(widget.totalAmount.toStringAsFixed(0)) -
            widget.voucher -
            int.parse(widget.shippingCost))
        .toString();
    String shippingCost = widget.shippingCost;
    String shippingDiscountCost = ((-1.0) * widget.voucher).toString();
    print(shippingDiscountCost +
        ' ' +
        shippingCost +
        ' ' +
        subtotalAmount +
        ' ' +
        totalAmount);

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subtotalAmount,
              "shipping": '-' + shippingCost,
              "shipping_discount": shippingDiscountCost
            }
          },
          "description": "Fees for payment at the Shoe store",
          "item_list": {"items": items}
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final defaultVoucher = Provider.of<Voucher>(context).voucherDefaulst;

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: _isLoading
            ? Center(
                child: Lottie.asset(
                'assets/images/loading_shop.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ))
            : WebView(
                initialUrl: checkoutUrl,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) async {
                  if (request.url.contains(returnURL)) {
                    final uri = Uri.parse(request.url);
                    final payerID = uri.queryParameters['PayerID'];
                    if (payerID != null) {
                      setState(() {
                        _isLoading = true;
                      });
                      services
                          .executePayment(
                              Uri.parse(executeUrl), payerID, accessToken)
                          .then((id) {
                        widget.onFinish(id);
                      });
                      await Provider.of<Order>(context, listen: false)
                          .addOrder(
                              widget.cart,
                              widget.totalAmount,
                              widget.name,
                              widget.phoneNumber,
                              widget.address,
                              true)
                          .then((value) => {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: const Text(
                                  'Payment Success!',
                                  style: TextStyle(color: Colors.white),
                                ))),
                                Provider.of<Voucher>(context, listen: false)
                                    .deleteVoucher(defaultVoucher.id),
                                Navigator.of(context).pop(),
                              });
                      setState(() {
                        _isLoading = false;
                      });

                      Navigator.of(context)
                          .pushReplacementNamed(OrderScreen.routeName);
                      cart.clearCart();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                        'Payment failed!',
                        style: TextStyle(color: Colors.white),
                      )));
                      Navigator.of(context).pop();
                    }
                  }
                  if (request.url.contains(cancelURL)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text(
                      'Payment failed!',
                      style: TextStyle(color: Colors.white),
                    )));
                    Navigator.of(context).pop();
                  }
                  return NavigationDecision.navigate;
                },
              ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
