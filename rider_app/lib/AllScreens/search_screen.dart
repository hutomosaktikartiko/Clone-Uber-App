import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllWidgets/divider_widget.dart';
import 'package:rider_app/AllWidgets/progress_dialog.dart';
import 'package:rider_app/Assistans/request_assistant.dart';
import 'package:rider_app/DataHandler/app_data.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'package:rider_app/config_maps.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 215,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ]),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back)),
                        Center(
                          child: Text(
                            "Set Drop Off",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Brand Bold",
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/pickicon.png",
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                  hintText: "PickUp Location",
                                  fillColor: Colors.grey,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11, top: 8, bottom: 8)),
                            ),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/desticon.png",
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              controller: dropOffTextEditingController,
                              onChanged: (val) {
                                findPlace(val);
                              },
                              decoration: InputDecoration(
                                  hintText: "Where to?",
                                  fillColor: Colors.grey,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11, top: 8, bottom: 8)),
                            ),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            //tile for predictions
            (placePredictionList.length > 0)
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListView.separated(
                      itemBuilder: (context, index) =>
                          PredictionTile(placePredictionList[index]),
                      separatorBuilder: (BuildContext context, int index) =>
                          DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapSDKKey&sessiontoken=1234567890&components=country:id";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if (res == "failed") {
        return;
      }
      print("{ PLACES PREDICTIONS RESPONSE $res}");

      if (res['status'] == "OK") {
        var predictions = res['predictions'];

        var placeList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();

        setState(() {
          placePredictionList = placeList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  const PredictionTile(this.placePredictions, {Key? key}) : super(key: key);

  final PlacePredictions placePredictions;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        getPlaceAddressDetail(placePredictions.placeId, context);
      },
      child: Column(
        children: [
          SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Icon(Icons.add_location),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${placePredictions.mainText}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "${placePredictions.secondaryText}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            width: 14,
          ),
        ],
      ),
    );
  }

  void getPlaceAddressDetail(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Setting DropOff, Please wait...",
            ));

    String placeDetailUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapSDKKey";

    var res = await RequestAssistant.getRequest(placeDetailUrl);

    Navigator.pop(context);

    if (res == "failed") {
      return;
    }

    if (res['status'] == "OK") {
      Address address = Address();
      address.placeName = res['result']['name'];
      address.placeId = placeId;
      address.latitude = res['result']['geometry']['location']['lat'];
      address.longitude = res['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);
      print("{ THIS IS DROP OFF LOCATION ${address.placeName}}");

      Navigator.pop(context, "obtainDirection");
    }
  }
}
