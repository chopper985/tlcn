import 'dart:convert';
import 'package:tl_web_admin/utils/.env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserItem {
  final String id;
  final String idUser;
  final String avatar;
  final String fullName;
  final String email;
  final String birthday;
  final String phoneNumber;
  final String address;
  final bool gender;
  final String role;
  UserItem({
    @required this.id,
    @required this.role,
    @required this.idUser,
    @required this.avatar,
    @required this.fullName,
    @required this.email,
    @required this.birthday,
    @required this.phoneNumber,
    @required this.address,
    @required this.gender,
  });
}

class User with ChangeNotifier {
  String _authToken;
  String _userId;
  String role;
  UserItem _user = UserItem(
    id: '',
    idUser: '',
    fullName: '',
    email: '',
    gender: true,
    birthday: '',
    phoneNumber: '',
    address: '',
    avatar:
        'https://firebasestorage.googleapis.com/v0/b/flutter-shop-d0a51.appspot.com/o/avatar.jpg?alt=media&token=cdb54cc3-6514-4e4f-b69b-8794450d2da3',
    role: '',
  );

  String get userId {
    return _userId;
  }

  UserItem get user {
    return _user;
  }

  void update(String authToken, String userId) {
    _authToken = authToken;
    _userId = userId;
  }

  Future<void> addUser(UserItem item) async {
    final url = Uri.parse('${baseURL}users/$_userId.json?auth=$_authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'idUser': _userId,
            'fullName': item.fullName,
            'email': item.email,
            'birthday': item.birthday,
            'gender': item.gender,
            'phoneNumber': item.phoneNumber,
            'address': item.address,
            'avatar': item.avatar,
          },
        ),
      );
      if (response.statusCode == 200) {
        final newUser = UserItem(
          id: json.decode(response.body)['name'],
          idUser: _userId,
          fullName: item.fullName,
          email: item.email,
          gender: item.gender,
          birthday: item.birthday,
          phoneNumber: item.phoneNumber,
          address: item.address,
          avatar: item.avatar,
          role: '',
        );
        _user = newUser;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateUser(UserItem item) async {
    final url =
        Uri.parse('${baseURL}users/$_userId/${item.id}.json?auth=$_authToken');
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'idUser': item.idUser,
            'fullName': item.fullName,
            'email': item.email,
            'birthday': item.birthday,
            'gender': item.gender,
            'phoneNumber': item.phoneNumber,
            'address': item.address,
            'avatar': item.avatar,
          },
        ),
      );
      if (response.statusCode == 200) {
        _user = item;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<UserItem>> getAllUser() async {
    List<UserItem> list = [];
    final url = Uri.parse('${baseURL}users.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        extractedData.forEach((key, value) {
          final data = value as Map<String, dynamic>;
          data.forEach((keyValue, value2) {
            list.add(UserItem(
                id: key,
                address: value2['address'],
                email: value2['email'],
                phoneNumber: value2['phoneNumber'],
                birthday: value2['birthday'],
                gender: value2['gender'],
                idUser: value2['idUser'],
                fullName: value2['fullName'],
                avatar: value2['avatar'],
                role: ''));
          });
        });
        return list;
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  
  Future<void> getUser() async {
    UserItem data;
    final url = Uri.parse('${baseURL}users/$_userId.json?auth=$_authToken');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        extractedData.forEach((key, value) {
          if (value['idUser'] == _userId) {
            data = UserItem(
              role: value['role'],
              id: key,
              idUser: _userId,
              fullName: value['fullName'],
              email: value['email'],
              gender: value['gender'],
              birthday: value['birthday'],
              phoneNumber: value['phoneNumber'],
              address: value['address'],
              avatar: value['avatar'],
            );
          }
        });
        _user = data;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void logout() {
    _user = UserItem(
      id: '',
      idUser: '',
      fullName: '',
      email: '',
      gender: true,
      birthday: '',
      phoneNumber: '',
      address: '',
      avatar:
          'https://firebasestorage.googleapis.com/v0/b/flutter-shop-d0a51.appspot.com/o/avatar.jpg?alt=media&token=cdb54cc3-6514-4e4f-b69b-8794450d2da3',
      role: '',
    );
    notifyListeners();
  }
}
