import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/activity.dart';
import 'package:healthapp/screens/calendar.dart';
import 'package:healthapp/screens/goals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/screens/home.dart';
import 'package:healthapp/screens/sleep-week.dart';
import 'package:healthapp/screens/sleep.dart';
import '../components/heart_rate.dart';

class Food extends StatefulWidget {
  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  String userName = '';  // Store the user name here

  @override
  void initState() {
    super.initState();
    _getUserName();
  }
  String? selectedValue; // Holds the current value

  // Function to get the user's height and weight from Firestore and calculate BMI

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


  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _selectedIndex = 1;

  // Function to handle navigation between screens
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the corresponding screen based on index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Sleep()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WorkoutTrackerApp()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WorkoutScheduleScreen()),
        );
        break;
    }
  }




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
                              'Last Night Sleep',
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

            // Target
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
                    "Daily Meal Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Adjust if needed
                    ),
                  ),
                Expanded(child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
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
                        MaterialPageRoute(builder: (context) => SleepWeek()),
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
                )),
                ],
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bold "Today's Schedule" Text
            Row(
            children: [
            Text(
            "Today's Meal Schedule",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Adjust if needed
              ),
            ),
            Spacer(), // Pushes the dropdown to the right
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue,
                  hint: Text(
                    'Select Meal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Adjust for contrast
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: Color(0xFF9DCEFF), // Matches gradient for consistency
                  items: ['Breakfast', 'Lunch', 'Dinner'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                    print('Selected meal: $newValue');
                  },
                ),
              ),
            ),
          ],
        ),

    SizedBox(height: 16), // Spacing below the header
                // First Card (Bedtime)
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
                        // Bed Icon
                        Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.lightBlueAccent,
                        ),
                        SizedBox(width: 16), // Spacing between icon and text
                        // Text Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Salmon Nigiri',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '9:00 PM',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16), // Spacing between cards
                // Second Card (Alarm)
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
                        // Bed Icon
                        Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.lightBlueAccent,
                        ),
                        SizedBox(width: 16), // Spacing between icon and text
                        // Text Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Salmon Nigiri',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '9:00 PM',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Today's Meal Schedule",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust if needed
                  ),
                ),
        Container(
          height: 250, // Adjust as needed
          decoration: BoxDecoration(

          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Box 1
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 200, // Fixed width for each box
                        height: 200, // Fixed height for each box
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Breakfast-Card.png'), // Image for Box 1
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Positioned(
                        top: 100, // Position the text above the button
                        left: 0,
                        right: 55,
                        child: Center(
                          child: Text(
                            'Breakfast', // Text above the button
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 38,
                        left: 0,
                        right: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 80,
                              child: Text(
                                'Lunch',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            // Add your action for Button 1
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Box 2
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Lunch-Card.png'), // Image for Box 2
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Positioned(
                        top: 120, // Position the text above the button
                        left: 0,
                        right: 75,
                        child: Center(
                          child: Text(
                            'Lunch', // Text above the button
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 18,
                        left: 0,
                        right: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFC58BF2), Color(0xFFEEA4CE)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 80,
                              child: Text(
                                'Button 2',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            // Add your action for Button 2
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Box 3
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Dinner.png'), // Image for Box 3
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Positioned(
                        top: 100, // Position the text above the button
                        left: 0,
                        right: 75,
                        child: Center(
                          child: Text(
                            'Dinner', // Text above the button
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 38,
                        left: 0,
                        right: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFDCB560), Color(0xFFFFB46EFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 80,
                              child: Text(
                                'Button 3',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            // Add your action for Button 3
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent, // Neon blue color for selected items
        unselectedItemColor: Colors.blueGrey, // BlueGrey for unselected items
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
  Widget _buildUpdateRow(String time, String intake) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            intake,
            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
  ));
}
