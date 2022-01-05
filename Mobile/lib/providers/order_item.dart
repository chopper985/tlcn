import 'address.dart';
import 'cart_item.dart';

class OrderItem {
  final String id;
  final DateTime dateTime;
  final double amount;
  final String userName;
  final String phoneNumber;
  final String payment;
  final String address;
  final List<CartItem> productsOrder;
  String status;

  OrderItem(
      {required this.id,
      required this.payment,
      required this.dateTime,
      required this.amount,
      required this.userName,
      required this.phoneNumber,
      required this.address,
      required this.productsOrder,
      required this.status});
}
