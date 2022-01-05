// ignore_for_file: unnecessary_statements

import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:flutter_shop_application/screens/payment_screen.dart';
import 'package:flutter_shop_application/widgets/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../providers/cart.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: cart.items.isEmpty
                  ? Center(
                      child: const Text(
                        'No have any item!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, index) => Slidable(
                        actionExtentRatio: 0.2,
                        actionPane: SlidableDrawerActionPane(),
                        child: CartItemWidget(
                          id: cart.items.values.toList()[index].id,
                          title: cart.items.values.toList()[index].title,
                          price: cart.items.values.toList()[index].price,
                          quanlity: cart.items.values.toList()[index].quantily,
                          imgUrl: cart.items.values.toList()[index].imgUrl,
                          productId: cart.items.keys.toList()[index],
                        ),
                        secondaryActions: [
                          IconSlideAction(
                            caption: "Delete",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        elevation: 5.0,
                                        backgroundColor: Colors.white,
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.warning_rounded,
                                              size: 20.0,
                                              color:
                                                  Theme.of(context).errorColor,
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text('Are you sure?')
                                          ],
                                        ),
                                        content: Text(
                                            'Do you want to remove the item from the cart?'),
                                        actions: [
                                          // ignore: deprecated_member_use
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('No')),
                                          // ignore: deprecated_member_use
                                          FlatButton(
                                              onPressed: () {
                                                cart.removeItem(cart.items.keys
                                                    .toList()[index]);
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Yes')),
                                        ],
                                      ));
                            },
                          )
                        ],
                      ),
                      itemCount: cart.items.length,
                    ),
            ),
            Divider(),
            Expanded(
              flex: 1,
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13.sp,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: 20.0, left: 30, right: 30, top: 0),
                        width: double.infinity,
                        child: OrderButton(cart: cart),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context).isAuth;
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: () {
        (widget.cart.totalAmount > 0 &&
                auth == true &&
                Provider.of<Auth>(context, listen: false).email !=
                    'guest@guest.com')
            ? Navigator.of(context).pushNamed(PaymentScreen.routeName)
            : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'To perform the function please login! Click ->',
                  style: TextStyle(color: Colors.black),
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Color.fromRGBO(252, 207, 218, 1),
                action: SnackBarAction(
                  label: 'LOGIN',
                  onPressed: () {
                    widget.cart.clearCart();
                    Provider.of<Auth>(context, listen: false).logOut();
                    Provider.of<User>(context, listen: false).logout();
                    Navigator.of(context).pop();
                  },
                ),
              ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Purchase Now',
          style: TextStyle(fontSize: 20),
        ),
      ),
      color: Colors.black,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
