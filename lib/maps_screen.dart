import 'package:auto_search/resources/google_maps_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_it/get_it.dart';

import 'Geocoding/geocoding_request.dart';
import 'all_widgets/divider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


 ////// for gesture button ////////////
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();




  late GoogleMapController mapController;
  final GoogleMapsService _googleMapsService = GetIt.I<GoogleMapsService>();
  LatLng _center = const LatLng(37.7749, -122.4194); // Default center location

  ///////////////////////////////////////////////////////CURRENT LOCATION///////////////////////////////////////////////////////////
  Position? currentPosition; // Nullable to check if the position is loaded
  var geoLocator = Geolocator();
  bool isLoading = true; // Control the progress indicator

  get newGoogleMapController => mapController;

  void locatePosition() async {
    setState(() {
      isLoading = true; // Start loading when location fetch starts
    });

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude); // When we move, camera moves

    CameraPosition cameraPosition = CameraPosition(target: latLatPosition, zoom: 17);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // Update center to the current position and stop loading
    setState(() {
      _center = latLatPosition;
      isLoading = false; // Hide progress indicator once the location is fetched
    });



    // Fetch and print the address using reverse geocoding
    String address = await GeocodingRequest.searchCoordinateAddress(position);
    print('This is your current address: ' + address);
  }


  @override
  void initState() {
    super.initState();
    _checkPermissions();
    // Fetch current location right when the widget is initialized
    locatePosition();
  }


  void _checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        setState(() {});
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      //////// for gesture detector button of navigation bar////////////
      key: scaffoldKey,


      appBar: AppBar(
        title: Text('Google Map'),
      ),


      //navigation drawer
      drawer: Container(
        color: Colors.white,
        width: screenWidth*0.7,

        child: Drawer(

          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffFFF4C9),
                  Color(0xffFFFFE0).withOpacity(0.6),
                ],
                begin: FractionalOffset(0.5, 0.0),
                end: FractionalOffset(0.5, 1.0),
                stops: [0.4, 1.0],
              ),
            ),
            child: ListView(

              children: [
                //drawer header
                Container(
                  height: screenHeight*0.2,
                  //color: CupertinoColors.systemYellow,

                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemYellow.withOpacity(0.5),
                    ),

                    child: Row(
                      children: [
                        Image.asset('assets/images/user1.png', height: screenHeight*0.18, width: screenWidth*0.18,),
                        SizedBox(width: screenWidth*0.03,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Profile Name", style: TextStyle(fontSize: screenHeight*0.018, fontWeight: FontWeight.w500),),
                            SizedBox(height: screenHeight*0.006,),
                            Text("Visit Profile", style: TextStyle(fontSize: screenHeight*0.015),),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                //DividerWidget(),

                SizedBox(height: 6,),

                //drawer body
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text("History", style: TextStyle(fontSize: screenHeight*0.018),),
                ),


                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Visit Profile", style: TextStyle(fontSize: screenHeight*0.018),),
                ),


                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About", style: TextStyle(fontSize: screenHeight*0.018),),
                ),
              ],
            ),
          ),
        ),
      ),





      body: Stack(
        children: [





          //GOOGLE MAP
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 25.0,
            ),
            myLocationEnabled: true, // Blue icon, showing current location
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(), // Show loading indicator while fetching location
            ),




          //hamburger button
          Positioned(
            top: 35,
            left: 22,

            child: GestureDetector(

              onTap: (){

          //we need to define a scaffold key !!!!!!!!
          scaffoldKey.currentState?.openDrawer();

              },

              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemYellow.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [ BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2.4,
                    spreadRadius: 0.2,
                    offset: Offset(0.7,0.7),
                  )
                  ]
                ),

                child: CircleAvatar(
                    backgroundColor: CupertinoColors.systemYellow.withOpacity(0.95),
                  child: Icon(Icons.menu, color: Colors.black,),
                  radius: 20,
                ),

              ),
            ),
          ),




          //SEARCH DROP OFF
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,


            //just to give base
            child: Container(
            height: screenHeight * 0.35,
              color: Colors.white,


              child: Container(
                height: screenHeight * 0.35, // Responsive height based on screen height
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffFFF4C9),
                      Color(0xffFFFFE0).withOpacity(0.6),
                    ],
                    begin: FractionalOffset(0.5, 0.0),
                    end: FractionalOffset(0.5, 1.0),
                    stops: [0.4, 1.0],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      spreadRadius: 0.2,
                      offset: Offset(0.7, 0.7),
                    )
                  ],
                ),


                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      SizedBox(height: screenHeight*0.015),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Hi There",
                          style: TextStyle(fontSize: screenHeight*0.016),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Where to?",
                          style: TextStyle(fontSize: screenHeight*0.024, fontWeight: FontWeight.w500),
                        ),
                      ),

                      SizedBox(height: screenHeight*0.015),

                      Center(
                        child: Container(
                          height: screenHeight*0.050,
                          width: screenWidth * 0.9, // Responsive width based on screen width
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemYellow.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2.0,
                                spreadRadius: 0.05,
                                offset: Offset(0.7, 0.7),
                              )
                            ],
                          ),


                          child: Row(
                            children: [

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                              ),
                              Text("Search Drop Off", style: TextStyle(fontSize: screenHeight*0.017),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight*0.020),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.black54,
                            ),
                            SizedBox(width: screenWidth*0.035),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add Home", style: TextStyle(fontSize: screenHeight*0.017),),
                                SizedBox(height: screenHeight*0.004),
                                Text(
                                  'Your living home address',
                                  style: TextStyle(color: Colors.black54, fontSize: screenHeight*0.014),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight*0.020),

                      DividerWidget(),

                      SizedBox(height: screenHeight*0.020),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.work,
                              color: Colors.black54,
                            ),
                            SizedBox(width: screenWidth*0.035),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add Work", style: TextStyle(fontSize: screenHeight*0.017),),
                                SizedBox(height: screenHeight*0.004),
                                Text(
                                  'Your office address',
                                  style: TextStyle(color: Colors.black54, fontSize: screenHeight*0.014),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),








        ],
      ),
    );
  }
}
