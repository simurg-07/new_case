import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:new_case/view/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      _initialize();
    });
  }

  _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('token') == ""
        ? Grock.to(Login())
        : Grock.toRemove(Home());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        color: Colors.deepPurple,
      ),
    );
  }
}
