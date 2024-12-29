import 'package:flutter/material.dart';
import 'package:healthapp/screens/home.dart';
import 'package:healthapp/start/5th.dart';

class FthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/Frame2.png', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),

          // Text at the top of the screen
          Positioned(
            top: 450,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eat Healthy',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Join us in starting a healthy lifestyle! We can help you plan your daily diet and show you how enjoyable healthy eating can be.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Button at the bottom right
          Positioned(
            bottom: 30,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // Navigate to the next screen or perform an action
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SthScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
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
