import 'dart:async';
import 'package:driver_app/config_maps.dart';
import 'package:driver_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? currentPosition;
  var geolocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address =
    //     await AssistantMethods.searchCoordinateAddress(position, context);
    // print("{ THIS IS YOUR ADDRESS $address }");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),

        // online offline driver
        Container(
          height: 140,
          width: double.infinity,
          color: Colors.black54,
        ),

        Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: RaisedButton(
                    onPressed: () {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();
                    },
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Offline now - Go Online",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 26,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }

  void makeDriverOnlineNow() async {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    
    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser?.uid ?? "",
        currentPosition!.latitude, currentPosition!.longitude);

    riderRequestPref.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(currentFirebaseUser!.uid, position.latitude, position.longitude);
      LatLng latlng = LatLng(
        position.latitude, position.longitude
      );
      newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latlng));
    });
  }
}