import 'package:auto_search/Models/address.dart';
import 'package:auto_search/data_handler/app_data.dart';
import 'package:auto_search/httprequest.dart'; // Import the generalized HttpRequest class
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class GeocodingRequest {
  static Future<String> searchCoordinateAddress(Position position, context) async {
    String placeAddress = "";

    //for address_components
    String st1, st2, st3, st4;

    // URL for reverse geocoding
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyDVHfnBiF57K1ZUqP2wImN5zE95Ue2ZALI";

    try {
      // Make the HTTP request using the generalized HttpRequest class
      final data = await HttpRequest.getRequest(url);

      // Extract the address from the response
      if (data['results'] != null && data['results'].isNotEmpty) {

        //placeAddress = data['results'][0]['formatted_address'];    ////////////this is not safe , so we use address_components
        st1 = data['results'][0]['address_components'][0]["long_name"];//[0]["long_name"] index pr we will house number (Check documentation)
        st2 = data['results'][0]['address_components'][1]["long_name"];// to get the street address
        st3 = data['results'][0]['address_components'][5]["long_name"];//city
        st4 = data['results'][0]['address_components'][6]["long_name"];//state or country

        placeAddress = st1 + "," + st2 + "," + st3 + "," + st4;

        //address declared here
        // Address userPickUpAddress = new Address();
        // userPickUpAddress.longitude = position.longitude;
        // userPickUpAddress.latitude = position.latitude;
        // userPickUpAddress.placeName = placeAddress;

        Address userPickUpAddress = Address(
            placeAddress,     // placeFormattedAddress
            placeAddress,     // placeName (same as formatted address)
            "",               // placeId (empty or your ID)
            position.latitude, // latitude
            position.longitude // longitude
        );

        //save this info by provider class - AppData class

        //updating provider class here
        Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);  /////listen : false , as we r only updating the pickupaddress
        // context passed in map_screen also : position k saath , string address mein

        //we r doing changes in SEARCH DROP OFF ----- saving the HOME ADDRESS permanently in home column ----- visit map_screen

      } else {
        placeAddress = "No address found";
      }
    } catch (e) {
      placeAddress = "Failed to get address: $e";
    }

    return placeAddress;  // Ensure that a string is always returned
  }
}
