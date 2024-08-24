import 'package:auto_search/Models/address.dart';
import 'package:auto_search/Models/placePredictions.dart';
import 'package:auto_search/all_widgets/divider.dart';
import 'package:auto_search/data_handler/app_data.dart';
import 'package:auto_search/httprequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextController = TextEditingController();
  TextEditingController DropOffTextController = TextEditingController();
  List<PlacePredictions> placepredictionslist = [];
  String sessionToken = "";

  @override
  void initState() {
    super.initState();
    // Generate a unique session token on initialization
    sessionToken = DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextController.text = placeAddress;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFF4C9),
        title: Text("Search Drop Off", style: TextStyle(fontWeight: FontWeight.w400)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFFF4C9), Color(0xffFFFFE0).withOpacity(0.6)],
            begin: FractionalOffset(0.5, 0.0),
            end: FractionalOffset(0.5, 1.0),
            stops: [0.4, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35),
              Container(
                width: 350,
                child: Row(
                  children: [
                    Icon(Icons.drive_eta_rounded),
                    SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        child: TextField(
                          onChanged: (val) {
                            findPlace(val);
                          },
                          controller: pickUpTextController,
                          decoration: InputDecoration(
                            label: Text("Pick Up Location"),
                            fillColor: CupertinoColors.systemYellow.withOpacity(0.65),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CupertinoColors.systemYellow,
                              ),
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                child: Row(
                  children: [
                    Icon(Icons.drive_eta_rounded),
                    SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        child: TextField(
                          onChanged: (val) {
                            findPlace(val);
                          },
                          controller: DropOffTextController,
                          decoration: InputDecoration(
                            label: Text("Drop off Location"),
                            fillColor: CupertinoColors.systemYellow.withOpacity(0.65),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CupertinoColors.systemYellow,
                              ),
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              (placepredictionslist.length > 0)
                  ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return PredictionTile(placePredictions: placepredictionslist[index]);
                  },
                  separatorBuilder: (context, index) {
                    return DividerWidget();
                  },
                  itemCount: placepredictionslist.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      // Generate a new session token for each new request
      String currentSessionToken = DateTime.now().millisecondsSinceEpoch.toString();
      String autocompleteurl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyDVHfnBiF57K1ZUqP2wImN5zE95Ue2ZALI&components=country:in&sessiontoken=$currentSessionToken";
      var res = await HttpRequest.getRequest(autocompleteurl);

      if (res == "Failed") {
        return;
      }

      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();

        setState(() {
          placepredictionslist = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  PredictionTile({Key? key, required this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10),
            Row(
              children: [
                Icon(Icons.add_location, size: 28),
                SizedBox(width: 14),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(placePredictions.main_text, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      Text(placePredictions.secondary_text, style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeid, context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  "Setting dropoff, Please Wait!",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );

    String placeDetailsurl =
        "https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeid&key=AIzaSyDVHfnBiF57K1ZUqP2wImN5zE95Ue2ZALI";

    var res = await HttpRequest.getRequest(placeDetailsurl);

    Navigator.pop(context);

    if (res == "Failed") {
      return;
    }

    if (res["status"] == "OK") {
      String st1 = res["result"]["name"];
      String st2 = placeid;

      Address userdropOffAddress = Address(
        "", // placeFormattedAddress
        st1, // placeName
        st2, // placeId
        res["result"]["geometry"]["location"]["lat"], // latitude
        res["result"]["geometry"]["location"]["lng"], // longitude
      );

      Provider.of<AppData>(context, listen: false).updatedropOffLocationAddress(userdropOffAddress);
      print("This is drop off location :");
      print(st1);

      Navigator.pop(context, "Obtain Direction");
    }
  }
}
