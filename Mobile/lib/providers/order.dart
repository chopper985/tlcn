import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_shop_application/models/.env.dart';
import 'package:flutter/foundation.dart';
import 'cart_item.dart';
import 'order_item.dart';

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> _listOrdered = [];
  List<OrderItem> _listPacked = [];
  List<OrderItem> _listIntransit = [];
  List<OrderItem> _listDelivered = [];
  List<OrderItem> _listCanceled = [];

  String? _authToken;
  String? _userId;

  void update(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  bool get checkUser {
    return _userId == null;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<OrderItem> get listOrdered {
    return [..._listOrdered];
  }

  List<OrderItem> get listPacked {
    return [..._listPacked];
  }

  List<OrderItem> get listIntransit {
    return [..._listIntransit];
  }

  List<OrderItem> get listDelivered {
    return [..._listDelivered];
  }

  List<OrderItem> get listCanceled {
    return [..._listCanceled];
  }

  Future<void> deleteOrder(String id) async {
    final url =
        Uri.parse('${baseURL}orders/user-$_userId/$id.json?auth=$_authToken');
    final existingOrderIndex =
        _listOrdered.indexWhere((element) => element.id == id);
    OrderItem? existingOrder = orders[existingOrderIndex];
    _listOrdered.removeAt(existingOrderIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _listOrdered.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw Exception;
    }
    existingOrder = null;
  }

  Future<void> cancelOrder(String id) async {
    final url =
        Uri.parse('${baseURL}orders/user-$_userId/$id.json?auth=$_authToken');
    try {
      final response =
          await http.patch(url, body: json.encode({'status': 'Cancel'}));
      if (response.statusCode == 200) {
        final existingOrderIndex =
            _listOrdered.indexWhere((element) => element.id == id);
        OrderItem? existingOrder = orders[existingOrderIndex];
        existingOrder.status = "Cancel";
        _listCanceled.add(existingOrder);
        _listOrdered.removeAt(existingOrderIndex);
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchOrder() async {
    final url =
        Uri.parse('${baseURL}orders/user-$_userId.json?auth=$_authToken');
    final response = await http.get(url);
    final List<OrderItem> loadingOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadingOrder.add(OrderItem(
        id: orderId,
        payment: orderData['payment'],
        phoneNumber: orderData['phoneNumber'],
        address: orderData['address'],
        userName: orderData['userName'],
        status: orderData['status'],
        dateTime: DateTime.parse(orderData['dateOrder']),
        amount: orderData['amount'],
        productsOrder: (orderData['productsOrder'] as List<dynamic>)
            .map(
              (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantily: e['quantily'],
                  price: e['price'],
                  imgUrl: e['imgUrl']),
            )
            .toList(),
      ));
    });
    _orders = loadingOrder.reversed.toList();
    _listOrdered = loadingOrder.reversed
        .where((order) => order.status == "Ordered")
        .toList();
    _listPacked = loadingOrder.reversed
        .where((order) => order.status == "Packed")
        .toList();
    _listIntransit = loadingOrder.reversed
        .where((order) => order.status == "In transit")
        .toList();
    _listDelivered = loadingOrder.reversed
        .where((order) => order.status == "Delivered")
        .toList();
    _listCanceled = loadingOrder.reversed
        .where((order) => order.status == "Cancel")
        .toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cart, double totalAmount, String name,
      String phoneNumber, String address, bool isPaymet) async {
    final url =
        Uri.parse('${baseURL}orders/user-$_userId.json?auth=$_authToken');
    final time = DateTime.now();
    if (cart.isEmpty && totalAmount == 0) {
      return;
    }
    try {
      final response = await http.post(url,
          body: json.encode({
            'payment': isPaymet ? 'Paid' : 'Unpaid',
            'dateOrder': time.toIso8601String(),
            'amount': totalAmount,
            'status': 'Ordered',
            'userName': name,
            'phoneNumber': phoneNumber,
            'address': address,
            'productsOrder': cart
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantily': e.quantily,
                      'price': e.price,
                      'imgUrl': e.imgUrl,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            payment: isPaymet ? 'Paid' : 'Unpaid',
            dateTime: time,
            amount: totalAmount,
            productsOrder: cart,
            phoneNumber: phoneNumber,
            address: address,
            userName: name,
            status: 'Ordered',
          ));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
