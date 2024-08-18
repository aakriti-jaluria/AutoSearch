import 'package:auto_search/data_handler/app_data.dart';
import 'package:auto_search/login_page.dart';
import 'package:auto_search/resources/google_maps_services.dart';
import 'package:auto_search/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:auto_try/google_maps_service.dart';
//import 'package:auto_try/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'maps_screen.dart';

// Setup locator
void setuplocator() {
  GetIt.I.registerLazySingleton(() => GoogleMapsService());
}

void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  setuplocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

//provider package setup , we r taking data from AppData and we'll use it globally

    return ChangeNotifierProvider(

      create: (context) => AppData(),

      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          useMaterial3: true,
        ),
        home: MapScreen(),
      ),
    );
  }
}