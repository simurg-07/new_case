import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grock/grock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/model.dart';
import '../../riverpod/controller.dart';
import '../../riverpod/riverpod_management.dart';
import '../login/login.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Home> {


  @override
  Widget build(
    BuildContext context,
  ) {
    var read = ref.read(controllerRiverpod);
    var watch = ref.watch(controllerRiverpod);
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(onPressed: () async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', '');

            Grock.to(Login());
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: FutureBuilder(
          future:watch.fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: read.users.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(read.users[index]['avatar']),
                    ),
                    title: Text(read.users[index]['first_name'] + ' ' + read.users[index]['last_name']),
                    subtitle: Text(read.users[index]['email']),
                  ),
                );
              },
            );
          }),
    );
  }
}
