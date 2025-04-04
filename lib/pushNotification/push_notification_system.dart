import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chalo_kart_driver/global/global.dart';
import 'package:chalo_kart_driver/models/user_ride_request_information.dart';
import 'package:chalo_kart_driver/pushNotification/notification_dialog_box.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    // 1. Terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        try {
          print("TERMINATED MESSAGE DATA: ${remoteMessage.data}");
          print("TERMINATED MESSAGE ALL KEYS: ${remoteMessage.data.keys.toList()}");
          
          // Try all possible key variations
          var rideRequestId = remoteMessage.data["ride_request_id"] ?? 
                            remoteMessage.data["rideRequestId"] ?? 
                            remoteMessage.data["rideRequestID"] ??
                            remoteMessage.data["request_id"];
                            
          if (rideRequestId != null) {
            print("Found ride request ID with value: $rideRequestId");
            readUserRideRequestInformation(rideRequestId.toString(), context);
          } else {
            print("No ride request ID found in notification");
          }
        } catch (e) {
          print("ERROR in Firebase getInitialMessage: $e");
          print("Data that caused error: ${remoteMessage.data}");
        }
      }
    }).catchError((error) {
      print("ERROR getting initial message: $error");
    });
    
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      try {
        print("FOREGROUND MESSAGE DATA: ${remoteMessage.data}");
        print("FOREGROUND MESSAGE ALL KEYS: ${remoteMessage.data.keys.toList()}");
        
        // Try all possible key variations
        var rideRequestId = remoteMessage.data["ride_request_id"] ?? 
                           remoteMessage.data["rideRequestId"] ?? 
                           remoteMessage.data["rideRequestID"] ??
                           remoteMessage.data["request_id"];
                         
        if (rideRequestId != null) {
          print("Found ride request ID with value: $rideRequestId");
          readUserRideRequestInformation(rideRequestId.toString(), context);
        } else {
          print("No ride request ID found in notification data");
        }
      } catch (e) {
        print("ERROR in Firebase onMessage listener: $e");
        print("Data that caused error: ${remoteMessage.data}");
      }
    });

    // 3. Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      try {
        print("BACKGROUND MESSAGE DATA: ${remoteMessage.data}");
        print("BACKGROUND MESSAGE ALL KEYS: ${remoteMessage.data.keys.toList()}");
        
        // Try all possible key variations
        var rideRequestId = remoteMessage.data["ride_request_id"] ?? 
                           remoteMessage.data["rideRequestId"] ?? 
                           remoteMessage.data["rideRequestID"] ??
                           remoteMessage.data["request_id"];
                         
        if (rideRequestId != null) {
          print("Found ride request ID with value: $rideRequestId");
          readUserRideRequestInformation(rideRequestId.toString(), context);
        } else {
          print("No ride request ID found in notification data");
        }
      } catch (e) {
        print("ERROR in Firebase onMessageOpenedApp listener: $e");
        print("Data that caused error: ${remoteMessage.data}");
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: $registrationToken");

    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }

  // void readUserRideRequestInformation(String userRideRequestId, BuildContext context) {
  //   FirebaseDatabase.instance.ref()
  //       .child("All Ride Requests")
  //       .child(userRideRequestId)
  //       .once()
  //       .then((snapData) {
  //     if (snapData.snapshot.value!= null) {
  //       try {
  //         // audioPlayer.open(Audio("audio/alert.mp3"),);
  //         // audioPlayer.play();
  //
  //         Map rideRequestMap = snapData.snapshot.value as Map;
  //         print("RIDE REQUEST DATA: $rideRequestMap");
  //
  //         double originLat = double.parse(rideRequestMap["origin"]["latitude"].toString());
  //         double originLng = double.parse(rideRequestMap["origin"]["longitude"].toString());
  //         String originAddress = rideRequestMap["originAddress"].toString();
  //
  //         double destinationLat = double.parse(rideRequestMap["destination"]["latitude"].toString());
  //         double destinationLng = double.parse(rideRequestMap["destination"]["longitude"].toString());
  //         String destinationAddress = rideRequestMap["destinationAddress"].toString();
  //
  //         String userName = rideRequestMap["userName"].toString();
  //         String userPhone = rideRequestMap["userPhone"].toString();
  //
  //         UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation(
  //           originLatLng: LatLng(originLat, originLng),
  //           originAddress: originAddress,
  //           destinationLatLng: LatLng(destinationLat, destinationLng),
  //           destinationAddress: destinationAddress,
  //           userName: userName,
  //           userPhone: userPhone,
  //           rideRequestId: userRideRequestId,
  //         );
  //
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) => NotificationDialogBox(
  //             userRideRequestDetails: userRideRequestDetails,
  //           ),
  //         );
  //       } catch (e) {
  //         print("Error processing ride request: $e");
  //         Fluttertoast.showToast(msg: "Error processing ride request: $e");
  //       }
  //     } else {
  //       Fluttertoast.showToast(msg: "This Ride Request ID does not exist.");
  //     }
  //   }).catchError((error) {
  //     print("ERROR fetching ride request: $error");
  //     Fluttertoast.showToast(msg: "Error fetching ride request: $error");
  //   });
  // }
  readUserRideRequestInformation(String userRideRequestId, BuildContext context){
    FirebaseDatabase.instance.ref().child("All Ride Requests").child(userRideRequestId).child("driverId").onValue.listen((event){
      if(event.snapshot.value =="waiting" || event.snapshot.value==firebaseAuth.currentUser!.uid){
        FirebaseDatabase.instance.ref().child("All Ride Requests").child(userRideRequestId).once().then((snapData){
          if(snapData.snapshot.value!=null){
            // audioPlayer.open(Audio("audio/alert.mp3"),);
            // audioPlayer.play();
            double originLat = double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"].toString());
            double originLng = double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"].toString());
            String originAddress = (snapData.snapshot.value! as Map)["originAddress"];

            double destinationLat = double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"].toString());
            double destinationLng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"].toString());
            String destinationAddress = (snapData.snapshot.value! as Map)["destinationAddress"];

            String userName=(snapData.snapshot.value! as Map)["userName"];
            String userPhone=(snapData.snapshot.value! as Map)["userPhone"];

            String? rideRequestId = snapData.snapshot.key;

            UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();

            userRideRequestDetails.originLatLng=LatLng(originLat, originLng);
            userRideRequestDetails.destinationLatLng=LatLng(destinationLat, destinationLng);
            userRideRequestDetails.originAddress=originAddress;
            userRideRequestDetails.destinationAddress=destinationAddress;
            userRideRequestDetails.userName=userName;
            userRideRequestDetails.userPhone=userPhone;
            userRideRequestDetails.rideRequestId=rideRequestId;

            showDialog(
              context: context,
              builder: (BuildContext context) => NotificationDialogBox(
                userRideRequestDetails: userRideRequestDetails,
              ),
            );
          }
          else{
            Fluttertoast.showToast(msg: "This Ride Request ID does not exist.");
          }
        });
      }
      else{
        Fluttertoast.showToast(msg: "This Ride Request has been canceled");
        Navigator.pop(context);
      }
    });
  }
}