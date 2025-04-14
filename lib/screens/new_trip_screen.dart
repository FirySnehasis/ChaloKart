import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chalo_kart_driver/global/global.dart';
import 'package:chalo_kart_driver/models/user_ride_request_information.dart';
import 'package:chalo_kart_driver/screens/splash_screen.dart';

import '../Assistance/assistance_methods.dart';
import '../widgets/fare_amount_collection_debug.dart';
import '../widgets/progress_dialog.dart';
 
class NewTripScreen extends StatefulWidget {
  final UserRideRequestInformation userRideRequestDetails;
  
  const NewTripScreen({
    super.key,
    required this.userRideRequestDetails,
  });

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition_kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  String buttonTitle = "Arrived";
  Color ? buttonColor =Colors.green;
  Set<Marker> setOfMarkers = <Marker>{};
  Set<Circle> setOfCircles = <Circle>{};
  Set<Polyline> SetOfPolylines = <Polyline>{};
  List<LatLng> polylinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;
  StreamSubscription<Position>? streamSubscriptionDriverLivePosition;

  String rideRequestStatus = "accepted";
  String durationFromOriginToDestination = "";
  bool isRequestDirectionDetails = false;

  Future<void> drawPolylineFromOriginToDestination(LatLng originLatLng, LatLng destinationLatLng, bool darkTheme) async {
    showDialog(
      context: context,
      barrierDismissible: true, // Make dismissible by tapping outside
      builder: (BuildContext context) => ProgressDialog(message: "Please wait.....", timeoutSeconds: 20),
    );
    
    try {
      // Create a timeout for the network call
      var directionDetailsInfo = await Future.any([
        AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng),
        // Add a timeout of 15 seconds
        Future.delayed(Duration(seconds: 15)).then((_) {
          throw TimeoutException('The connection has timed out, please try again!');
        })
      ]);
      
      // Make sure to dismiss the dialog before proceeding
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // If the API returned null or empty data, show error and return
      if (directionDetailsInfo.$1.e_points == null) {
        Fluttertoast.showToast(msg: "Could not get directions. Please try again.");
        return;
      }
      
      PolylinePoints pPoints = PolylinePoints();
      List<PointLatLng> decodedPolylinePointsResultList = pPoints.decodePolyline(directionDetailsInfo.$1.e_points!);
      polylinePositionCoordinates.clear();

      if(decodedPolylinePointsResultList.isNotEmpty) {
        for (var pointLatLng in decodedPolylinePointsResultList) {
          polylinePositionCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        }
      }
      
      SetOfPolylines.clear();

      setState(() {
        Polyline polyline = Polyline(
          color: Colors.green.shade600,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: polylinePositionCoordinates,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          width: 5,
        );
        SetOfPolylines.add(polyline);
      });
      
      LatLngBounds boundsLatLng;
      if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude) {
        boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
      }
      else if(originLatLng.longitude > destinationLatLng.longitude) {
        boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        );
      }
      else if(originLatLng.latitude > destinationLatLng.latitude) {
        boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        );
      }
      else {
        boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
      }
      
      newTripGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
      
      Marker originMarker = Marker(
        markerId: MarkerId("originID"),
        position: originLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      
      Marker destinationMarker = Marker(
        markerId: MarkerId("destinationID"),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      setState(() {
        setOfMarkers.add(originMarker);
        setOfMarkers.add(destinationMarker);
      });
      
      Circle originCircle = Circle(
        circleId: CircleId("originID"),
        fillColor: Colors.green,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: originLatLng,
      );
      
      Circle destinationCircle = Circle(
        circleId: CircleId("destinationID"),
        fillColor: Colors.red,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: destinationLatLng,
      );

      setState(() {
        setOfCircles.add(originCircle);
        setOfCircles.add(destinationCircle);
      });
    } catch (e) {
      // Make sure to dismiss the dialog if there's an error
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      print("Error drawing polyline: $e");
      Fluttertoast.showToast(msg: "Error drawing route. Please try again.");
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      fetchFareAmount();
      saveAssignedDriverDetailsToUserRideRequest();
      
      // Set initial ride request status from database
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(widget.userRideRequestDetails.rideRequestId!)
          .child("status")
          .once()
          .then((snap) {
        if(snap.snapshot.value != null) {
          rideRequestStatus = snap.snapshot.value.toString();
          if(rideRequestStatus == "accepted") {
            buttonTitle = "Arrived";
            buttonColor = Colors.green.shade600;
          } else if(rideRequestStatus == "arrived") {
            buttonTitle = "Let's Go";
            buttonColor = Colors.green.shade600;
          } else if(rideRequestStatus == "ontrip") {
            buttonTitle = "End Trip";
            buttonColor = Colors.red;
          }
          
          if(mounted) {
            setState(() {});
          }
        }
      });
    } catch (e) {
      print("Error in initialization: $e");
    }
  }
  
  @override
  void dispose() {
    // Cancel the position stream subscription when widget is disposed
    if(streamSubscriptionDriverLivePosition != null) {
      streamSubscriptionDriverLivePosition!.cancel();
    }
    super.dispose();
  }
  
  void getDriverLocationUpdatesAtRealTime() {
    LatLng oldLatLng = LatLng(0, 0);
    streamSubscriptionDriverLivePosition = Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;
      
      LatLng latLngLiveDriverPosition = LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);
      
      Marker animatingMarker = Marker(
        markerId: MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedMarker!,
        infoWindow: InfoWindow(title: "This is your position"),
      );
      
      setState(() {
        CameraPosition cameraPosition = CameraPosition(target: latLngLiveDriverPosition, zoom: 18);
        newTripGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        
        setOfMarkers.removeWhere((element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();

      // updating driver location at real time in database
      Map<String, String> driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString(),
      };
      
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(widget.userRideRequestDetails.rideRequestId!)
          .child("driverLocation")
          .set(driverLatLngDataMap);
    });
  }
  
  void updateDurationTimeAtRealTime() async {
    if(isRequestDirectionDetails == false) {
      isRequestDirectionDetails = true;
      if(onlineDriverCurrentPosition == null) {
        return;
      }

      var originLatLng = LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);
      LatLng destinationLatLng;
      
      if(rideRequestStatus == "accepted") {
        destinationLatLng = widget.userRideRequestDetails.originLatLng!; // user pickup location
      }
      else {
        destinationLatLng = widget.userRideRequestDetails.destinationLatLng!;
      }

      var directionInformation = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
      
      setState(() {
        durationFromOriginToDestination = directionInformation.$1.duration_text_in_s!;
      });

      isRequestDirectionDetails = false;
    }
  }
  
  void stopDriverLocationUpdatesAtRealTime() {
    if(streamSubscriptionDriverLivePosition != null) {
      streamSubscriptionDriverLivePosition!.cancel();
    }
  }
  
  void createDriverIconMarker() {
    if(iconAnimatedMarker == null && mounted) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png").then((value) {
        if(mounted) {
          setState(() {
            iconAnimatedMarker = value;
          });
        }
      });
    }
  }
  Future<void> fetchFareAmount() async {
    try {
      DatabaseEvent event = await FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(widget.userRideRequestDetails.rideRequestId!)
          .child("fareAmount")
          .once();

      if (event.snapshot.value != null) {
        setState(() {
          fareAmountString = event.snapshot.value.toString();
          // If you need the double value as well:
          totalFareAmount = double.tryParse(fareAmountString) ?? 0;
        });
      }
    } catch (error) {
      print("Error fetching fare amount: $error");
    }
  }
  void saveAssignedDriverDetailsToUserRideRequest() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("All Ride Requests")
        .child(widget.userRideRequestDetails.rideRequestId!);
    
    Map<String, String> driverLocationDataMap = {
      "Latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };
    
    // try {
    //   databaseReference.child("driverLocation").set(driverLocationDataMap);
    //   databaseReference.child("status").set("accepted");
    //   databaseReference.child("driverId").set(onlineDriverData.id);
    //   databaseReference.child("driverName").set(onlineDriverData.name);
    //   databaseReference.child("driverPhone").set(onlineDriverData.phone);
    //   databaseReference.child("ratings").set(onlineDriverData.ratings);
    //   databaseReference.child("car_details").set(
    //       "${onlineDriverData.carModel} ${onlineDriverData.carNumber} (${onlineDriverData.carColor})");
    //
    //   saveRideRequestIdToDriverHistory();
    // } catch (e) {
    //   print("Error saving driver details: $e");
    // }

    if(databaseReference.child("driverId")!="waiting"){
      Map<String, String> driverCarInfoMap = {
        "car_model": onlineDriverData.carModel!,
        "car_number": onlineDriverData.carNumber!,
        "car_color": onlineDriverData.carColor!,
        "car_type": onlineDriverData.carType!,
      };
      databaseReference.child("driverLocation").set(driverLocationDataMap);
      databaseReference.child("status").set("accepted");
      databaseReference.child("driverId").set(onlineDriverData.id);
      databaseReference.child("driverName").set(onlineDriverData.name);
      databaseReference.child("driverPhone").set(onlineDriverData.phone);
      databaseReference.child("ratings").set(onlineDriverData.ratings);
      databaseReference.child("car_details").set(driverCarInfoMap);
      databaseReference.child("total_rides").set(onlineDriverData.totalRides);

      saveRideRequestIdToDriverHistory();

    }
    else{
      Fluttertoast.showToast(msg: "Ride is already accepted by another Driver. \n Reloading the app");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>SplashScreen()));
    }

  }
  
  void saveRideRequestIdToDriverHistory() {
    // try {
    //   if (firebaseAuth.currentUser != null) {
    //     DatabaseReference tripsHistoryRef = FirebaseDatabase.instance
    //         .ref()
    //         .child("drivers")
    //         .child(firebaseAuth.currentUser!.uid)
    //         .child("tripsHistory");
    //
    //     tripsHistoryRef.child(widget.userRideRequestDetails.rideRequestId!).set(true);
    //   }
    // } catch (e) {
    //   DatabaseReference tripsHistoryRef = FirebaseDatabase.instance
    //       .ref()
    //       .child("drivers")
    //       .child(firebaseAuth.currentUser!.uid)
    //       .child("tripsHistory");
    //
    //   tripsHistoryRef.child(widget.userRideRequestDetails.rideRequestId!).set(true);
    // }
    DatabaseReference tripsHistoryRef = FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("tripsHistory");
    tripsHistoryRef.child(widget.userRideRequestDetails.rideRequestId!).set(true);
  }
  
  void endTripNow() async {
    // Stop location updates when trip ends
    // stopDriverLocationUpdatesAtRealTime();
    
    showDialog(
      context: context,
      barrierDismissible: true, // Make dismissible
      builder: (BuildContext context) => ProgressDialog(message: "Calculating fare...", timeoutSeconds: 20),
    );
    
    // Make sure we have the current position
    onlineDriverCurrentPosition ??= driverCurrentPosition;
    
    try {
      var currentDriverPositionLatLng = LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);
      
      // Add timeout to API call
      var tripDirectionDetails = await Future.any([
        AssistantMethods.obtainOriginToDestinationDirectionDetails(
            currentDriverPositionLatLng, 
            widget.userRideRequestDetails.originLatLng!
        ),
        // Add a timeout of 15 seconds
        Future.delayed(Duration(seconds: 15)).then((_) {
          throw TimeoutException('The connection has timed out, please try again!');
        })
      ]);
      
      // Make sure to dismiss the progress dialog
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // If the API returned null or empty data, handle it
      // if (tripDirectionDetails.$1.e_points == null) {
      //   Fluttertoast.showToast(msg: "Could not calculate fare. Using default.");
      //   // Use a default fare amount in case of API failure
      //   double defaultFare = 150.0; // Set a reasonable default
      //
      //   updateRideStatus("ended", defaultFare);
      //   showFareDialog(defaultFare);
      //   return;
      // }

      // double totalFareAmount = AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetails);
      // String? fareAmountString="";
      // double totalFareAmount = 0;
      // // FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails.rideRequestId!).child("fareAmount").set(totalFareAmount.toString());
      // FirebaseDatabase.instance.ref()
      //     .child("All Ride Requests")
      //     .child(widget.userRideRequestDetails.rideRequestId!)
      //     .child("fareAmount")
      //     .once()
      //     .then((DatabaseEvent event) {
      //   if (event.snapshot.value != null) {
      //     fareAmountString = event.snapshot.value.toString();
      //     // fareAmountString=event.snapshot.value as String?;
      //   }
      //   else{
      //     fareAmountString="0";
      //   }
      // });

      FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails.rideRequestId!).child("status").set("ended");

      // Update the ride status and fare amount in the database
      updateRideStatus("ended");
      
      // Show fare amount dialog
      showFareDialog(totalFareAmount);
      
      // Save fare amount to driver's earnings
      saveFareAmountToDriverEarnings(totalFareAmount);
      onlineDriverData.totalRides!=(int.parse(onlineDriverData.totalRides!)+1).toString();
      
    } catch (e) {
      // Make sure to dismiss the progress dialog if there's an error
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      print("Error ending trip: $e");
      Fluttertoast.showToast(msg: "Something went wrong. Using default fare.");
      
      // Use a default fare in case of errors
      double defaultFare = 15;
      updateRideStatus("ended");
      showFareDialog(defaultFare);
    }
  }
  
  // Helper methods to make the code more modular
  void updateRideStatus(String status) {
    // FirebaseDatabase.instance
    //     .ref()
    //     .child("All Ride Requests")
    //     .child(widget.userRideRequestDetails.rideRequestId!)
    //     .child("fareAmount")
    //     .set(fareAmount.toString());
        
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(widget.userRideRequestDetails.rideRequestId!)
        .child("status")
        .set(status);
  }
  
  void showFareDialog(double totalFareAmount) {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FareAmountCollectionDialog(totalFareAmount: totalFareAmount),
      );
    }
  }

  void saveFareAmountToDriverEarnings(double totalFareAmount){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").once().then((snap){
      if(snap.snapshot.value != null){
        double oldEarnings= double.parse(snap.snapshot.value.toString());
        double driverTotalEarnings= totalFareAmount + oldEarnings;
        onlineDriverData.earnings = driverTotalEarnings.toString();
        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").set(driverTotalEarnings.toString());
      }
      else{
        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").set(totalFareAmount.toString());
        onlineDriverData.earnings = totalFareAmount.toString();
      }

    });
  }

  void _initializeTrip() {
    if (!mounted) return;
    
    // Delay a tiny bit to ensure map is fully loaded
    Future.delayed(Duration(milliseconds: 200), () {
      if (!mounted) return;
      
      try {
        // Check if driverCurrentPosition is not null before using it
        var driverLatLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
        
        // Draw appropriate route based on ride status
        if (rideRequestStatus == "accepted") {
          // If ride just accepted, draw route from driver to pickup point
          if (widget.userRideRequestDetails.originLatLng != null) {
            var userPickupLatLng = widget.userRideRequestDetails.originLatLng!;
            drawPolylineFromOriginToDestination(driverLatLng, userPickupLatLng, false);
          }
        } else if (rideRequestStatus == "arrived" || rideRequestStatus == "ontrip") {
          // If driver arrived or trip started, show route to destination
          if (widget.userRideRequestDetails.originLatLng != null && 
              widget.userRideRequestDetails.destinationLatLng != null) {
            drawPolylineFromOriginToDestination(
              widget.userRideRequestDetails.originLatLng!, 
              widget.userRideRequestDetails.destinationLatLng!, 
              false
            );
          }
        }
        
        // Start getting driver location updates
        getDriverLocationUpdatesAtRealTime();
      } catch (e) {
        print("Error initializing trip: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    
    // Create the driver icon marker here instead of in initState
    if (iconAnimatedMarker == null) {
      createDriverIconMarker();
    }
    
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition_kGooglePlex,
            markers: setOfMarkers,
            circles: setOfCircles,
            polylines: SetOfPolylines,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;

              setState(() {
                mapPadding = 270; // Set padding for the bottom panel
              });

              // Draw initial route after map is created
              _initializeTrip();
            },
          ),
          
          // Status bar at the top for duration
          if (durationFromOriginToDestination.isNotEmpty)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 0.2,
                        offset: Offset(0.6, 0.6),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.green.shade600,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        durationFromOriginToDestination,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom panel goes here
          
          // Status bar at the top
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(0.6, 0.6),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.green.shade600,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      durationFromOriginToDestination.isEmpty ? "Calculating..." : durationFromOriginToDestination,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom ride details panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // User info
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Text(
                            widget.userRideRequestDetails.userName!,

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Rating
                    if (rideRequestStatus == "accepted")
                      Padding(
                        padding: EdgeInsets.only(left: 25, bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "5.0",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Divider
                    Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                    SizedBox(height: 10),
                    
                    // Addresses
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Column(
                        children: [
                          // Pickup location
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  widget.userRideRequestDetails.originAddress!,
                                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          
                          // Dotted line between locations
                          if (widget.userRideRequestDetails.destinationAddress != null)
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 2,
                                    height: 25,
                                    child: Column(
                                      children: List.generate(
                                        5,
                                        (index) => Expanded(
                                          child: Container(
                                            color: index % 2 == 0 ? Colors.grey : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          // Destination location (if available)
                          if (widget.userRideRequestDetails.destinationAddress != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    widget.userRideRequestDetails.destinationAddress!,
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    
                    // Duration display
                    if (durationFromOriginToDestination.isNotEmpty && rideRequestStatus == "ontrip")
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              durationFromOriginToDestination,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    SizedBox(height: 10),
                    
                    // Action button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                        onPressed: () async {
                          if(rideRequestStatus == "accepted"){
                            rideRequestStatus = "arrived";
                            FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails.rideRequestId!).child("status").set(rideRequestStatus);

                            setState((){
                              buttonTitle = "Let's Go";
                              buttonColor = Colors.green.shade600;
                            });
                            
                            if (mounted) {
                              showDialog(
                                context: context,
                                barrierDismissible: true, // Allow dismissing by tapping outside
                                builder: (BuildContext context) => ProgressDialog(message: "Loading route...", timeoutSeconds: 20),
                              );
                            }
                            
                            try {
                              // Add a timeout to the route drawing
                              await Future.any([
                                drawPolylineFromOriginToDestination(
                                  widget.userRideRequestDetails.originLatLng!,
                                  widget.userRideRequestDetails.destinationLatLng!,
                                  darkTheme
                                ),
                                // Add a timeout of 20 seconds for the entire route drawing process
                                Future.delayed(Duration(seconds: 20)).then((_) {
                                  throw TimeoutException('Route drawing timed out. Please try again.');
                                })
                              ]);
                              
                              // Only dismiss the dialog if we didn't already dismiss it in drawPolylineFromOriginToDestination
                              if (mounted && Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              // Make sure to dismiss the dialog if there's an error
                              if (mounted && Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                              print("Error drawing route: $e");
                              Fluttertoast.showToast(msg: "Error drawing route. You can continue with the trip.");
                            }
                          }
                          else if(rideRequestStatus == "arrived"){
                            rideRequestStatus = "ontrip";
                            FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails.rideRequestId!).child("status").set(rideRequestStatus);

                            setState((){
                              buttonTitle = "End Trip";
                              buttonColor = Colors.red;
                            });
                          }
                          else if(rideRequestStatus == "ontrip"){
                            endTripNow();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              rideRequestStatus == "accepted" ? Icons.directions_walk :
                              rideRequestStatus == "arrived" ? Icons.directions_car :
                              Icons.stop_circle_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              buttonTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

