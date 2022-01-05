import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tl_web_admin/utils/.env.dart';
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
  List<OrderItem> _listSelect = [];
  List<OrderItem> _listDefautl = [];
  List<OrderItem> _orderToday = [];
  List<OrderItem> _orderWeekly = [];
  List<OrderItem> _orderMonthly = [];
  List<OrderItem> _orderYearly = [];
  double _orderAmountToday = 0;
  double _orderAmountWeekly = 0;
  double _orderAmountMonthly = 0;
  double _orderAmountYearly = 0;

  List<CartItem> _lstCard = [];
  bool _isDetail = false;

  double _amountTotal = 0;

  String _authToken;
  String _userId;
  String _status = 'All';

  void update(String authToken, String userId) {
    _authToken = authToken;
    _userId = userId;
  }

  String get status {
    return _status;
  }

  double get orderAmountToday {
    return _orderAmountToday;
  }

  double get orderAmountWeekly {
    return _orderAmountWeekly;
  }

  double get orderAmountMonthly {
    return _orderAmountMonthly;
  }

  double get orderAmountYearly {
    return _orderAmountYearly;
  }

  bool get isDetail {
    return _isDetail;
  }

  double get amountTotal {
    return _amountTotal;
  }

  bool get checkUser {
    return _userId == null;
  }

  List<CartItem> get lstCard {
    return [..._lstCard];
  }

  List<OrderItem> get listSelect {
    return [..._listSelect];
  }

  List<OrderItem> get listDefautl {
    return [..._listDefautl];
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

  void setStatus(String status) {
    _status = status;
    if (_status == 'All') {
      _listDefautl = _orders;
    } else if (_status == "Ordered") {
      _listDefautl = _listOrdered;
    } else if (_status == "In transit") {
      _listDefautl = _listIntransit;
    } else if (_status == "Packed") {
      _listDefautl = _listPacked;
    } else if (_status == "Delivered") {
      _listDefautl = _listDelivered;
    } else {
      _listDefautl = _listCanceled;
    }
    notifyListeners();
  }

  void checkDetail(List<CartItem> lstProduct, bool detail) {
    _lstCard = lstProduct;
    _isDetail = detail;
    notifyListeners();
  }

  void removeTotal() {
    _amountTotal = 0;
    _orderAmountToday = 0;
    _orderAmountWeekly = 0;
    _orderAmountMonthly = 0;
    _orderAmountYearly = 0;
    notifyListeners();
  }

  Future<void> changeStatus() async {
    for (int i = 0; i < _listSelect.length; i++) {
      try {
        final url = Uri.parse(
            '${baseURL}orders/${_listSelect[i].key}/${_listSelect[i].id}.json');
        String status = _status == 'Ordered'
            ? 'Packed'
            : _status == 'Packed'
                ? 'In transit'
                : _status == 'In transit'
                    ? 'Delivered'
                    : null;
        if (status == 'Delivered') {
          final response = await http.patch(
            url,
            body: json.encode({
              'payment': 'Paid',
              'status': status,
            }),
          );
          if (response.statusCode == 200) {
            _listDefautl
                .removeWhere((element) => element.id == _listSelect[i].id);
          }
        } else {
          final response = await http.patch(
            url,
            body: json.encode({
              'status': status,
            }),
          );
          if (response.statusCode == 200) {
            _listDefautl
                .removeWhere((element) => element.id == _listSelect[i].id);
          }
        }
      } catch (e) {
        print(e);
      }
    }
    _listSelect.clear();
    notifyListeners();
    fetchAllOrder();
  }

  void addSelect(bool selected, OrderItem order) {
    if (selected) {
      _listSelect.add(order);
    } else {
      _listSelect.remove(order);
    }
    notifyListeners();
  }

  double totalMoneyByDay(int indexDate) {
    _amountTotal = 0;
    var now = DateTime.now();
    _orderToday = _listDelivered
        .where((element) =>
            DateFormat('dd/MM/yyyy')
                .format(DateTime(now.year, now.month, now.day - indexDate)) ==
            DateFormat('dd/MM/yyyy').format(element.dateTime))
        .toList();
    if (_orderToday.isEmpty) {
      return 0;
    }
    _orderToday.forEach((element) {
      _amountTotal = _amountTotal + element.amount;
    });
    return _amountTotal;
  }

  double totalMoneyToday() {
    _orderAmountToday = 0;
    _orderToday = [];
    _orderToday = _listDelivered
        .where((element) =>
            DateFormat('dd/MM/yyyy').format(DateTime.now()) ==
            DateFormat('dd/MM/yyyy').format(element.dateTime))
        .toList();
    if (_orderToday.isEmpty) {
      _orderAmountToday = 0;
    }
    _orderToday.forEach((element) {
      _orderAmountToday = _orderAmountToday + element.amount;
    });
    return _orderAmountToday;
  }

  double totalMoneyWeekly() {
    _orderWeekly = [];
    _orderAmountWeekly = 0;
    var now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      _orderWeekly = _orderWeekly +
          _listDelivered
              .where((element) =>
                  DateFormat('dd/MM/yyyy')
                      .format(DateTime(now.year, now.month, now.day - i)) ==
                  DateFormat('dd/MM/yyyy').format(element.dateTime))
              .toList();
    }
    if (_orderWeekly.isEmpty) {
      _orderAmountWeekly = 0;
    }
    _orderWeekly.forEach((element) {
      _orderAmountWeekly = _orderAmountWeekly + element.amount;
    });
    return _orderAmountWeekly;
  }

  double totalMoneyMonth() {
    _orderAmountMonthly = 0;
    _orderMonthly = [];
    var now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      _orderMonthly = _orderMonthly +
          _listDelivered
              .where((element) =>
                  DateFormat('dd/MM/yyyy')
                      .format(DateTime(now.year, now.month, now.day - i)) ==
                  DateFormat('dd/MM/yyyy').format(element.dateTime))
              .toList();
    }
    if (_orderMonthly.isEmpty) {
      _orderAmountMonthly = 0;
    }
    _orderMonthly.forEach((element) {
      _orderAmountMonthly = _orderAmountMonthly + element.amount;
    });
    return _orderAmountMonthly;
  }

  double totalMoneyYear() {
    _orderAmountYearly = 0;
    _orderYearly = [];
    var now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      _orderYearly = _orderYearly +
          _listDelivered
              .where((element) =>
                  DateFormat('dd/MM/yyyy')
                      .format(DateTime(now.year, now.month, now.day - i)) ==
                  DateFormat('dd/MM/yyyy').format(element.dateTime))
              .toList();
    }
    if (_orderYearly.isEmpty) {
      _orderAmountYearly = 0;
    }
    _orderYearly.forEach((element) {
      _orderAmountYearly = _orderAmountYearly + element.amount;
    });
    return _orderAmountYearly;
  }

  List<OrderItem> searchByDate(String date) {
    final orders = _listDefautl
        .where((element) =>
            DateFormat('dd/MM/yyyy').format(element.dateTime) == date)
        .toList();
    if (orders.isEmpty) {
      return [];
    }
    return orders;
  }

  Future<void> deleteOrder(String id) async {
    final url =
        Uri.parse('${baseURL}orders/user-$_userId/$id.json?auth=$_authToken');
    final existingOrderIndex =
        _listOrdered.indexWhere((element) => element.id == id);
    OrderItem existingOrder = orders[existingOrderIndex];
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

  int countProductInMonth(int month) {
    final now = DateTime.now();
    int amount = 0;
    final lstorders = _orders
        .where((element) =>
            element.dateTime.year == now.year &&
            element.dateTime.month == month)
        .toList();
    if (lstorders.isEmpty) {
      return 0;
    }
    lstorders.forEach((element) {
      amount += element.productsOrder.length;
    });
    return amount;
  }

  int countOrderByMonth(int month) {
    final now = DateTime.now();
    final lstorders = _orders
        .where((element) =>
            element.dateTime.year == now.year &&
            element.dateTime.month == month)
        .toList();
    if (lstorders.isEmpty) {
      return 0;
    }
    return lstorders.length;
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
        OrderItem existingOrder = orders[existingOrderIndex];
        existingOrder.status = "Cancel";
        _listCanceled.add(existingOrder);
        _listOrdered.removeAt(existingOrderIndex);
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAllOrder() async {
    final url = Uri.parse('${baseURL}orders.json');
    final response = await http.get(url);
    final List<OrderItem> loadingOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      return [];
    }
    extractedData.forEach((key, orderData) {
      final data = orderData as Map<String, dynamic>;
      data.forEach((orderId, value) {
        loadingOrder.add(OrderItem(
          payment: value['payment'],
          key: key,
          id: orderId,
          phoneNumber: value['phoneNumber'],
          address: value['address'],
          userName: value['userName'],
          status: value['status'],
          dateTime: DateTime.parse(value['dateOrder']),
          amount: value['amount'],
          productsOrder: (value['productsOrder'] as List<dynamic>)
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
    if (_status == 'All') {
      _listDefautl = _orders;
    } else if (_status == "Ordered") {
      _listDefautl = _listOrdered;
    } else if (_status == "In transit") {
      _listDefautl = _listIntransit;
    } else if (_status == "Packed") {
      _listDefautl = _listPacked;
    } else if (_status == "Delivered") {
      _listDefautl = _listDelivered;
    } else {
      _listDefautl = _listCanceled;
    }
    notifyListeners();
  }

  Future<List<OrderItem>> fetchOrder() async {
    final url = Uri.parse('${baseURL}orders.json');
    final response = await http.get(url);
    final List<OrderItem> loadingOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      return [];
    }
    extractedData.forEach((key, orderData) {
      final data = orderData as Map<String, dynamic>;
      data.forEach((orderId, value) {
        loadingOrder.add(OrderItem(
          key: key,
          id: orderId,
          phoneNumber: value['phoneNumber'],
          address: value['address'],
          userName: value['userName'],
          status: value['status'],
          dateTime: DateTime.parse(value['dateOrder']),
          amount: value['amount'],
          productsOrder: (value['productsOrder'] as List<dynamic>)
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
    });
    _orders = loadingOrder.reversed.toList();
    if (_status == 'All') {
      return loadingOrder;
    } else if (_status == "Ordered") {
      _listOrdered = loadingOrder.reversed
          .where((order) => order.status == "Ordered")
          .toList();
      return _listOrdered;
    } else if (_status == "In transit") {
      _listIntransit = loadingOrder.reversed
          .where((order) => order.status == "In transit")
          .toList();
      return _listIntransit;
    } else if (_status == "Packed") {
      _listPacked = loadingOrder.reversed
          .where((order) => order.status == "Packed")
          .toList();
      return _listPacked;
    } else if (_status == "Delivered") {
      _listDelivered = loadingOrder.reversed
          .where((order) => order.status == "Delivered")
          .toList();
      return _listDelivered;
    } else {
      _listCanceled = loadingOrder.reversed
          .where((order) => order.status == "Cancel")
          .toList();
      return _listCanceled;
    }
  }

  Future<void> addOrder(List<CartItem> cart, double totalAmount, String name,
      String phoneNumber, String address) async {
    final url =
        Uri.parse('${baseURL}orders/user-$_userId.json?auth=$_authToken');
    final time = DateTime.now();
    if (cart.isEmpty && totalAmount == 0) {
      return;
    }
    try {
      final response = await http.post(url,
          body: json.encode({
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
            key: 'user-$_userId',
            id: json.decode(response.body)['name'],
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
