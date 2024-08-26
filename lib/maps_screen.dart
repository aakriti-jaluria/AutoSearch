import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_search/data_handler/app_data.dart';
import 'package:auto_search/resources/google_maps_services.dart';
import 'package:auto_search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'Geocoding/geocoding_request.dart';
import 'all_widgets/divider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin //for switching the screens
{



 /////////////////for switching the screens////////////////
  double rideDetailsContainerHeight = 0;
  double requestRideContainerHeight = 0;
  double searchContainerHeight = 300.0; ///////yahan nhi hui media query apply

//// display ride details container /////
  void displayRideDetailsContainer()async
  {
    await getPlaceDirection();

    setState(() {

      double screenHeight = MediaQuery.of(context).size.height;

      //go to search drop off container and set the height to search container height
   searchContainerHeight=0; //SEARCH DROP OFF
   rideDetailsContainerHeight = screenHeight*0.4;   //SELECT RIDE
   //bottomPaddingOfMap = 230.0;

   // also apply animation , wrap the main container with animation

    });
  }


  /////display rider request container ////we will call this in onpressed of request button
  void displayRequestRideContainer()async{
    await getPlaceDirection();

    setState(() {

      double screenHeight = MediaQuery.of(context).size.height;


      rideDetailsContainerHeight = 0;//SELECT RIDE
      requestRideContainerHeight=screenHeight*0.4;
      //bottomPaddingOfMap = 230.0;

      // also apply animation , wrap the main container with animation

      });


  }



 ////// for gesture button ////////////
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();






List<LatLng> pLineCoordinates = [];
Set<Polyline> polylineset= {};





  late GoogleMapController mapController;
  final GoogleMapsService _googleMapsService = GetIt.I<GoogleMapsService>();
  LatLng _center = const LatLng(37.7749, -122.4194); // Default center location

  ///////////////////////////////////////////////////////CURRENT LOCATION///////////////////////////////////////////////////////////
  Position? currentPosition; // Nullable to check if the position is loaded
  var geoLocator = Geolocator();
  bool isLoading = true; // Control the progress indicator

  get newGoogleMapController => mapController;



  Set<Marker> markersset = {};
  Set<Circle> circlesset = {};






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
    String address = await GeocodingRequest.searchCoordinateAddress(position, context);   //context from geocoding request added here !!!!
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


/////////////////////////////////////////////////////////////////////////NAVIGATION DRAWER///////////////////////////////////////////////////////////////////////////////////////////
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



/////////////////////////////////////////////////////////////////////////////GOOGLE MAP///////////////////////////////////////////////////////////////////////
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
            polylines: polylineset,
            markers: markersset,
            circles: circlesset,
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(), // Show loading indicator while fetching location
            ),




/////////////////////////////////////////////////////////////////////////////HAMBURGER BUTTON///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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




/////////////////////////////////////////////////////////////////////////////SEARCH DROP OFF//////////////////////////////////////////////////////////////////////////////
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,


            //just to give base
            child: AnimatedSize(

            //key : this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),

              child: Container(
              height: searchContainerHeight,
                color: Colors.white,
              
              
                child: GestureDetector(
              
                  onTap: ()async{
                    var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
              
                    if(res == "Obtain Direction"){



                      // here we can directly call displayridedetailscontainer

                      //await getPlaceDirection();
                      displayRideDetailsContainer();
                    }
                  },
              
              
                  child: Container(
                    height: searchContainerHeight, // Responsive height based on screen height
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
              
              
              
                                Flexible( ////////////////////column wraped with flexibble to wrap  the home address
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
              
                                        //"Add Home", style: TextStyle(fontSize: screenHeight*0.017),
              
              
                                        //we r doing changes in SEARCH DROP OFF ----- saving the HOME ADDRESS permanently in home column ----- visit map_screen
                                        Provider.of<AppData>(context).pickUpLocation != null
                                            ? Provider.of<AppData>(context).pickUpLocation!.placeName   ////(THIS ! IS ADDED - Use a Nullable Field: Change pickUpLocation to be nullable (Address?) and handle the null case when accessing it.)
                                            : "Add Home",
              
                                        //style: TextStyle(fontSize: 15),
              
                                        // overflow: TextOverflow.clip,
                                        // maxLines: null,
                                        style: TextStyle(fontSize: screenHeight * 0.015, fontWeight: FontWeight.w400),
                                        // overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                                        // maxLines: null, // Restrict to one line if necessary
                                        // softWrap: false,
              
              
              
              
              
              
              
              
              
              
                                      ),
              
              
                                      SizedBox(height: screenHeight*0.006),
              
              
              
                                      Text(
                                        'Your living home address',
                                        style: TextStyle(color: Colors.black54, fontSize: screenHeight*0.012),
                                      ),
                                    ],
                                  ),
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
                                    Text("Add Work", style: TextStyle(fontSize: screenHeight*0.015),),
              
                                    SizedBox(height: screenHeight*0.006),
              
                                    Text(
                                      'Your office address',
                                      style: TextStyle(color: Colors.black54, fontSize: screenHeight*0.012),
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
            ),
          ),



///////////////////////////////////////////////////////////////////////////////SELECT RIDE  - ride details///////////////////////////////////////////////////////////////////////////////
          Positioned(

            bottom: 0.0,
            left: 0.0,
            right: 0.0,

            child: Container(
              height: rideDetailsContainerHeight,
              color: Colors.white,

              child: Container(
                height: rideDetailsContainerHeight, // Responsive height based on screen height
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

                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      //height: 16,
                      color: CupertinoColors.systemYellow.withOpacity(0.4),

                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),

                        child: Row(
                          children: [

                            Image.asset('assets/images/auto2.png', height: screenHeight*0.13,),
                            SizedBox(width: screenWidth*0.095,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Book an Auto",
                                  style: TextStyle(fontSize: screenHeight*0.022, fontWeight: FontWeight.w500),
                                ),

                                Text(
                                  "10Km",
                                  style: TextStyle(fontSize: screenHeight*0.016, fontWeight: FontWeight.w400),
                                ),

                              ],
                            )

                          ],
                        ),
                      ),


                    ),

                    SizedBox(height: screenHeight*0.02,),

                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [

                        FaIcon(FontAwesomeIcons.moneyCheckAlt),
                        SizedBox(width: screenWidth*0.04 ,),
                        Text(
                          "Cash",
                          style: TextStyle(fontSize: screenHeight*0.022, fontWeight: FontWeight.w500),
                        ),

                        SizedBox(width: screenWidth*0.01,),

                        Icon(Icons.keyboard_arrow_down, color: Colors.black54,size: screenHeight*0.02,),

                      ],
                    ),
                    ),

                    SizedBox(height: screenHeight*0.035,),


                    Container(
                      width: screenWidth*0.8,
                      height: screenHeight*0.09,
                      child: ElevatedButton(onPressed: (){

                        displayRequestRideContainer();

                      },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            backgroundColor: CupertinoColors.systemYellow.withOpacity(0.75),
                          ),
                          child: Row(
                                                  children: [

                          SizedBox(width: screenWidth*0.03,),

                          Text(
                            "Request",
                            style: TextStyle(fontSize: screenHeight*0.022, fontWeight: FontWeight.w500, color: Colors.black54),
                          ),

                          SizedBox(width: screenWidth*0.3,),

                          FaIcon(FontAwesomeIcons.automobile, color: Colors.black54,),



                                                  ],
                                                )),
                    )

                  ],
                ),

              ),


            ),

          ),



/////////////////////////////////////////////////////////////////////////////REQUESTING A RIDE////////////////////////////////////////////////////////////////////////////
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,

              child: AnimatedSize(

                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),

                child: Container(
                height: requestRideContainerHeight,
                color: Colors.white,

                child: Container(
                height: requestRideContainerHeight, // Responsive height based on screen height
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

                  child: Column(
                    children: [
                      SizedBox(height: screenHeight*0.05,),



                      ////////////////////////ANIMATED TEXTTTTTT <3 ////////////////////////////////////

                         SizedBox(
                           width: screenWidth,
                           child: ColorizeAnimatedTextKit(

                 onTap: (){
                   print('Tap Event');
                 },

                   text: [

                     'Requesting a Ride...',
                     'Please Wait...',
                     'Finding a Driver...',
                     'Requesting a Ride...',
                     'Please Wait...',
                     'Finding a Driver...',
                     'Requesting a Ride...',
                     'Please Wait...',
                     'Finding a Driver...',


                   ],

                   textStyle: TextStyle(
                     fontSize: screenHeight*0.03,
                     fontWeight: FontWeight.bold,
                     //fontFamily:
                   ),

                   colors: [

                     Colors.black,
                     Colors.black38,
                     //CupertinoColors.systemYellow,

                   ],

                 textAlign: TextAlign.center,



                           ),
                         ),



                 SizedBox(height: screenHeight*0.050,),

                 Container(
                   height: screenHeight*0.08,
                   width: screenWidth*0.17,

                   decoration: BoxDecoration(
                     color: CupertinoColors.systemYellow,
                     borderRadius: BorderRadius.circular(26.0),
                     border: Border.all(width: 2, color: Colors.black38),
                   ),

                   child: Icon(Icons.close, size: screenHeight*0.03,),
                 ),


                      SizedBox(height: screenHeight*0.02,),

                      Text("Cancel Ride", style: TextStyle(fontSize: screenHeight*0.02),)






                    ],
                  ),
                    )




                ),
              ),
            ),],
      ),
    );
  }










//GET PLACE DIRECTION
  Future<void> getPlaceDirection() async {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    if (initialPos == null || finalPos == null) {
      // Handle the null scenario appropriately (show an error message or return early)
      print("Pickup or Dropoff location is not set");
      return;
    }

    var pickupLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropoffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  "Please Wait!",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );

    try {
      var details = await GeocodingRequest.obtainPlaceDirectionDetails(pickupLatLng, dropoffLatLng);

      Navigator.pop(context);

      if (details != null) {
        print("This is Encoded Points:");
        print(details.encodedpoints);







        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decodePolylinePointResult = polylinePoints.decodePolyline(details.encodedpoints);

        pLineCoordinates.clear();

        if(decodePolylinePointResult.isNotEmpty){
          decodePolylinePointResult.forEach((PointLatLng pointLatLng){
           pLineCoordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude)) ;
          });
        }

        polylineset.clear();

        setState(() {
          Polyline polyline = Polyline(
              color: Colors.pink,
              polylineId: PolylineId("PolylineID"),
              jointType: JointType.round,
              points: pLineCoordinates,
              width: 2,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              geodesic: true
          );


          polylineset.add(polyline);
        });

        LatLngBounds latlngbounds;
        if(pickupLatLng.latitude > dropoffLatLng.latitude && pickupLatLng.longitude > dropoffLatLng.longitude){
          latlngbounds = LatLngBounds(southwest: dropoffLatLng, northeast:pickupLatLng);
        }

        else if(pickupLatLng.longitude > dropoffLatLng.longitude){
          latlngbounds = LatLngBounds(southwest: LatLng(pickupLatLng.latitude, dropoffLatLng.longitude), northeast:LatLng(dropoffLatLng.latitude, pickupLatLng.longitude));
        }


        else if(pickupLatLng.latitude > dropoffLatLng.latitude){
          latlngbounds = LatLngBounds(southwest: LatLng(dropoffLatLng.latitude, pickupLatLng.longitude), northeast:LatLng(pickupLatLng.latitude, dropoffLatLng.longitude));
        }
        
        else{
          latlngbounds = LatLngBounds(southwest: pickupLatLng, northeast:dropoffLatLng);
        }
        
        newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latlngbounds, 70));


        Marker pickupLocMaker = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: initialPos.placeName, snippet: "My Location"),
          position: pickupLatLng,
          markerId: MarkerId("Pickupid"),
        );

        Marker dropoffLocMaker = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Dropoff Location"),
          position: dropoffLatLng,
          markerId: MarkerId("Dropoffid"),
        );

        setState(() {
          markersset.add(pickupLocMaker);
          markersset.add(dropoffLocMaker);
        });
        
        Circle pickupLocCircle = Circle(
            fillColor: Colors.blue,
            circleId: CircleId("Pickupid"),
            center: pickupLatLng,
            radius: 12,
            strokeWidth: 4,
            strokeColor: Colors.grey,

        );

        Circle dropoffLocCircle = Circle(
          fillColor: Colors.blue,
          circleId: CircleId("Dropoffid"),
          center: dropoffLatLng,
          radius: 12,
          strokeWidth: 4,
          strokeColor: Colors.grey,

        );

        setState(() {
          circlesset.add(pickupLocCircle);
          circlesset.add(dropoffLocCircle);
        });

        




      } else {
        print("Failed to retrieve direction details.");
        // Show an error message or handle this scenario as needed
      }
    } catch (e) {
      Navigator.pop(context);
      print("An error occurred: $e");
      // Handle or show the error as needed
    }


  }

}
