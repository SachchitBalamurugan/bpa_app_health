import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/alarm.dart';
import 'package:healthapp/screens/goals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/screens/home.dart';
import 'package:healthapp/screens/sleep.dart';
import '../components/heart_rate.dart';

class SleepWeek extends StatefulWidget {
  @override
  _SleepWeekState createState() => _SleepWeekState();
}

class _SleepWeekState extends State<SleepWeek> {
  String userName = '';  // Store the user name here
  int selectedDayIndex = -1;

  @override
  void initState() {
    super.initState();
    _getUserName();

  }





  // Function to get the user's name from Firestore
  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)  // User ID from FirebaseAuth
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? 'No name available';
        });
      } else {
        print('User document not found!');
      }
    }
  }

  int _selectedIndex = 2;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  List<String> scheduleData = [
    'Bedtime: 9:00 PM\nIn 6 hours 22 minutes',
    'Bedtime: 9:30 PM\nIn 6 hours 52 minutes',
    'Bedtime: 10:00 PM\nIn 7 hours 22 minutes',
    'Bedtime: 10:30 PM\nIn 7 hours 52 minutes',
    'Bedtime: 11:00 PM\nIn 8 hours 22 minutes',
    'Bedtime: 11:30 PM\nIn 8 hours 52 minutes'
  ];
  List<String> alarmData = [
    'Alarm: 7:00 AM\nIn 14 hours 22 minutes',
    'Alarm: 7:30 AM\nIn 14 hours 52 minutes',
    'Alarm: 8:00 AM\nIn 15 hours 22 minutes',
    'Alarm: 8:30 AM\nIn 15 hours 52 minutes',
    'Alarm: 9:00 AM\nIn 16 hours 22 minutes',
    'Alarm: 9:30 AM\nIn 16 hours 52 minutes'
  ];


  // Function to handle navigation between screens





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Welcome Section
            Text(
              'Sleep Tracker',
              style: GoogleFonts.poppins(
                fontSize: 18, // Smaller size
                fontWeight: FontWeight.normal, // Regular weight
                color: Colors.grey, // Gray color
              ),
            ),
            // Name in a new line, bigger and bold
            Text(
              userName.isNotEmpty ? userName : 'Loading...',
              style: GoogleFonts.poppins(
                fontSize: 28, // Bigger size
                fontWeight: FontWeight.bold, // Bold weight
              ),
            ),

            SizedBox(height: 16),

            // BMI Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE9EDFE), Color(0xFFEBF3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE9EDFE), Color(0xFFEBF3FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ideal Hours For Sleep',
                              style: TextStyle(
                                fontFamily: 'Poppins', // Use Poppins font
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8), // Add spacing between texts
                            Text(
                              '7 hours, 45 minutes',
                              style: TextStyle(
                                fontFamily: 'Poppins', // Use Poppins font
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Positioned image at the bottom
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/Sleep-Graph.png', // Replace with your asset path
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bold "Your Schedule" Text
            Text(
              'Your Schedule',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16), // Spacing below the header

            // Days of the Week Card Selection
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6, // Only 6 days are present
                itemBuilder: (context, index) {
                  bool isSelected = index == selectedDayIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = isSelected ? -1 : index; // Toggle selection
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                              colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : null,
                            color: isSelected ? null : Color(0xFFE9EDFE), // Default color
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                days[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16), // Spacing between the schedule and cards
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEBF3FF), Color(0xFFE9EDFF)], // Gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Shadow color with transparency
                    spreadRadius: 2, // How far the shadow spreads
                    blurRadius: 6, // The softness of the shadow
                    offset: Offset(0, 3), // Position of the shadow (x, y)
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daily Sleep Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Adjust if needed
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(32, 32), // Smaller button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0, // Optional: Remove shadow for a flat look
                    ),
                    onPressed: () {
                      // Add your button action here
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AddAlarmScreen()),
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Check',
                          style: TextStyle(
                            fontSize: 12, // Smaller text size
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Card for selected schedule day
            if (selectedDayIndex != -1) ...[
              // Bedtime Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bed,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bedtime',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            scheduleData[selectedDayIndex].split('\n')[0],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            scheduleData[selectedDayIndex].split('\n')[1],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16), // Spacing between Bedtime and Alarm Cards

              // Alarm Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.alarm,
                        size: 40,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alarm',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            alarmData[selectedDayIndex].split('\n')[0],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            alarmData[selectedDayIndex].split('\n')[1],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),

      ],
        ),
      ),

    );
  }


}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
  ));
}



