import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chalo_kart_driver/Assistance/assistance_methods.dart';
import 'package:chalo_kart_driver/global/global.dart';
import 'package:chalo_kart_driver/models/user_ride_request_information.dart';
import 'package:chalo_kart_driver/screens/new_trip_screen.dart';

class NotificationDialogBox extends StatefulWidget {
  final UserRideRequestInformation userRideRequestDetails;

  const NotificationDialogBox({
    super.key,
    required this.userRideRequestDetails,
  });

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            
            // Car image
            Image.asset(
              "images/car.png",
              width: 120,
              height: 120,
            ),
            
            // New Ride Request title
            const SizedBox(height: 10),
            Text(
              "New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 15),
            
            // Divider line
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            
            // Pickup location
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.userRideRequestDetails.originAddress!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Destination location
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.flag,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.userRideRequestDetails.destinationAddress!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            //number of seats
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),

                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Number of Seats : 5",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider line
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            
            // Buttons row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Cancel the ride request
                        FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails.rideRequestId!).remove().then((value) {
                          FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("newRideStatus").set("idle");
                        }).then((value) {
                          FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("tripsHistory").child(widget.userRideRequestDetails.rideRequestId!).remove();
                        }).then((value) {
                          Fluttertoast.showToast(msg: "Ride Request has been Cancelled.");
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 15),
                  
                  // Accept Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Accept the ride request
                        acceptRideRequest(context);
                      },
                      child: Text(
                        "ACCEPT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    String getRideRequestId = "";
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) {
      // if (snap.snapshot.value != null) {
      //   getRideRequestId = snap.snapshot.value.toString();
      // } else {
      //   Fluttertoast.showToast(msg: "This ride request do not exists.");
      // }

      if (snap.snapshot.value=="idle") {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(firebaseAuth.currentUser!.uid)
            .child("newRideStatus")
            .set("accepted");

        AssistantMethods.pauseLiveLocationUpdates();
        
        // Navigate to new trip screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => NewTripScreen(
              userRideRequestDetails: widget.userRideRequestDetails,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "This ride request do not exists.");
      }
    });
  }
}
