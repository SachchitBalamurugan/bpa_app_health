import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartBPMComponent extends StatefulWidget {
  @override
  _HeartBPMComponentState createState() => _HeartBPMComponentState();
}

class _HeartBPMComponentState extends State<HeartBPMComponent> {
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  bool isBPMEnabled = false;
  double heartRateValue = 0.0; // To store the current heart rate value

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show Heart BPM dialog to start/stop measuring
        isBPMEnabled
            ? HeartBPMDialog(
          context: context,
          showTextValues: true,
          borderRadius: 10,
          onRawData: (value) {
            setState(() {
              // Add the new sensor data to the list (with a limit of 100 values)
              if (data.length >= 100) data.removeAt(0);
              data.add(value);
            });
          },
          onBPM: (value) => setState(() {
            // Update the BPM values list and add new BPM measurement
            if (bpmValues.length >= 100) bpmValues.removeAt(0);
            bpmValues.add(SensorValue(
              value: value.toDouble(),
              time: DateTime.now(),
            ));
            heartRateValue = value.toDouble(); // Store the heart rate value
          }),
        )
            : SizedBox(),

        // Display heart rate value and chart
        isBPMEnabled && bpmValues.isNotEmpty
            ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEBF3FF), Color(0xFFE9EDFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Heartbeat label and value
              Text(
                "Heart beat",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                heartRateValue.toStringAsFixed(0), // Heart rate value
                style: TextStyle(
                  color: Color(0xFF92A6FD), // Heart rate value color
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // BPM chart
              Container(
                decoration: BoxDecoration(border: Border.all()),
                constraints: BoxConstraints.expand(height: 180),
                child: BPMChart(bpmValues), // Chart showing BPM over time
              ),
            ],
          ),
        )
            : SizedBox(),

        // Button to start or stop measuring
        Center(
          child: ElevatedButton.icon(
            icon: Icon(Icons.favorite_rounded),
            label: Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
            onPressed: () => setState(() {
              // Toggle the measurement state (start/stop)
              isBPMEnabled = !isBPMEnabled;
              if (!isBPMEnabled) {
                // Reset data when stopping measurement
                setState(() {
                  data.clear();
                  bpmValues.clear();
                });
              }
            }),
          ),
        ),
      ],
    );
  }
}

class HeartBPMComponentContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF92A6FD), // Set background color to #92A6FD
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: HeartBPMComponent(), // The original component inside the container
    );
  }
}
