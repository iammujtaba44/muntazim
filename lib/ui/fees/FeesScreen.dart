import 'package:flutter/material.dart';
import 'package:muntazim/core/plugins.dart';

class FeesScreen extends StatefulWidget {
  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: CustomColors.darkBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.payment_rounded,
                size: 90,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Text(
              "Payment!",
              style: TextStyle(
                color: CustomColors.darkBackgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Coming soon",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              "You will be redirected to the home page shortly\nor click here to return to home page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: CustomColors.darkBackgroundColor,
              child: Icon(Icons.arrow_back_sharp),
            )
          ],
        ),
      ),
    );
  }
}
