import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:chalo_kart_driver/global/global.dart';

import '../infoHandler/app_info.dart';
import '../screens/main_screen.dart';

class EarningTabPage extends StatefulWidget {
  const EarningTabPage({super.key});

  @override
  State<EarningTabPage> createState() => _EarningTabPageState();
}

class _EarningTabPageState extends State<EarningTabPage> {
  // String earnings = "0";
  
  @override
  void initState() {
    super.initState();
    // getDriverEarnings();
  }
  
  // void getDriverEarnings() async {
  //   DatabaseReference earningsRef = FirebaseDatabase.instance
  //       .ref()
  //       .child("drivers")
  //       .child(firebaseAuth.currentUser!.uid)
  //       .child("earnings");
  //
  //   earningsRef.once().then((snap) {
  //     if(snap.snapshot.value != null) {
  //       setState(() {
  //         earnings = snap.snapshot.value.toString();
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4CE5B1),
        leading: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Earnings",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Earnings card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Color(0xFF4CE5B1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF4CE5B1).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Total Earnings",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  " ₹${Provider.of<AppInfo>(context,listen: false).driverTotalEarnings}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Stats section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Statistics",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 15),
                _buildStatCard(Icons.add_road, "Total Trips", "0"),
                SizedBox(height: 10),
                _buildStatCard(Icons.star, "Rating", "5.0"),
                SizedBox(height: 10),
                _buildStatCard(Icons.handshake, "Completed Trips", "0"),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFE8F8F3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Color(0xFF4CE5B1),
              size: 22,
            ),
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
