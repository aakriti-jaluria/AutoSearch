import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpRequest {
  // Method to make a GET request
  static Future<dynamic> getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        //return Text('Failed to load data: ${response.statusCode}');
        return Text("Failed");
      }
    } catch (e) {
      //return Text('Failed to make request: $e');
      return Text("Failed");
    }
  }
}
