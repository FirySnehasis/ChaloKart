import 'package:chalo_kart_driver/utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:chalo_kart_driver/screens/splash_screen.dart';
import 'package:chalo_kart_driver/models/user_ride_request_information.dart';
import 'package:chalo_kart_driver/screens/car_info_screen.dart';
import 'package:chalo_kart_driver/screens/main_screen.dart';
import 'package:chalo_kart_driver/screens/new_trip_screen.dart';
import 'package:chalo_kart_driver/themeProvider/theme_provider.dart';
import 'package:chalo_kart_driver/widgets/fare_amount_collection_debug.dart';

import 'infoHandler/app_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'ChaloKArt Driver',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.32, 0.32, 1],
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor,
                  Color(0xFFF8F8F8),
                  Color(0xFFF8F8F8),
                ],
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }
}

