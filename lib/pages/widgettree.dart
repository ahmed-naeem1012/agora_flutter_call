// ignore_for_file: no_logic_in_create_state, unused_import, prefer_const_constructors

import 'package:agro_app/pages/auth.dart';
import 'package:agro_app/pages/homepage.dart';
import 'package:agro_app/pages/index.dart';
import 'package:agro_app/pages/loginpage.dart';
import 'package:agro_app/pages/userlists.dart';

import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);
  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authstatechanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return UserListScreen();
        } else {
          return LoginPage();
        }
      },
    ); // StreamBuilder
  }
}
