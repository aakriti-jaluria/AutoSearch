import 'package:auto_search/resources/google_maps_services.dart';
import 'package:flutter/material.dart';
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
    print('This is your current address: ' +address);

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
      ),
      body: Stack(
        children: [
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



          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,

              child: Container(
                height: 320.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular((18.0)),),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      spreadRadius: 0.2,
                      offset: Offset(0.7,0.7),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 15.0,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text("Hi There", style: TextStyle(fontSize: 16),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text("Where to?",style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500), ),
                    ),

                    SizedBox(height: 20.0,),

                Center(
                  child: Container(
                    height: 50 ,
                    width: 380,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          spreadRadius: 0.1,
                          offset: Offset(0.7,0.7),
                        )
                      ],
                    ),

                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.search, color: Colors.blue,),
                        ),
                        //SizedBox(width: 10.0,),
                        Text("Search Drop Off"),
                      ],
                    ),
                  ),
                ),

                    SizedBox(height: 15.0,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(

                        children: [
                          Icon(Icons.home, color: Colors.grey,),

                          SizedBox(width: 15.0,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Home"),
                              SizedBox(height: 4.0,),
                              Text('Your living home address', style: TextStyle(color: Colors.grey, fontSize:  12.0),),

                                 ]   ),],),
                    ),



                            SizedBox(height: 15.0,),
                            DividerWidget(),
                            SizedBox(height: 15.0,),


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Icon(Icons.work, color: Colors.grey,),

                                  SizedBox(width: 15.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Add Work"),
                                      SizedBox(height: 4.0,),
                                      Text('Your office address', style: TextStyle(color: Colors.grey, fontSize:  12.0),),

                                  ]   ),],),
                            ),

                          ],
                        )

                    ),





          )],
                ),



    );
  }
}
