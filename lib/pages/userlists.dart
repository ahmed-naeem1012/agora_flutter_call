// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agro_app/pages/auth.dart';
import 'package:agro_app/pages/call.dart';
import 'package:agro_app/pages/notificationservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final User? user = Auth().currentUser;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    // notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('UserData').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error fetching users: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (ctx, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final uid = users[index].id;
                    final token = users[index];

                    return ListTile(
                      title: Text(user['email'] ?? 'Unknown'),
                      subtitle: Text('UID: $uid'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              // log(user['devicetoken'] ?? 'BLANK');
                              notificationServices
                                  .getDeviceToken()
                                  .then((value) async {
                                var data = {
                                  'to': user['devicetoken'] ?? 'BLANK',
                                  'notification': {
                                    'title': 'Incoming Call',
                                    'body': 'Accept the call',
                                  },
                                  'data': {'type': 'msj', 'id': 'Ahd'}
                                };

                                await http.post(
                                    Uri.parse(
                                        'https://fcm.googleapis.com/fcm/send'),
                                    body: jsonEncode(data),
                                    headers: {
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Authorization':
                                          'key=AAAAtqdEUAw:APA91bF4lmokgz1zTZd4b1V04BxA8r7YnA3ahGa6Nqx0GNkwzE7ebTxZFiGHZVFnSP4jRde9LysNVih_W09gdeLdfsZCBeLGlQCY-N27s9kqH8BklfLi44NatABR6RmhBRTmZ0BU4xau'
                                    }).then((value) async {
                                  if (kDebugMode) {
                                    print(value.body.toString());
                                    await _handleCameraAndMic(
                                        Permission.camera);
                                    await _handleCameraAndMic(
                                        Permission.microphone);
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CallScreen(
                                                  channelName: 'cha',
                                                  role: ClientRole.Broadcaster,
                                                )));
                                  }
                                }).onError((error, stackTrace) {
                                  if (kDebugMode) {
                                    print(error);
                                  }
                                });
                              });
                              // Implement your delete functionality here
                            },
                            child: Text('Call'),
                          ),
                        ],
                      ),
                      onTap: () {
                        log(user['devicetoken'] ?? 'BLANK');
                        // Implement additional functionality on tap here
                      },
                      // Customize the UI as per your requirements
                    );
                  },
                );
              },
            ),
          ),
          _userId(),
          _signoutbutton()
        ],
      ),
    );
  }

  Future<void> signout() async {
    await Auth().signout();
  }

  Widget _userId() {
    return Text(user?.uid ?? "User Email");
  }

  Widget _signoutbutton() {
    return ElevatedButton(onPressed: signout, child: const Text("SignOut"));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }
}
