import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeocodingRequest {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";

    // URL for reverse geocoding
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyDVHfnBiF57K1ZUqP2wImN5zE95Ue2ZALI";

    try {
      // Make the HTTP request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        var data = jsonDecode(response.body);

        // Extract the address from the response
        if (data['results'] != null && data['results'].isNotEmpty) {
          placeAddress = data['results'][0]['formatted_address'];
        } else {
          placeAddress = "No address found";
        }
      } else {
        placeAddress = "Failed to get address: ${response.statusCode}";
      }
    } catch (e) {
      placeAddress = "Failed to get address: $e";
    }

    return placeAddress;  // Ensure that a string is always returned
  }
}
