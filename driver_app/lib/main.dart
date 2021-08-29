import 'package:driver_app/AllScreens/car_info_screen.dart';
import 'package:driver_app/config_maps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/AllScreens/login_screen.dart';
import 'package:driver_app/AllScreens/main_screen.dart';
import 'package:driver_app/AllScreens/registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/DataHandler/app_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  currentFirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // if you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  

  print("{ HANDLING A BACKGROUND MESSAGE ${message.messageId} }");
}

DatabaseReference usersPref =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversPref =
    FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference riderRequestPref =
    FirebaseDatabase.instance.reference().child("drivers").child(currentFirebaseUser?.uid ?? "").child("newRide");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: (FirebaseAuth.instance.currentUser == null)
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen()
        },
      ),
    );
  }
}
