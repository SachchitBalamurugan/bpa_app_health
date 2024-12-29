import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/screens/home.dart';

void main() {
  runApp(MaterialApp(
    home: AddGoalsScreen(),
  ));
}

class AddGoalsScreen extends StatefulWidget {
  @override
  _AddGoalsScreenState createState() => _AddGoalsScreenState();
}

class _AddGoalsScreenState extends State<AddGoalsScreen> {
  // Initial selected goal
  String? selectedGoal;

  // Define the goal structure with sub-goals
  final Map<String, Map<String, double>> goals = {
    "Lose Weight": {
      "Calories": 2000,
      "Water (cups)": 8,
      "Exercise (minutes)": 30,
      "Sleep (hours)": 8,
    },
    "Live Healthy": {
      "Calories": 1800,
      "Water (cups)": 10,
      "Exercise (minutes)": 45,
      "Sleep (hours)": 8,
      "Vegetables (servings)": 5,
    },
    "Build Muscle": {
      "Calories": 2500,
      "Protein (grams)": 150,
      "Exercise (minutes)": 60,
      "Sleep (hours)": 8,
    },
    "Improve Shape": {
      "Calories": 2200,
      "Water (cups)": 8,
      "Exercise (minutes - strength)": 40,
      "Exercise (minutes - flexibility)": 20,
      "Exercise (minutes - cardio)": 30,
      "Sleep (hours)": 8,
    },
  };

  // To hold progress for each sub-goal
  Map<String, double> progress = {};

  // Method to update progress
  void updateProgress(String subGoal, double value) {
    setState(() {
      progress[subGoal] = value;
    });
  }

  // Custom goals
  final Map<String, Map<String, double>> customGoals = {};
  final TextEditingController customGoalController = TextEditingController();
  final TextEditingController subGoalNameController = TextEditingController();
  final TextEditingController subGoalValueController = TextEditingController();

  void addCustomGoal() {
    String customGoal = customGoalController.text.trim();
    if (customGoal.isNotEmpty) {
      setState(() {
        customGoals[customGoal] = {};
      });
      customGoalController.clear();
    }
  }

  void addSubGoal(String customGoal) {
    String subGoalName = subGoalNameController.text.trim();
    double subGoalValue =
        double.tryParse(subGoalValueController.text.trim()) ?? 0.0;

    if (subGoalName.isNotEmpty && subGoalValue > 0) {
      setState(() {
        customGoals[customGoal]?[subGoalName] = subGoalValue;
        progress[subGoalName] = 0.0;
      });
      subGoalNameController.clear();
      subGoalValueController.clear();
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize progress for the first goal if no goal is selected
    if (selectedGoal == null) {
      selectedGoal = goals.keys.first;
      goals[selectedGoal]?.forEach((key, value) {
        progress[key] = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adjust and Manage Goals',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal slider for goals
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: goals.keys.length + customGoals.keys.length,
                itemBuilder: (context, index) {
                  String goal = index < goals.keys.length
                      ? goals.keys.elementAt(index)
                      : customGoals.keys.elementAt(index - goals.keys.length);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGoal = goal;
                        progress.clear();
                        (goals[goal] ?? customGoals[goal])?.forEach((key, value) {
                          progress[key] = 0.0;
                        });
                      });
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/gym.png', // Placeholder image
                            height: 80,
                          ),
                          SizedBox(height: 10),
                          Text(
                            goal,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Display subcategory progress bars if a goal is selected
            if (selectedGoal != null)
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedGoal!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // Create progress bars for each sub-goal
                      ...((goals[selectedGoal] ?? customGoals[selectedGoal])!
                          .keys
                          .map((subGoal) {
                        double goalValue = (goals[selectedGoal] ??
                            customGoals[selectedGoal])![subGoal]!;
                        double currentProgress = progress[subGoal] ?? 0.0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(subGoal),
                            LinearProgressIndicator(
                              value: currentProgress / goalValue,
                              backgroundColor: Color(0xFF9DCEFF),
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFC58BF2)),
                            ),
                            Text(
                              'Progress: ${(currentProgress / goalValue * 100).toStringAsFixed(0)}%',
                              style: TextStyle(color: Color(0xFFEEA4CE)),
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter $subGoal value',
                              ),
                              onChanged: (value) {
                                double progressValue =
                                    double.tryParse(value) ?? 0.0;
                                updateProgress(subGoal, progressValue);
                              },
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      }).toList()),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Add custom goal section
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: customGoalController,
                      decoration: InputDecoration(
                        labelText: 'Enter Custom Goal Name',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addCustomGoal,
                      child: Text('Add Custom Goal'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFC58BF2),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (customGoals.isNotEmpty)
                      ...customGoals.keys.map((customGoal) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customGoal,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: subGoalNameController,
                              decoration: InputDecoration(
                                labelText: 'Enter Sub-Goal Name',
                              ),
                            ),
                            TextField(
                              controller: subGoalValueController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter Sub-Goal Target Value',
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => addSubGoal(customGoal),
                              child: Text('Add Sub-Goal'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFFC58BF2),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print('Goals saved');
              },
              child: Text('Save Goals'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFC58BF2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
