import 'package:flutter/material.dart';

class Local with ChangeNotifier {
  String _productScreenStatus = 'Default';

  String get productScreenStatus {
    return _productScreenStatus;
  }

  void changeProductScreenStatus(String status) {
    _productScreenStatus = status;
    notifyListeners();
  }
}
