import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/calendar.dart';
import 'package:healthapp/screens/fullbody.dart';
import 'package:healthapp/screens/home.dart';
import 'package:healthapp/screens/sleep.dart';

void main() => runApp(const WorkoutTrackerApp());

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const WorkoutTrackerScreen(),
    );
  }
}

class WorkoutTrackerScreen extends StatefulWidget {
  const WorkoutTrackerScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutTrackerScreen> createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  int _selectedIndex = 2;

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
          MaterialPageRoute(builder: (context) => const WorkoutTrackerApp()),
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "Workout Tracker",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Graph Section
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: const [
                          FlSpot(0, 20),
                          FlSpot(1, 40),
                          FlSpot(2, 30),
                          FlSpot(3, 70),
                          FlSpot(4, 50),
                          FlSpot(5, 90),
                          FlSpot(6, 60),
                        ],
                        color: Colors.blue,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Sun');
                              case 1:
                                return const Text('Mon');
                              case 2:
                                return const Text('Tue');
                              case 3:
                                return const Text('Wed');
                              case 4:
                                return const Text('Thu');
                              case 5:
                                return const Text('Fri');
                              case 6:
                                return const Text('Sat');
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Daily Workout Section
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
                          MaterialPageRoute(builder: (context) => WorkoutApp()),
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
              const SizedBox(height: 20),
              // Upcoming Workouts Section
              Text(
                "Upcoming Workout",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              WorkoutCard(
                title: "Fullbody Workout",
                date: "Today, 03:00pm",
                isActive: true,
              ),
              WorkoutCard(
                title: "Upperbody Workout",
                date: "June 05, 02:00pm",
                isActive: false,
              ),
              const SizedBox(height: 20),
              // Training Options Section
              Text(
                "What Do You Want to Train",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              TrainingOptionCard(
                title: "Fullbody Workout",
                exercises: "11 Exercises | 32mins",
              ),
              TrainingOptionCard(
                title: "Lowbody Workout",
                exercises: "12 Exercises | 40mins",
              ),
              TrainingOptionCard(
                title: "AB Workout",
                exercises: "14 Exercises | 20mins",
              ),
            ],
          ),
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
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String date;
  final bool isActive;

  const WorkoutCard({
    Key? key,
    required this.title,
    required this.date,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.fitness_center, color: Colors.blue),
        ),
        title: Text(title, style: GoogleFonts.poppins()),
        subtitle: Text(date, style: GoogleFonts.poppins(fontSize: 12)),
        trailing: Switch(
          value: isActive,
          onChanged: (value) {},
          activeTrackColor: const Color(0xFFC58BF2),
          activeColor: const Color(0xFFEEA4CE),
        ),
      ),
    );
  }
}

class TrainingOptionCard extends StatelessWidget {
  final String title;
  final String exercises;

  const TrainingOptionCard({
    Key? key,
    required this.title,
    required this.exercises,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.directions_run, color: Colors.green),
        ),
        title: Text(title, style: GoogleFonts.poppins()),
        subtitle: Text(exercises, style: GoogleFonts.poppins(fontSize: 12)),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("View more"),
        ),
      ),
    );
  }
}
