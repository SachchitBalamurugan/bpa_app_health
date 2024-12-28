import 'package:flutter/material.dart';

class WaterIntakeTracker extends StatefulWidget {
  const WaterIntakeTracker({Key? key}) : super(key: key);

  @override
  _WaterIntakeTrackerState createState() => _WaterIntakeTrackerState();
}

class _WaterIntakeTrackerState extends State<WaterIntakeTracker> {
  double totalIntake = 0; // in milliliters
  double goal = 4000; // goal in milliliters
  List<Map<String, String>> updates = [];

  void addWaterIntake() {
    setState(() {
      totalIntake += 250; // Increment by 250ml (1 cup)
      updates.add({
        'time': "${TimeOfDay.now().format(context)}",
        'intake': "250ml",
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double intakePercentage = (totalIntake / goal).clamp(0, 1);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Water Intake",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "${(totalIntake / 1000).toStringAsFixed(1)} Liters",
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
          SizedBox(height: 12),
          Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 150,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: intakePercentage,
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Real-time updates",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: updates.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(updates[index]['time']!),
                trailing: Text(updates[index]['intake']!),
              );
            },
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: addWaterIntake,
              child: Text("Drank One Cup"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
