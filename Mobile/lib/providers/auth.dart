import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shop_application/models/http_exception.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool splash = true;

  User? _user;
  bool? _isSignIn;
  String? _email;

  User? get user {
    return _user;
  }

  String? get email {
    return _email;
  }

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isSplash {
    return splash == true;
  }

  bool get isAuth {
    return token != null;
  }

  bool get isSignIn {
    return _isSignIn!;
  }

  String? get userId {
    return _userId;
  }

  Future<void> resetPassword(String newPassword, String token) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCgYv4TINBq7rWWUSXJsY0_BM_668-G4QU');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'idToken': token,
            'password': newPassword,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _email = email;
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment, bool check) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCgYv4TINBq7rWWUSXJsY0_BM_668-G4QU');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _email = email;
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      _isSignIn = check;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp', false);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword', true);
  }

  void logOut() {
    _email = null;
    _token = null;
    _userId = null;
    _expiryDate = null;
    _isSignIn = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void changeSplash() {
    splash = false;
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
