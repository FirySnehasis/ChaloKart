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
  // String ratings = "0.0";
  double ratingsNumber=0;
  @override
  void initState() {
    super.initState();
    // getDriverRatings();
  }
  //
  // void getDriverRatings() async {
  //   // Get ratings from Firebase
  //   DatabaseReference ratingsRef = FirebaseDatabase.instance
  //       .ref()
  //       .child("drivers")
  //       .child(firebaseAuth.currentUser!.uid)
  //       .child("ratings");
  //
  //   ratingsRef.once().then((snap) {
  //     if(snap.snapshot.value != null) {
  //       setState(() {
  //         ratings = snap.snapshot.value.toString();
  //       });
  //     }
  //   });
  // }
  getRatingsNumber(){
    setState(() {
      ratingsNumber = double.parse(Provider.of<AppInfo>(context,listen:false).driverAverageRatings);
    });
    setupRatingsTitle();
  }
  setupRatingsTitle(){

    if(ratingsNumber >=0){
      setState(() {
        titleStarsRating = "Very Bad";
      });
    }
    if(ratingsNumber >=0){
      setState(() {
        titleStarsRating = " Bad";
      });
    }
    if(ratingsNumber >=0){
      setState(() {
        titleStarsRating = "Good";
      });
    }
    if(ratingsNumber >=0){
      setState(() {
        titleStarsRating = "Very Good";
      });
    }
    if(ratingsNumber >=0){
      setState(() {
        titleStarsRating = "Excellent";
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Color(0xFF4CE5B1),
    //     leading: GestureDetector(
    //       onTap: (){
    //         Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
    //       },
    //       child: Icon(Icons.arrow_back, color: Colors.black),
    //     ),
    //     title: Text(
    //       "Ratings",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     elevation: 0,
    //   ),
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       // Ratings card
    //       Container(
    //         width: double.infinity,
    //         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    //         padding: EdgeInsets.symmetric(vertical: 30),
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(15),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.grey.withOpacity(0.1),
    //               blurRadius: 10,
    //               spreadRadius: 5,
    //             ),
    //           ],
    //         ),
    //         child: Column(
    //           children: [
    //             Text(
    //               "Your Rating",
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 color: Colors.grey[700],
    //               ),
    //             ),
    //             SizedBox(height: 20),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Icon(
    //                   Icons.star,
    //                   size: 60,
    //                   color: Colors.amber,
    //                 ),
    //                 SizedBox(width: 10),
    //                 Text(
    //                   ratingsNumber.toString(),
    //                   style: TextStyle(
    //                     fontSize: 50,
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.black87,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(height: 15),
    //             Container(
    //               margin: EdgeInsets.symmetric(horizontal: 40),
    //               child: _buildStarRow(double.parse(ratingsNumber.toString())),
    //             ),
    //           ],
    //         ),
    //       ),
    //
    //       // Rating details
    //       Container(
    //         padding: EdgeInsets.all(20),
    //         margin: EdgeInsets.symmetric(horizontal: 20),
    //         decoration: BoxDecoration(
    //           color: Color(0xFFE8F8F3),
    //           borderRadius: BorderRadius.circular(15),
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               "Rating Details",
    //               style: TextStyle(
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.black87,
    //               ),
    //             ),
    //             SizedBox(height: 15),
    //             _buildRatingDetail("Excellent", "5 Stars", 0.8),
    //             SizedBox(height: 10),
    //             _buildRatingDetail("Good", "4 Stars", 0.15),
    //             SizedBox(height: 10),
    //             _buildRatingDetail("Average", "3 Stars", 0.05),
    //             SizedBox(height: 10),
    //             _buildRatingDetail("Below Average", "2 Stars", 0.0),
    //             SizedBox(height: 10),
    //             _buildRatingDetail("Poor", "1 Star", 0.0),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    bool darkTheme= MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkTheme? Colors.black:Colors.white,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: darkTheme? Colors.white:Colors.white60,
        child: Container(
          margin: EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
            color: darkTheme? Colors.black : Colors.white54,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0,),
              Text(
                "your Ratings",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: darkTheme?Colors.amber.shade400:Colors.blue,
                ),
              ),
              SizedBox(height: 20,),
              // SmoothStarRating(
              //   rating: ratingsNumber,
              //   allowHalfRating:true,
              //   starCount:5,
              //   color:darkTheme?Colors.amber.shade400:Colors.blue,
              //   borderColor : darkTheme? Colors.amber.shade400:Colors.blue,
              //   size:46,
              // ),
              SizedBox(height: 12.0,),
              Text(
                titleStarsRating,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: darkTheme?Colors.amber.shade400:Colors.blue,
                ),
              ),
              SizedBox(height: 18.0,),
            ],
          ),
        ),
      ),
    );
  }
  
  // Widget _buildStarRow(double rating) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: List.generate(5, (index) {
  //       if (index < rating.floor()) {
  //         // Full star
  //         return Icon(Icons.star, color: Colors.amber, size: 24);
  //       } else if (index == rating.floor() && rating % 1 > 0) {
  //         // Half star
  //         return Icon(Icons.star_half, color: Colors.amber, size: 24);
  //       } else {
  //         // Empty star
  //         return Icon(Icons.star_border, color: Colors.amber, size: 24);
  //       }
  //     }),
  //   );
  // }
  //
  // Widget _buildRatingDetail(String label, String stars, double percentage) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         flex: 2,
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey[700],
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         flex: 2,
  //         child: Text(
  //           stars,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey[600],
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         flex: 6,
  //         child: Stack(
  //           children: [
  //             Container(
  //               height: 10,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.shade300,
  //                 borderRadius: BorderRadius.circular(5),
  //               ),
  //             ),
  //             FractionallySizedBox(
  //               widthFactor: percentage,
  //               child: Container(
  //                 height: 10,
  //                 decoration: BoxDecoration(
  //                   color: Color(0xFF4CE5B1),
  //                   borderRadius: BorderRadius.circular(5),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Expanded(
  //         flex: 1,
  //         child: Text(
  //           "${(percentage * 100).toInt()}%",
  //           textAlign: TextAlign.right,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey[600],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
