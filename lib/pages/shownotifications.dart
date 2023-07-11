// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agro_app/pages/call.dart';
import 'package:agro_app/pages/notificationservices.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class showNotification extends StatefulWidget {
  const showNotification({Key? key}) : super(key: key);

  @override
  State<showNotification> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<showNotification> {
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
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () async {
              // send notification from one device to another
              notificationServices.getDeviceToken().then((value) async {
                var data = {
                  'to': value.toString(),
                  'notification': {
                    'title': 'Incoming Call',
                    'body': 'Accept the call',
                  },
                  'data': {'type': 'msj', 'id': 'Ahd'}
                };

                await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAAtqdEUAw:APA91bF4lmokgz1zTZd4b1V04BxA8r7YnA3ahGa6Nqx0GNkwzE7ebTxZFiGHZVFnSP4jRde9LysNVih_W09gdeLdfsZCBeLGlQCY-N27s9kqH8BklfLi44NatABR6RmhBRTmZ0BU4xau'
                    }).then((value) async {
                  if (kDebugMode) {
                    print(value.body.toString());
                    await _handleCameraAndMic(Permission.camera);
                    await _handleCameraAndMic(Permission.microphone);
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
            },
            child: Text('Send Notifications')),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }
}
