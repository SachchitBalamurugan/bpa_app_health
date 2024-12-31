import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthapp/screens/activity.dart';
import 'package:healthapp/screens/home.dart';
import 'package:healthapp/screens/sleep.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WorkoutScheduleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WorkoutScheduleScreen extends StatefulWidget {
  @override
  _WorkoutScheduleScreenState createState() => _WorkoutScheduleScreenState();
}

class _WorkoutScheduleScreenState extends State<WorkoutScheduleScreen> {
  User? user;
  Map<DateTime, List<String>> workoutData = {};
  DateTime selectedDate = DateTime.now();
  int _selectedIndex = 3;

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
  void initState() {
    super.initState();
    fetchUserAndWorkouts();
  }

  // Function to handle conversion of Timestamp to DateTime
  DateTime convertTimestampToDateTime(Timestamp timestamp) {
    try {
      // Convert the Firestore Timestamp to DateTime
      DateTime dateTime = timestamp.toDate();

      // Adjust for UTC-6 by subtracting 6 hours
      dateTime = dateTime.subtract(Duration(hours: 6));

      return dateTime;
    } catch (e) {
      print("Error converting Timestamp: $e");
      return DateTime.now(); // Return current time in case of error
    }
  }

  Future<void> fetchUserAndWorkouts() async {
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in!");
      return;
    }

    final String userId = user!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .get();

    final Map<DateTime, List<String>> data = {};
    for (var doc in snapshot.docs) {
      try {
        final dynamic timestamp = doc['date']; // 'date' is a Timestamp in Firestore
        if (timestamp is Timestamp) {
          final DateTime date = convertTimestampToDateTime(timestamp); // Convert Timestamp to DateTime

          // Fetching the workout data
          final String workout = doc['workout'];

          // Add the workout to the correct date and time slot
          data.putIfAbsent(date, () => []).add(workout);
        }
      } catch (e) {
        print("Error processing workout document: $e");
      }
    }

    setState(() {
      workoutData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Workout Schedule',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final date = DateTime.now().add(Duration(days: index - 2));
                final isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(colors: [
                            Color(0xFF92A3FD),
                            Color(0xFF9DCEFF),
                          ])
                              : null,
                          color: !isSelected ? Colors.grey[200] : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          DateFormat('d').format(date),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Schedule
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, index) {
                final hour = index;
                final DateTime currentDateTime =
                DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hour);

                // Retrieve workouts for this time slot
                final List<String> workouts = workoutData[currentDateTime] ?? [];
                return ListTile(
                  leading: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  title: workouts.isEmpty
                      ? const Text('No workouts scheduled', style: TextStyle(color: Colors.grey))
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: workouts
                        .map((workout) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFC58BF2),
                            Color(0xFFEEA4CE),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Workout: $workout',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
                        .toList(),
                  ),
                );
              },
            ),
          ),
          // Floating Add Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF92A3FD),
              onPressed: () {
                // Handle Add Workout
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
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
