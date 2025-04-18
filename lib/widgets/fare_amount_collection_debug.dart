import 'package:flutter/material.dart';
import 'package:chalo_kart_driver/screens/splash_screen.dart';

class FareAmountCollectionDialog extends StatefulWidget{
  final double totalFareAmount;
  const FareAmountCollectionDialog({super.key, required this.totalFareAmount});
  
  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();
}

class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              "Trip Fare Amount",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "₹ ${widget.totalFareAmount.toString()}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "This is the total trip fare amount",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onPressed: () {
                  // Navigate back to home screen after 1 second delay
                  Future.delayed(Duration(milliseconds: 1000), () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (c) => SplashScreen())
                    );
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Collect Cash",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${widget.totalFareAmount.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
