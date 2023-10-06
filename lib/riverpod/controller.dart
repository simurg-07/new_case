import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model.dart';
import 'package:grock/grock.dart';

import '../view/home/home.dart';

class ControllerRiverpod extends ChangeNotifier {
  String token = "";

  List<dynamic> users = [];

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse("https://reqres.in/api/users"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      users = data['data'];
    } else {
      throw Exception('Failed to load users');
    }
  }


  void _tokensave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future loginServices(String email, String password) async {
    final Map<String, String> requestBody = {
      "email": email,
      "password": password
    };

    final response = await http.post(
      Uri.parse('https://reqres.in/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      token = responseData['token'];
      _tokensave();
      Grock.toRemove(Home());

      print(token);
    } else {

      Grock.snackBar(
        title: "Giriş başarısız",
        description: "Kullanıcı Adı veya Şifre Hatalı",
        blur: 20,
        opacity: 0.2,
        leading: Icon(Icons.error),
        curve: Curves.elasticInOut,
        // ... vs parameters
      );
    }
  }




}


