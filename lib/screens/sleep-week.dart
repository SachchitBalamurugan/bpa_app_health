import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/screens/alarm.dart';
import 'package:healthapp/screens/sleep.dart';

class SleepWeek extends StatefulWidget {
  @override
  _SleepWeekState createState() => _SleepWeekState();
}

class _SleepWeekState extends State<SleepWeek> {
  String userName = '';
  int selectedDayIndex = -1;
  String bedtime = "No data available";
  String alarm = "No data available";
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  // Function to get the user's name from Firestore
  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
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

  // Function to fetch bedtime and alarm data for a specific day
  Future<void> _fetchDayData(String day) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot alarmDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('alarms')
          .doc('alarm1') // Access the specific alarm document
          .get();

      if (alarmDoc.exists) {
        Map<String, dynamic>? data = alarmDoc.data() as Map<String, dynamic>?;
        if (data != null && (data['repeatDays'] as List).contains(day)) {
          setState(() {
            bedtime = data['bedtime'] ?? "No data available";
            alarm = data['sleepHours'] ?? "No data available";
          });
        } else {
          setState(() {
            bedtime = "No data available for $day";
            alarm = "No data available for $day";
          });
        }
      } else {
        setState(() {
          bedtime = "No data available";
          alarm = "No data available";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Change the color as needed
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey, // Set the color of the back button
          ),
          onPressed: () {
            // Handle the back button press
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Sleep()),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sleep Tracker',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            Text(
              userName.isNotEmpty ? userName : 'Loading...',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Welcome Section

            SizedBox(height: 16),
            //card up big
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
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
                      colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
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
                              'Ideal Hours for Sleep',
                              style: TextStyle(
                                fontFamily: 'Poppins', // Use Poppins font
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8), // Add spacing between texts
                            Text(
                              '8hours 30minutes',
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
                    "Add Alarm",
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
                          '+',
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
            // Days of the Week Card Selection
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  bool isSelected = index == selectedDayIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          selectedDayIndex = isSelected ? -1 : index;
                        });
                        if (!isSelected) {
                          await _fetchDayData(days[index]);
                        }
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
                            color: isSelected ? null : Color(0xFFE9EDFE),
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
            SizedBox(height: 16),
            // Display Sleep and Alarm Data with Icons
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bedtime Card with Icon
                _buildDataCard(
                  icon: Icons.bed,
                  iconColor: Colors.purple,
                  label: "Bedtime",
                  value: bedtime,
                ),
                SizedBox(height: 16),
                // Alarm Card with Icon
                _buildDataCard(
                  icon: Icons.alarm,
                  iconColor: Colors.red,
                  label: "Alarm",
                  value: alarm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the data cards
  Widget _buildDataCard({required IconData icon, required Color iconColor, required String label, required String value}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xFFE9EDFE),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
