import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/activity.dart';
import 'package:healthapp/screens/calendar.dart';
import 'package:healthapp/screens/food.dart';
import 'package:healthapp/screens/goals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/screens/sleep.dart';
import '../components/heart_rate.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  int _selectedIndex = 0;
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
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Food()),
        );
        break;
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
              'Welcome Back',
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
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.transparent,
                elevation: 8, // Shadow intensity
                shadowColor: Colors.black.withOpacity(0.2), // Shadow color with transparency
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BMI (Body Mass Index)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your calculated BMI is below:',
                            style: TextStyle(
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _showBmiCalculator,
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFC58BF2), Color(0xFFEEA4CE)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                child: Text(
                                  'Update Weight and Height',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          _bmi > 0 ? _bmi.toStringAsFixed(1) : 'Loading...', // Display BMI or loading
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
                    "Today's Target",
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

            // Adjust Add Goals Section
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
                    "Adjust Add Goals",
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AddGoalsScreen()),
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
                          'Adjust/Add',
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
        Container(
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
          padding: EdgeInsets.all(16),
          child: HeartBPMComponent(), // The original component inside the container
        ),
            //water
            SizedBox(height: 16),
            // Water Intake Tracker
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vertical Progress Bar
                  Stack(
                    alignment: Alignment.bottomCenter, // Ensure the fill starts from the bottom
                    children: [
                      Container(
                        width: 20,
                        height: 300, // Increase the height of the bar
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: (_currentWaterIntake / _dailyWaterGoal) * 300, // Dynamic height calculation
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [Color(0xFFC58BF2), Color(0xFFB4C0FE)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  // Text Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Water Intake',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins', // Set Poppins font
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '4 Liters',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins', // Set Poppins font
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Real-time updates',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins', // Set Poppins font
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUpdateRow('6am - 8am', '600ml'),
                            _buildUpdateRow('9am - 11am', '500ml'),
                            _buildUpdateRow('11am - 2pm', '1000ml'),
                            _buildUpdateRow('2pm - 4pm', '700ml'),
                            _buildUpdateRow('4pm - now', '900ml'),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => _addWaterIntake(200),
                              child: Text(
                                '+200 ml',
                                style: TextStyle(fontFamily: 'Poppins'), // Set Poppins font
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _addWaterIntake(500),
                              child: Text(
                                '+500 ml',
                                style: TextStyle(fontFamily: 'Poppins'), // Set Poppins font
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /////////
            SizedBox(height: 16),
            Row(
              children: [
                // First Box
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(0.0), // Add margin around the boxes
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Calories',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            '760 kCal',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: Colors.white, // Must set this to show gradient
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Custom Circular Progress Bar
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background Circle
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),// Background color
                                ),
                              ),
                              // Gradient Progress Circle
                              CustomPaint(
                                size: Size(120, 120),
                                painter: GradientCircularProgressPainter(
                                  progress: 0.7, // Adjust progress (0.0 - 1.0)
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFC58BF2), Color(0xFFB4C0FE)],
                                  ),
                                ),
                              ),
                              // Center Text
                               Text(
                                  '350 Cal',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white, // Required to show the gradient
                                  ),
                                ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Second Box
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8.0), // Add margin around the boxes
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sleep',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            '8h 20m',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: Colors.white, // Must set this to show gradient
                            ),
                          ),
                        ),
                        SizedBox(height: 16), // Space between text and image
                        Image.asset(
                          'assets/Sleep-Graph.png', // Replace with your image path
                          height: 100, // Adjust height as needed
                          width: 100, // Adjust width as needed
                          fit: BoxFit.cover, // Adjust fit as needed
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
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Food',
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
