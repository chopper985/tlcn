import 'package:flutter/material.dart';

class Local with ChangeNotifier {
  bool _isEnglish = true;
  int _checkSelectPayment = 0;

  bool get isEnglish {
    return _isEnglish;
  }

  int get checkSelectPayment {
    return _checkSelectPayment;
  }

  String methobPayment() {
    if (_checkSelectPayment == 0) {
      return 'Choose method';
    } else if (_checkSelectPayment == 1) {
      return 'VNpay';
    } else if (_checkSelectPayment == 2) {
      return 'Paypal';
    } else {
      return 'COD';
    }
  }

  void changeSelect(int select) {
    _checkSelectPayment = select;
    notifyListeners();
  }

  void changeLanguage() {
    _isEnglish = !_isEnglish;
    notifyListeners();
  }
}
