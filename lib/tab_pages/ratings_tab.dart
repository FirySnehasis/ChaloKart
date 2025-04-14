import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:chalo_kart_driver/global/global.dart';

import '../infoHandler/app_info.dart';
import '../screens/main_screen.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({super.key});

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {
  String ratings = "0.0";
  double ratingsNumber = 0;

  @override
  void initState() {
    super.initState();
    getDriverRatings();
  }

  //
  void getDriverRatings() async {
    // Get ratings from Firebase
    DatabaseReference ratingsRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("ratings");

    ratingsRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        setState(() {
          ratings = snap.snapshot.value.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4CE5B1),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => MainScreen()));
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Ratings",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ratings card
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Color(0xFF4CE5B1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Your Rating",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  // " ₹${Provider.of<AppInfo>(context,listen: false).driverTotalEarnings}",
                  " $ratings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

}