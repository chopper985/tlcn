import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_shop_application/models/.env.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final int price;
  final String type;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        '${baseURL}userFavorite/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
