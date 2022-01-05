import 'package:flutter/material.dart';
import 'cart_item.dart';

class OrderItem {
  final String id;
  final String key;
  final DateTime dateTime;
  final double amount;
  final String userName;
  final String phoneNumber;
  final String address;
  final String payment;
  final List<CartItem> productsOrder;
  String status;

  OrderItem(
      {@required this.payment,
      @required this.id,
      @required this.key,
      @required this.dateTime,
      @required this.amount,
      @required this.userName,
      @required this.phoneNumber,
      @required this.address,
      @required this.productsOrder,
      @required this.status});
}
