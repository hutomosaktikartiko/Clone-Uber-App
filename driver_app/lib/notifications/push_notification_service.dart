import 'package:driver_app/config_maps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Future initialize() async {
  //   firebaseMessaging.
  // }

  Future<void> getToken() async {
    String? token = await firebaseMessaging.getToken();
    print("{ TOKEN $token }");

    driversPref.child(currentFirebaseUser?.uid ?? "").child("token").set(token);

    await firebaseMessaging.subscribeToTopic("alldrivers");
   await firebaseMessaging.subscribeToTopic("allusers");
  }
}