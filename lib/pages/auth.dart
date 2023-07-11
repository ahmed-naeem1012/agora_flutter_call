import 'package:agro_app/pages/notificationservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  NotificationServices notificationServices = NotificationServices();

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authstatechanges => firebaseAuth.authStateChanges();

  Future<void> signInwithEmailandPassword(
      {required String email, required String password}) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    String deviceToken;
    deviceToken = await notificationServices.getDeviceToken();
    print(deviceToken.toString());

    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
              FirebaseFirestore.instance
                  .collection('UserData')
                  .doc(value.user!.uid)
                  .set({
                "email": value.user!.email,
                "devicetoken": deviceToken.toString()
              })
            });
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
}
