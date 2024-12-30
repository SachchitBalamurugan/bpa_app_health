import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/goals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/screens/home.dart';
import 'package:healthapp/screens/sleep-week.dart';
import '../components/heart_rate.dart';

class Sleep extends StatefulWidget {
  @override
  _SleepState createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  String userName = '';  // Store the user name here

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getUserData();
  }

  // Function to get the user's height and weight from Firestore and calculate BMI
  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)  // User ID from FirebaseAuth
          .get();

      if (userDoc.exists) {
        // Get height and weight values
        var height = userDoc['height'];
        var weight = userDoc['weight'];

        // Convert them to double if needed
        double heightInCm = (height is String ? double.tryParse(height) : (height is int ? height.toDouble() : 0.0)) ?? 0.0;
        double weightInKg = (weight is String ? double.tryParse(weight) : (weight is int ? weight.toDouble() : 0.0)) ?? 0.0;

        // Calculate BMI if both height and weight are available
        if (heightInCm > 0 && weightInKg > 0) {
          setState(() {
            // Convert height to meters and calculate BMI
            double heightInM = heightInCm / 100;
            _bmi = weightInKg / (heightInM * heightInM);
          });
        }
      } else {
        print('User document not found!');
      }
    }
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

  int _selectedIndex = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;



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
    // case 2:
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => ProfileScreen()),
    //   );
    //   break;
    }
  }

  double _bmi = 0; // Initial BMI value
  List<double> pieData = [20.1, 79.9]; // Placeholder pie data for BMI
  int _currentWaterIntake = 0; // Current water intake in milliliters
  final int _dailyWaterGoal = 2000; // Daily water intake goal in milliliters
  void _showBmiCalculator() {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        // card weight and height
        return AlertDialog(
          title: Text('Update'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
              ),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Height (cm)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Parse the weight and height values
                double? weight = double.tryParse(weightController.text);
                double? height = double.tryParse(heightController.text);

                if (weight != null && height != null && height > 0) {
                  // Update Firestore with the new values
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      // Update height and weight under the user's document
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid) // Use the logged-in user's ID
                          .update({
                        'weight': weight,
                        'height': height,
                      });

                      // Calculate BMI
                      double heightInM = height / 100; // Convert cm to meters
                      double bmi = weight / (heightInM * heightInM);

                      setState(() {
                        _bmi = bmi; // Update BMI value
                      });

                      Navigator.of(context).pop(); // Close the dialog
                    } catch (e) {
                      // Handle error while updating Firestore
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to update information: $e'),
                      ));
                    }
                  } else {
                    // User is not logged in
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('You must be logged in to update information.'),
                    ));
                    Navigator.of(context).pop(); // Close the dialog if not logged in
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter valid weight and height values'),
                  ));
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _addWaterIntake(int amount) {
    setState(() {
      _currentWaterIntake += amount;
      if (_currentWaterIntake > _dailyWaterGoal) {
        _currentWaterIntake = _dailyWaterGoal;
      }
    });
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
                ],
              ),
            ),
            SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bold "Today's Schedule" Text
            Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                      Icons.bed,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(width: 16), // Spacing between icon and text
                    // Text Content
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
                          '9:00 PM',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'In 6 hours 22 minutes',
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
                    // Alarm Icon
                    Icon(
                      Icons.alarm,
                      size: 40,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 16), // Spacing between icon and text
                    // Text Content
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
                          '7:00 AM',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'In 14 hours 22 minutes',
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
        ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Call _onItemTapped when an item is tapped
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

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;

  GradientCircularProgressPainter({
    required this.progress,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint backgroundPaint = Paint()
      ..color = Color(0xFFF7F8F8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final Paint progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, backgroundPaint);

    // Draw progress arc
    final double startAngle = -90 * (3.14159 / 180); // Start at the top
    final double sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
