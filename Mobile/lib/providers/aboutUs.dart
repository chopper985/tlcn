import 'package:flutter/material.dart';
import 'address.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_shop_application/models/.env.dart';

class AboutUs {
  final String name;
  final String introduce;
  final List address;
  final String phoneNumber;
  final String email;
  final String image;
  final int index;
  AboutUs(
      {required this.name,
      required this.introduce,
      required this.address,
      required this.phoneNumber,
      required this.email,
      required this.image,
      this.index = 1});
}

class AboutUsInfor with ChangeNotifier {
  AboutUs _about = AboutUs(
      name: '',
      introduce: '',
      address: [],
      phoneNumber: '',
      email: '',
      image: '');
  AboutUs get about {
    return _about;
  }

  String? _authToken;
  String? _userId;

  void update(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  bool get checkUser {
    return _userId == null;
  }

  Future<void> addAbout(AboutUs about) async {
    final url = Uri.parse('${baseURL}abouts.json?auth=$_authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': about.name,
            'phoneNumber': about.phoneNumber,
            'email': about.email,
            'index': 1,
            'introduce': about.introduce,
            'address': about.address,
            'image': about.image,
          },
        ),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final newAbout = AboutUs(
          name: about.name,
          phoneNumber: about.phoneNumber,
          email: about.email,
          index: about.index,
          address: about.address,
          image: about.image,
          introduce: about.introduce,
        );
        _about = newAbout;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAboutUs() async {
    final url = Uri.parse('${baseURL}abouts.json?auth=$_authToken');
    AboutUs? data;
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        extractedData.forEach((key, value) {
          if (value['index'] == 1) {
            data = AboutUs(
                address: value['address'],
                email: value['email'],
                index: value['index'],
                introduce: value['introduce'],
                phoneNumber: value['phoneNumber'],
                name: value['name'],
                image: value['image']);
          }
        });
        _about = data!;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
