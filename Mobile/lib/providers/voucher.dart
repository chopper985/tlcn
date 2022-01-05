import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_shop_application/models/.env.dart';

class VoucherItem {
  final String id;
  final String title;
  final int maxDiscount;
  final int percent;
  final String createAt;
  VoucherItem({
    required this.id,
    required this.title,
    required this.maxDiscount,
    required this.percent,
    required this.createAt,
  });
}

class Voucher with ChangeNotifier {
  List<VoucherItem> _items = [];
  String? _authToken;
  String? _userId;
  VoucherItem _voucherDefault = VoucherItem(
      id: '',
      title: 'Choose voucher',
      maxDiscount: 0,
      percent: 0,
      createAt: '');
  int _indexDefault = -1;

  VoucherItem get voucherDefaulst {
    return _voucherDefault;
  }

  int get indexDefault {
    return _indexDefault;
  }

  List<VoucherItem> get items {
    return [..._items];
  }

  void update(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  void removeDefault() {
    _voucherDefault = VoucherItem(
        id: '',
        title: 'Choose voucher',
        maxDiscount: 0,
        percent: 0,
        createAt: '');
    _indexDefault = -1;
    notifyListeners();
  }

  void selectIndexDefault(int index) {
    _indexDefault = index;
    notifyListeners();
  }

  void selectDefault(String id) {
    final VoucherItem voucher =
        _items.firstWhere((voucher) => voucher.id == id);
    // ignore: unnecessary_null_comparison
    if (voucher == null) {
      return null;
    }
    _voucherDefault = voucher;
    notifyListeners();
  }

  Future<void> fetchVouchers() async {
    final url =
        Uri.parse('${baseURL}vouchers/user-$_userId.json?auth=$_authToken');
    List<VoucherItem> list = [];
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (response.body != 'null') {
          data.forEach((key, value) {
            list.add(VoucherItem(
              id: key,
              title: value['title'],
              maxDiscount: value['maxDiscount'],
              percent: value['percent'],
              createAt: value['createAt'],
            ));
          });
        }

        _items = list;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addVoucher(VoucherItem item) async {
    final url =
        Uri.parse('${baseURL}vouchers/user-$_userId.json?auth=$_authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': item.title,
            'maxDiscount': item.maxDiscount,
            'percent': item.percent,
            'createAt': DateTime.now().toString()
          }));
      if (response.statusCode == 200) {
        final voucher = VoucherItem(
            id: json.decode(response.body)['name'],
            title: item.title,
            maxDiscount: item.maxDiscount,
            percent: item.percent,
            createAt: DateTime.now().toString());
        _items.add(voucher);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteVoucher(String id) async {
    final url =
        Uri.parse('${baseURL}vouchers/user-$_userId/$id.json?auth=$_authToken');
    try {
      final existingVoucherIndex =
          _items.indexWhere((element) => element.id == id);
      VoucherItem? existingVoucher = _items[existingVoucherIndex];
      _items.removeAt(existingVoucherIndex);
      notifyListeners();
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingVoucherIndex, existingVoucher);
        notifyListeners();
      }
      existingVoucher = null;
    } catch (e) {
      print(e);
    }
  }
}
