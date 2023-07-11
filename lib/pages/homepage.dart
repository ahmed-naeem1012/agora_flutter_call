// ignore_for_file: unused_element

import 'package:agro_app/pages/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final User? user = Auth().currentUser;

  Future<void> signout() async {
    await Auth().signout();
  }

  Widget title() {
    return const Text('FireBase Auth');
  }

  Widget _userId() {
    return Text(user?.email ?? "User Email");
  }

  Widget _signoutbutton() {
    return ElevatedButton(onPressed: signout, child: const Text("SignOut"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: title(),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _userId(),
                _signoutbutton(),
              ]),
        ));
  }
}
