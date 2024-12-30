import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/sleep-week.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: AddAlarmScreen(),
    );
  }
}

class AddAlarmScreen extends StatefulWidget {
  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  String selectedBedtime = "09:00 PM";
  String selectedSleepHours = "8 Hours 30 Minutes";
  List<String> selectedDays = ["Mon", "Tue"];
  bool vibrate = true;
  bool loading = false;

  final List<String> bedtimes = [
    "09:00 PM",
    "10:00 PM",
    "11:00 PM",
    "12:00 AM",
    "01:00 AM"
  ];
  final List<String> sleepHours = [
    "6 Hours",
    "7 Hours",
    "8 Hours",
    "8 Hours 30 Minutes",
    "9 Hours",
    "10 Hours"
  ];
  final List<String> weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  void saveAlarmToFirebase() async {
    setState(() {
      loading = true;
    });

    try {
      // Ensure the user is logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Prepare alarm data
      final alarmData = {
        "bedtime": selectedBedtime,
        "sleepHours": selectedSleepHours,
        "repeatDays": selectedDays,
        "vibrate": vibrate,
        "lastUpdated": DateTime.now(),
      };

      // Save to Firebase under the user's collection
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("alarms")
          .doc("alarm1") // Replace with unique ID if multiple alarms
          .set(alarmData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Alarm saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving alarm: $e")),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SleepWeek()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "Add Alarm",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            DropdownTile(
              title: "Bedtime",
              value: selectedBedtime,
              items: bedtimes,
              onChanged: (value) {
                setState(() {
                  selectedBedtime = value!;
                });
              },
            ),
            DropdownTile(
              title: "Hours of sleep",
              value: selectedSleepHours,
              items: sleepHours,
              onChanged: (value) {
                setState(() {
                  selectedSleepHours = value!;
                });
              },
            ),
            MultiSelectTile(
              title: "Repeat",
              selectedItems: selectedDays,
              items: weekdays,
              onChanged: (selected) {
                setState(() {
                  selectedDays = selected;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.vibration, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Vibrate When Alarm Sound",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Switch(
                  value: vibrate,
                  onChanged: (value) {
                    setState(() {
                      vibrate = value;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            if (loading)
              CircularProgressIndicator()
            else
              GradientButton(
                text: "Save",
                onPressed: saveAlarmToFirebase,
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class DropdownTile extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  DropdownTile({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.bed, color: Colors.grey),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          DropdownButton<String>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class MultiSelectTile extends StatelessWidget {
  final String title;
  final List<String> selectedItems;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;

  MultiSelectTile({
    required this.title,
    required this.selectedItems,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Wrap(
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return GestureDetector(
              onTap: () {
                final updatedItems = [...selectedItems];
                if (isSelected) {
                  updatedItems.remove(item);
                } else {
                  updatedItems.add(item);
                }
                onChanged(updatedItems);
              },
              child: Chip(
                label: Text(item),
                backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
