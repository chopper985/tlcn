import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/order.dart';
import 'package:intl/intl.dart';
import 'package:flutter_shop_application/providers/order_item.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  final int indexOrder;

  OrderItemWidget({required this.orderItem, required this.indexOrder});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.event_note,
                      color: Colors.white,
                    ),
                    radius: 35.0,
                    backgroundColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order # ${widget.indexOrder}',
                            style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.orderItem.productsOrder.length > 1
                              ? '${widget.orderItem.productsOrder.length} items'
                              : '${widget.orderItem.productsOrder.length} item',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                      child: Text(widget.orderItem.status,
                          style: Theme.of(context).textTheme.subtitle2)),
                  widget.orderItem.status == 'Ordered' &&
                          widget.orderItem.payment == 'Unpaid'
                      ? Container(
                          child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(Icons.notifications,
                                              color: Colors.red),
                                          SizedBox(width: 5.w),
                                          Text("Notification!",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                      content: Text(
                                          'Do you want to remove the item from the order?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('No',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1)),
                                        ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                await Provider.of<Order>(
                                                        context,
                                                        listen: false)
                                                    .cancelOrder(
                                                        widget.orderItem.id);
                                                Navigator.pop(context);
                                              } catch (e) {
                                                print(e);
                                              }
                                            },
                                            child: Text('Yes',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1)),
                                      ],
                                    ));
                          },
                        ))
                      : Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID Order',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(widget.orderItem.id.substring(14),
                      style: Theme.of(context).textTheme.headline3),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date Order',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(DateFormat.yMMMd().format(widget.orderItem.dateTime),
                      style: Theme.of(context).textTheme.headline3),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Product',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text('\$${widget.orderItem.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headline3),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text('${widget.orderItem.payment}',
                      style: Theme.of(context).textTheme.headline3),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'More',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: _expanded
                      ? Icon(Icons.expand_less)
                      : Icon(
                          Icons.expand_more,
                        ),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
            if (_expanded)
              Container(
                height: 40.0 * widget.orderItem.productsOrder.length,
                child: ListView(
                  children: widget.orderItem.productsOrder
                      .map(
                        (e) => Container(
                          height: 30,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 45.w,
                                child: Text(
                                  e.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                              Text(
                                '\$${e.price}' + ' x ' + '${e.quantily}',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
