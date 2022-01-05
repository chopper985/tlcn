import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'package:sizer/sizer.dart';

class CartItemWidget extends StatefulWidget {
  final String title;

  final String imgUrl;
  final int price;
  final int quanlity;
  final String id;
  final String productId;

  CartItemWidget({
    required this.title,
    required this.imgUrl,
    required this.price,
    required this.quanlity,
    required this.id,
    required this.productId,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  TextEditingController _quanlity = new TextEditingController();
  var focusNode = FocusNode();

  void verify() {
    if (_quanlity.text == '0' || _quanlity.text.length == 0) {
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
                      color: Theme.of(context).errorColor,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text('Are you sure?')
                  ],
                ),
                content: Text('Do you want to remove the item from the cart?'),
                actions: [
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _quanlity.text = widget.quanlity.toString();
                        });
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No')),
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false)
                            .removeItem(widget.productId);
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes')),
                ],
              ));
    }
  }

  @override
  void initState() {
    _quanlity.text = widget.quanlity.toString();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        verify();
        if (int.parse(_quanlity.text) > 0) {
          Provider.of<Cart>(context, listen: false)
              .updateQuanlity(widget.productId, int.parse(_quanlity.text));
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(widget.id),
      onDismissed: (direction) {
        cart.removeItem(widget.productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  elevation: 5.0,
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 20.0,
                        color: Theme.of(context).errorColor,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text('Are you sure?')
                    ],
                  ),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No')),
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes')),
                  ],
                ));
      },
      background: Container(
          color: Colors.red,
          child: Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 25,
          )),
      direction: DismissDirection.endToStart,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 6.0),
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        '\$${widget.price}',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                        height: 3.h,
                        width: 6.w,
                        child: InkWell(
                          child: Center(
                            child: Text('<', style: TextStyle(fontSize: 15.sp)),
                          ),
                          onTap: () {
                            try {
                              int quanlity = int.parse(_quanlity.text);
                              if (quanlity > 1) {
                                quanlity -= 1;
                                cart.removeSingleItem(widget.productId);
                                setState(() {
                                  _quanlity.text = quanlity.toString();
                                });
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        )),
                    Container(
                      alignment: Alignment.center,
                      height: 3.h,
                      width: 12.w,
                      child: TextFormField(
                        style: TextStyle(decoration: TextDecoration.none),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        focusNode: focusNode,
                        controller: _quanlity,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                        height: 3.h,
                        width: 6.w,
                        child: InkWell(
                          child: Center(
                            child: Text(
                              '>',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          onTap: () {
                            try {
                              cart.addSingleItem(widget.productId);
                              int quanlity = int.parse(_quanlity.text) + 1;
                              setState(() {
                                _quanlity.text = quanlity.toString();
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
