import 'package:driver_app/AllScreens/main_screen.dart';
import 'package:driver_app/AllScreens/registration_screen.dart';
import 'package:driver_app/config_maps.dart';
import 'package:driver_app/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CarInfoScreen extends StatefulWidget {
  static const String idScreen = "carInfo";

  const CarInfoScreen({Key? key}) : super(key: key);

  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 22,
            ),
            Image.asset(
              "assets/images/logo.png",
              width: 390,
              height: 250,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 22, 22, 32),
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Enter Car Details",
                    style: TextStyle(fontFamily: "Brand Bold", fontSize: 24),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextField(
                    controller: carModelTextEditingController,
                    decoration: InputDecoration(
                        labelText: "Car Model",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: carNumberTextEditingController,
                    decoration: InputDecoration(
                        labelText: "Car Number",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: carColorTextEditingController,
                    decoration: InputDecoration(
                        labelText: "Car Color",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: RaisedButton(
                      onPressed: () {
                        if (carModelTextEditingController.text.isEmpty) {
                          displayToastMessage("Please write Car Model", context);
                        } else if (carNumberTextEditingController.text.isEmpty) {
                          displayToastMessage("Please write Car Number", context);
                        } else if (carColorTextEditingController.text.isEmpty) {
                          displayToastMessage("Please write Car Color", context);
                        } else {
                          saveDriverCarInfo();
                        }
                      },
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: EdgeInsets.all(17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "NEXT",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 26,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void saveDriverCarInfo() {
    String userId = currentFirebaseUser?.uid ?? "";

    Map carInfoMap = {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text
    };

    driversPref.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false);
  }
}
