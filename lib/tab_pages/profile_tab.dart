// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:untitled1/global/global.dart';
// import 'package:untitled1/screens/main_screen.dart';
// import 'package:untitled1/screens/sign_in_screen.dart';
// import 'package:untitled1/screens/splash_screen.dart';
// import 'package:untitled1/tab_pages/home_tab.dart';
//
// class ProfileTabPage extends StatefulWidget {
//   const ProfileTabPage({super.key});
//
//   @override
//   State<ProfileTabPage> createState() => _ProfileTabPageState();
// }
//
// class _ProfileTabPageState extends State<ProfileTabPage> {
//
//   final nameTextEditingController = TextEditingController();
//
//   DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
//
//   Future<void> showDriverNameDialogAlert(BuildContext context, String name) {
//     nameTextEditingController.text = name;
//
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Update"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: nameTextEditingController,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 userRef
//                     .child(firebaseAuth.currentUser!.uid)
//                     .update({
//                   "name": nameTextEditingController.text.trim(),
//                 })
//                     .then((value) {
//                   nameTextEditingController.clear();
//                   Fluttertoast.showToast(
//                     msg: "Updated Successfully.\nReload the app to see the changes",
//                   );
//                 })
//                     .catchError((errorMessage) {
//                   Fluttertoast.showToast(
//                     msg: "Error Occurred. \n$errorMessage",
//                   );
//                 });
//
//                 Navigator.pop(context);
//               },
//               child: const Text(
//                 "Ok",
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF4CE5B1),
//         leading: GestureDetector(
//           onTap: (){
//             Navigator.pop(context);
//             // Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
//           },
//           child: Icon(Icons.arrow_back, color: Colors.black),
//         ),
//         title: Text(
//           "Profile",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: Color(0xFF4CE5B1),
//                   width: 2,
//                 ),
//                 color: Colors.grey.shade100,
//               ),
//               padding: EdgeInsets.all(3),
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Colors.grey.shade200,
//                 child: Icon(
//                   Icons.person,
//                   size: 60,
//                   color: Color(0xFF4CE5B1),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               onlineDriverData.name ?? "Driver",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               onlineDriverData.email ?? "driver@example.com",
//               style: TextStyle(
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               margin: EdgeInsets.symmetric(horizontal: 40),
//               decoration: BoxDecoration(
//                 color: Color(0xFFE8F8F3),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 children: [
//                   _buildInfoRow(Icons.phone, onlineDriverData.phone ?? "Phone Number"),
//                   SizedBox(height: 10),
//                   _buildInfoRow(Icons.car_repair, onlineDriverData.carModel ?? "Car Model"),
//                   SizedBox(height: 10),
//                   _buildInfoRow(Icons.color_lens, onlineDriverData.carColor ?? "Car Color"),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: ElevatedButton(
//                 onPressed: () {
//                   firebaseAuth.signOut();
//                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.logout),
//                     SizedBox(width: 10),
//                     Text(
//                       "Sign Out",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           color: Color(0xFF4CE5B1),
//           size: 20,
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.black87,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chalo_kart_driver/global/global.dart';
import 'package:chalo_kart_driver/screens/main_screen.dart';
import 'package:chalo_kart_driver/screens/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  // Controller for name editing only
  final nameTextEditingController = TextEditingController();

  // Database reference from second file
  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");

  // Dialog method for name editing only
  Future<void> showDriverNameDialogAlert(BuildContext context, String name) {
    nameTextEditingController.text = name;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Name"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Enter new name",
                    labelText: "Name",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                userRef
                    .child(firebaseAuth.currentUser!.uid)
                    .update({
                  "name": nameTextEditingController.text.trim(),
                })
                    .then((value) {
                  nameTextEditingController.clear();
                  Fluttertoast.showToast(
                    msg: "Updated Successfully.\nReload the app to see the changes",
                  );
                })
                    .catchError((errorMessage) {
                  Fluttertoast.showToast(
                    msg: "Error Occurred. \n$errorMessage",
                  );
                });

                Navigator.pop(context);
              },
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

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
          "Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF4CE5B1),
                  width: 2,
                ),
                color: Colors.grey.shade100,
              ),
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF4CE5B1),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  onlineDriverData.name ?? "Driver",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDriverNameDialogAlert(context, onlineDriverData.name ?? "Driver");
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xFF4CE5B1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              onlineDriverData.email ?? "driver@example.com",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Color(0xFFE8F8F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.phone, onlineDriverData.phone ?? "Phone Number"),
                  SizedBox(height: 10),
                  _buildInfoRow(Icons.car_repair, onlineDriverData.carModel ?? "Car Model"),
                  SizedBox(height: 10),
                  _buildInfoRow(Icons.color_lens, onlineDriverData.carColor ?? "Car Color"),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: () {
                  firebaseAuth.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF4CE5B1),
          size: 20,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}