import 'package:flutter/material.dart';
import 'user_prediction_screen.dart';

class TransportSelectionScreen extends StatefulWidget {
  final String selectedMode;

  TransportSelectionScreen({required this.selectedMode});

  @override
  _TransportSelectionScreenState createState() =>
      _TransportSelectionScreenState();
}

class _TransportSelectionScreenState extends State<TransportSelectionScreen> {
  String? selectedLine;
  String? selectedStation;
  String selectedTimeSlot = 'Peak';
  String selectedWeather = 'Sunny';

  final List<String> timeSlots = ['Peak', 'Normal'];
  final List<String> weatherOptions = ['Sunny', 'Rainy', 'Cloudy'];

  Map<String, List<String>> transportData = {
    'Train': ['Western', 'Central', 'Harbour'],
    'Metro': ['Line 1', 'Line 2A', 'Line 2B', 'Line 3'],
    'Bus': ['Line 1', 'Line 2'],
    'Airport': ['Domestic', 'International'],
  };

  Map<String, List<String>> stationData = {
    'Western': ['Churchgate', 'Dadar', 'Andheri', 'Borivali'],
    'Central': ['CST', 'Dadar', 'Kurla', 'Thane'],
    'Harbour': ['CST', 'Kurla', 'Vashi'],
    'Line 1': ['Versova', 'Andheri', 'Ghatkopar'],
    'Line 2A': ['Dahisar', 'Borivali', 'Vasai'],
    'Line 2B': ['Dahisar', 'Borivali', 'Vasai'],
    'Line 3': ['Aarey', 'Andheri', 'Sakinaka'],
    'Line 1': ['Colaba', 'Dadar', 'Thane'],
    'Line 2': ['CST', 'Dadar', 'Thane'],
    'Domestic': ['Terminal 1', 'Terminal 2'],
    'International': ['Terminal 2'],
  };

  @override
  Widget build(BuildContext context) {
    List<String> lines = transportData[widget.selectedMode] ?? [];
    List<String> stations = selectedLine != null
        ? (stationData[selectedLine] ?? [])
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select ${widget.selectedMode}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0B1C2D),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF0B1C2D),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select your route details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),

            // Line Selection
            Text("Line", style: TextStyle(color: Colors.white70, fontSize: 16)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedLine,
                dropdownColor: Color(0xFF1E2A38),
                style: TextStyle(color: Colors.white),
                hint: Text(
                  "Select Line",
                  style: TextStyle(color: Colors.white70),
                ),
                isExpanded: true,
                underline: SizedBox(),
                items: lines.map((line) {
                  return DropdownMenuItem(value: line, child: Text(line));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLine = value;
                    selectedStation = null; // Reset station when line changes
                  });
                },
              ),
            ),

            SizedBox(height: 24),

            // Station Selection
            if (selectedLine != null) ...[
              Text(
                "Station",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2A38),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedStation,
                  dropdownColor: Color(0xFF1E2A38),
                  style: TextStyle(color: Colors.white),
                  hint: Text(
                    "Select Station",
                    style: TextStyle(color: Colors.white70),
                  ),
                  isExpanded: true,
                  underline: SizedBox(),
                  items: stations.map((station) {
                    return DropdownMenuItem(
                      value: station,
                      child: Text(station),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStation = value;
                    });
                  },
                ),
              ),
            ],

            SizedBox(height: 24),

            // Time Slot
            Text(
              "Time Slot",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: timeSlots.map((slot) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedTimeSlot = slot;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedTimeSlot == slot
                            ? Color(0xFF00E5A8)
                            : Color(0xFF1E2A38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        slot,
                        style: TextStyle(
                          color: selectedTimeSlot == slot
                              ? Color(0xFF0B1C2D)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 24),

            // Weather
            Text(
              "Weather",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: weatherOptions.map((weather) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedWeather = weather;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedWeather == weather
                            ? Color(0xFF00E5A8)
                            : Color(0xFF1E2A38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        weather,
                        style: TextStyle(
                          color: selectedWeather == weather
                              ? Color(0xFF0B1C2D)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            Spacer(),

            // Predict Button
            ElevatedButton(
              onPressed: selectedLine != null && selectedStation != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPredictionScreen(
                            mode: widget.selectedMode,
                            line: selectedLine!,
                            station: selectedStation!,
                            timeSlot: selectedTimeSlot,
                            weather: selectedWeather,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00E5A8),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Predict Crowd Level",
                style: TextStyle(
                  color: Color(0xFF0B1C2D),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
