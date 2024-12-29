import 'package:flutter/material.dart';
import 'package:healthapp/screens/home.dart';
import 'package:healthapp/start/6th.dart';

class SthScreen extends StatelessWidget {
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
              'assets/Frame (3).png', // Replace with your image asset path
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
                  'Improve Sleep  Quality',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enhance your sleep quality with us—waking up in a great mood starts with a good night\'s rest!',
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
                  MaterialPageRoute(builder: (context) => VthScreen()),
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
