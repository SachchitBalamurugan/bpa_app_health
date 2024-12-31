import 'package:flutter/material.dart';
import 'package:healthapp/screens/activity.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WorkoutApp());
}

class WorkoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WorkoutScreen(),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _scheduleWorkout() async {
    // Select the date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }

    // Select the time
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveToFirebase() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time.')),
      );
      return;
    }

    // Combine date and time into a DateTime object
    DateTime combinedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Format the date to the required format
    String formattedDate = "${combinedDateTime.month} ${combinedDateTime.day}, ${combinedDateTime.year} at ${combinedDateTime.hour}:${combinedDateTime.minute}:${combinedDateTime.second} ${combinedDateTime.hour >= 12 ? 'PM' : 'AM'} UTC-${combinedDateTime.timeZoneOffset.inHours}";

    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    final String userId = user.uid;

    try {
      // Save workout data under the user's document
      await FirebaseFirestore.instance
          .collection('users') // Users collection
          .doc(userId) // User document
          .collection('workouts') // Workouts collection (this will be created dynamically)
          .add({
        'workout': 'Fullbody Workout',
        'date': formattedDate, // Save the formatted date
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout scheduled successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
      print('Error saving workout: $e'); // Log the error here
    }

    print('User ID: $userId');
    print('Selected Date: $_selectedDate');
    print('Selected Time: $_selectedTime');
    print('Formatted Date: $formattedDate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/Men-Vector.png',
                      height: 180,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WorkoutTrackerApp()),
                      );
                    },
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 16,
                  child: Icon(Icons.favorite, color: Colors.red),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fullbody Workout',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1 Exercise | 25mins | 250 Calories Burnt',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _scheduleWorkout,
                          icon: Icon(Icons.calendar_today),
                          label: Text('Schedule Workout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF5F6FA),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE8F0FE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Beginner'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveToFirebase,
                    child: Text('Save to Firebase'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You\'ll Need',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildItem('Dumbbell'),
                      SizedBox(width: 16),
                      _buildItem('Skipping Rope'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Exercises',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildExerciseList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.fitness_center),
        ),
        SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  Widget _buildExerciseList(BuildContext context) {
    List<Map<String, String>> exercises = [
      {'name': 'Warm-up', 'time': '00:30', 'video': 'assets/warm_up.mp4'},
      {'name': 'Jumping Jack', 'time': '1m', 'video': 'assets/jumping_jack.mp4'},
      {'name': 'Skipping', 'time': '00:30', 'video': 'assets/skipping.mp4'},
      {'name': 'Squats', 'time': '00:30', 'video': 'assets/squats.mp4'},
      {'name': 'Arm Raises', 'time': '00:30', 'video': 'assets/arm_raises.mp4'},
      {'name': 'Incline Push-ups', 'time': '00:30', 'video': 'assets/incline_pushups.mp4'},
      {'name': 'Push-ups', 'time': '00:30', 'video': 'assets/pushups.mp4'},
    ];

    return Column(
      children: exercises.map((exercise) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(
                  title: exercise['name']!,
                  videoPath: exercise['video']!,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFF5F6FA),
                  child: Icon(Icons.play_arrow),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    exercise['name']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String title;
  final String videoPath;

  VideoScreen({required this.title, required this.videoPath});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.replay_10),
                  onPressed: () {
                    _controller.seekTo(
                      _controller.value.position - Duration(seconds: 10),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.forward_10),
                  onPressed: () {
                    _controller.seekTo(
                      _controller.value.position + Duration(seconds: 10),
                    );
                  },
                ),
              ],
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
