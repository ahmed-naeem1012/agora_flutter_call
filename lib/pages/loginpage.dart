// ignore_for_file: unused_element

import 'package:agro_app/pages/auth.dart';
import 'package:agro_app/pages/notificationservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController controlleremail = TextEditingController();
  final TextEditingController controllerpass = TextEditingController();
  NotificationServices notificationServices = NotificationServices();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInwithEmailandPassword(
          email: controlleremail.text, password: controllerpass.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    String deviceToken;

    try {
      deviceToken = await notificationServices.getDeviceToken();
      print(deviceToken.toString());

      await Auth().createUserWithEmailAndPassword(
        email: controlleremail.text,
        password: controllerpass.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget title() {
    return const Text('FireBase Auth');
  }

  Widget textfield(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: title),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(isLogin ? 'Login' : 'Register'));
  }

  Widget _loginorRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register Instead' : 'Login Instead'));
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
      ), // AppBar
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            textfield('email', controlleremail),
            textfield('password', controllerpass),
            _errorMessage(),
            submitButton(),
            _loginorRegisterButton()
          ], // <Widget>[]
        ), // Column
      ), // Container
    ); // Scaffold
  }
}
