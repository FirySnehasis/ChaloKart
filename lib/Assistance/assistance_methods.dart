import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:chalo_kart_driver/Assistance/request_assistant.dart';
import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/direction.dart';
import '../models/direction_details_with_polyline.dart';
import '../models/trip_history_model.dart';
import '../models/user_model.dart';

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUser!.uid);
    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeoCoordinates(Position position, context) async {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position
        .latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error occurred, no response") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickupAddress = Directions();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickupLocationAddress(
          userPickupAddress);
    }
    return humanReadableAddress;
  }

  static Future<(DirectionDetailsWithPolyline, dynamic)> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async {
    DirectionDetailsWithPolyline directionDetailsWithPolyline = DirectionDetailsWithPolyline();
    // print("Function called");
    var responseDirectionApi = await RequestAssistant
        .receiveRequestForDirectionDetails(originPosition, destinationPosition);
    DirectionDetailsWithPolyline nullInstance = DirectionDetailsWithPolyline(
      e_points: null,
      distance_value_in_meters: null,
      duration_text_in_s: null,
    );
    // print(responseDirectionApi);
    if (responseDirectionApi == "Error occurred, no response") {
      return (nullInstance, "");
    }
    directionDetailsWithPolyline.e_points =
    responseDirectionApi["routes"][0]["polyline"]["encodedPolyline"];
    directionDetailsWithPolyline.distance_value_in_meters =
    responseDirectionApi["routes"][0]["distanceMeters"];
    directionDetailsWithPolyline.duration_text_in_s =
    responseDirectionApi["routes"][0]["duration"];
    // print("asdf");
    // print(responseDirectionApi["routes"][0]["polyline"]["encodedPolyline"]);
    return (directionDetailsWithPolyline, responseDirectionApi["routes"][0]["polyline"]["encodedPolyline"]);
  }
  static Future<void> pauseLiveLocationUpdates() async {
    // if (streamSubscriptionPosition != null) {
    //   streamSubscriptionPosition!.pause();
    // }
    // if (currentUser != null) {
    //   Geofire.removeLocation(currentUser!.uid);
    // }
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentUser!.uid);
  }
  // static double calculateFareAmountFromOriginToDestination((DirectionDetailsWithPolyline, dynamic) directionDetails) {
  //   double timeTravelledFareAmountPerMinute = (double.parse(directionDetails.$1.duration_text_in_s!) / 60) * 0.1;
  //   double distanceTravelledFareAmountPerKilometer = (directionDetails.$1.distance_value_in_meters! / 1000) * 0.1;
  //   double totalFareAmount = timeTravelledFareAmountPerMinute + distanceTravelledFareAmountPerKilometer;
  //   double localCurrencyTotalFare = totalFareAmount * 107;
  //
  //   // Default value if no car type data available
  //   String carType = onlineDriverData.carType ?? "standard";
  //
  //   if(carType == "6-seater Cart"){
  //     double resultFareAmount = (localCurrencyTotalFare.truncate()) * 2;
  //     return resultFareAmount;
  //   }
  //   else if(carType=="12-seater Cart"){
  //     double resultFareAmount = (localCurrencyTotalFare.truncate()) * 2;
  //     return resultFareAmount;
  //   }
  //
  //   return localCurrencyTotalFare.truncate().toDouble();
  // }

  // static double calculateFareAmountFromOriginToDestination(DirectionDetailsWithPolyline directionDetailsWithPolyline,) {
  //   double timeTravelledFareAmountPerMinute =
  //       (directionDetailsWithPolyline.distance_value_in_meters! / 60) * 0.1;
  //   double distanceTravelledFareAmountPerKilometer =
  //       (directionDetailsWithPolyline.distance_value_in_meters! / 1000) * 0.1;
  //   double totalFareAmount =
  //       timeTravelledFareAmountPerMinute +
  //           distanceTravelledFareAmountPerKilometer;
  //   return double.parse(totalFareAmount.toStringAsFixed(1));
  // }

  static void readTripsKeysForOnlineDriver(context){
    FirebaseDatabase.instance.ref().child("All Ride Requests").orderByChild("driverId").equalTo(firebaseAuth.currentUser!.uid).once().then((snap){
      if(snap.snapshot.value != null){
        Map keysTripsId = snap.snapshot.value as Map;
        int overAllTripsCounter =keysTripsId.length;
        Provider.of<AppInfo>(context,listen: false).updateOverAllTripsCounter(overAllTripsCounter);
        List<String> tripsKeysList =[];
        keysTripsId.forEach((key,value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context,listen: false).updateOverAllTripsKeys(tripsKeysList);
        readTripsHistoryInformation(context);
      }
    });
  }
  static void readTripsHistoryInformation(context){
    var tripsAllKeys = Provider.of<AppInfo>(context,listen: false).historyTripsKeyList;
    for(String eachKey in tripsAllKeys){
      FirebaseDatabase.instance.ref().child("All Ride Requests").child(eachKey).once().then((snap){
        var  eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);
        if((snap.snapshot.value as Map)["status"] ==  "ended"){
          Provider.of<AppInfo>(context,listen: false).updateOverAllTripsHistoryInformation(eachTripHistory);
        }
      });
    }

  }
  static void readDriverEarnings(context){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").once().then((snap){
      if(snap.snapshot.value  != null){
        String driverEarnings= snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverTotalEarnings(driverEarnings);
      }
    });
    readTripsKeysForOnlineDriver(context);
  }
  static void readDriverRatings(context){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("ratings").once().then((snap){
      if(snap.snapshot.value  != null){
        String driverRatings= snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverAverageRatings(driverRatings);
      }
    });
  }

}
