import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shop_application/common/district.dart';

class District {
  final String id;
  final String name;
  District({
    required this.id,
    required this.name,
  });
}

class Ward {
  final String id;
  final String name;
  final String idParent;
  Ward({
    required this.id,
    required this.name,
    required this.idParent,
  });
}

class AddressItem {
  final String stress;
  final String ward;
  final String districts;
  AddressItem({
    required this.stress,
    required this.ward,
    required this.districts,
  });
}

class Address {
  final String id;
  final String address;
  final String fullName;
  final String phoneNumber;
  final String idUser;
  bool status;

  Address({
    required this.id,
    required this.address,
    required this.idUser,
    required this.status,
    required this.fullName,
    required this.phoneNumber,
  });

  void dispose() {}
}

class AddressItems with ChangeNotifier {
  List<District> _districts = [];
  List<Ward> _ward = [];
  String? _authToken;
  String? _userId;
  AddressItem? _item;

  List<District> get districts {
    return [..._districts];
  }

  List<Ward> get ward {
    return [..._ward];
  }

  AddressItem? get item {
    return _item;
  }

  void update(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  void addressItem(AddressItem addressItem) {
    // ignore: unnecessary_null_comparison
    if (addressItem == null) {
      return null;
    }
    _item = addressItem;
    notifyListeners();
  }

  void deleteItem() {
    // ignore: unnecessary_statements
    _item != null ? _item = null : null;
    notifyListeners();
  }

  Future<void> getDistrict() async {
    List<District> item = [];
    final String response =
        await rootBundle.loadString('assets/images/79.json');
    final data = await json.decode(response) as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (data == null) {
      return;
    }
    data.forEach((key, value) {
      item.add(District(
        id: key,
        name: value['name_with_type'],
      ));
    });
    print(item[0]);
    _districts = item;
    notifyListeners();
  }

  List<Ward> getWard(String id) {
    List<Ward> item = [];
    final data = districtsJson;
    // ignore: unnecessary_null_comparison
    if (data == null) {
      return [];
    }
    data.forEach((key, value) {
      if (id == value['parent_code']) {
        item.add(Ward(
            id: key,
            name: value['name_with_type']!,
            idParent: value['parent_code']!));
      }
    });
    _ward = item;
    return _ward;
  }
}
