import 'dart:convert';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shop_application/models/.env.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _favorites = [];

  String? _authToken;
  String? _userId;

  void update(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get itemsFavorites {
    List<Product> list = [];
    list = _items.where((element) => element.isFavorite == true).toList();
    if (list == null) {
      return _favorites;
    }
    _favorites = list;
    return _favorites;
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> searchByType(String type) {
    List<Product> product = [];
    product = _items.where((product) => product.type == type).toList();
    return product;
  }

  Future<void> fetchProducts() async {
    var url = Uri.parse(
        '${baseURL}products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      final List<Product> loadingProducts = [];
      if (_userId != null && _authToken != null) {
        url = Uri.parse(
            '${baseURL}userFavorite/$_userId.json?auth=$_authToken');
        final favoriteResponse = await http.get(url);
        final favoriteData = json.decode(favoriteResponse.body);
        extractedData.forEach((productId, productData) {
          loadingProducts.add(
            Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imgUrl'],
              isFavorite: favoriteData == null
                  ? false
                  : favoriteData[productId] ?? false,
              type: productData['type'],
            ),
          );
        });
      } else {
        extractedData.forEach((productId, productData) {
          loadingProducts.add(
            Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imgUrl'],
              isFavorite: productData['isFavorite'],
              type: productData['type'],
            ),
          );
        });
      }
      _items = loadingProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> searchProducts(String name, List<Product> listProducts) {
    List<Product> result = [];
    listProducts.forEach((p) {
      var exist = p.title.contains(name);
      if (exist) {
        result.add(p);
      }
    });
    return result;
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('${baseURL}products.json?auth=$_authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imgUrl': product.imageUrl,
          'price': product.price,
          'type': product.type
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          type: product.type);

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final indexProduct = _items.indexWhere((element) => element.id == id);
    final url = Uri.parse('${baseURL}products/$id.json?auth=$_authToken');
    await http.patch(
      url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imgUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }),
    );
    _items[indexProduct] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('${baseURL}products/$id.json?auth=$_authToken');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Exception;
    }
    existingProduct = null;
  }
}
