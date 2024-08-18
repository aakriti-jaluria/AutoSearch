 import 'package:auto_search/Models/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{

  // we will create some instances and strings - which will be available all over the application
  //we will define that in main.dart



  /////////////////////////(ERROR)
 Address? pickUpLocation;






 void updatePickUpLocationAddress(Address userPickUpAddress)
 {
   pickUpLocation = userPickUpAddress;
   notifyListeners(); // any changes by users will get broadcasted

   // we'll update this in geocoding request
 }


}