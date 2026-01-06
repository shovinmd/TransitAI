import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String selectedMode = 'Train';
  String? selectedRoute;
  String? selectedStation;
  String selectedTime = 'Normal';
  String selectedWeather = 'Clear';
  String? feedback;
  bool isLoading = false;
  Map<String, dynamic> transportNetwork = {};
  List<String> routes = [];
  List<String> stations = [];

  final List<String> times = ['Peak', 'Normal'];
  final List<String> weathers = ['Clear', 'Rainy'];
  final List<String> feedbacks = [
    'Normal',
    'Overcrowded',
    'Comfortable',
    'Long Wait',
  ];

  @override
  void initState() {
    super.initState();
    _loadTransportNetwork();
  }

  void _loadTransportNetwork() async {
    final network = await ApiService.getTransportNetwork();
    setState(() {
      transportNetwork = network;
      _updateRoutesForMode(selectedMode);
    });
  }

  void _updateRoutesForMode(String mode) {
    if (transportNetwork.containsKey(mode)) {
      final modeData = transportNetwork[mode] as Map<String, dynamic>;
      routes = modeData.keys.toList().toSet().toList();
      selectedRoute = routes.isNotEmpty ? routes.first : null;
      _updateStationsForRoute(mode, selectedRoute);
    } else {
      routes = [];
      selectedRoute = null;
      stations = [];
      selectedStation = null;
    }
  }

  void _updateStationsForRoute(String mode, String? route) {
    if (route != null && transportNetwork[mode] != null) {
      final modeData = transportNetwork[mode] as Map<String, dynamic>;
      final list = modeData[route];
      if (list is List) {
        stations = List<String>.from(list).toSet().toList();
        selectedStation = stations.isNotEmpty ? stations.first : null;
        return;
      }
    }
    stations = [];
    selectedStation = null;
  }

  void _predict() async {
    setState(() {
      isLoading = true;
    });

    final result = await ApiService.predictCrowd(
      selectedMode,
      selectedRoute ?? 'Line 1',
      selectedStation ?? 'Unknown',
      selectedTime,
      selectedWeather,
      feedback ?? 'Normal',
    );

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            prediction: result,
            route: '$selectedMode - ${selectedRoute ?? 'Line 1'}',
            time: selectedTime,
            weather: selectedWeather,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Prediction failed. Check connection.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Crowd Predictor",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0B1C2D), // Deep Blue / Navy
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Color(
        0xFF0B1C2D,
      ), // Dark Background (AI / Smart City feel)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Predict real-time crowd levels using AI logic.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            _buildDropdown(
              "Select Mode",
              transportNetwork.keys.toList(),
              selectedMode,
              (val) {
                setState(() {
                  selectedMode = val!;
                  _updateRoutesForMode(selectedMode);
                });
              },
              Icons.directions,
            ),
            SizedBox(height: 16),
            _buildDropdown("Select Route", routes, selectedRoute, (val) {
              setState(() {
                selectedRoute = val;
                _updateStationsForRoute(selectedMode, selectedRoute);
              });
            }, Icons.directions_bus),
            SizedBox(height: 16),
            _buildDropdown("Select Station", stations, selectedStation, (val) {
              setState(() => selectedStation = val);
            }, Icons.location_pin),
            SizedBox(height: 16),
            _buildDropdown("Select Time", times, selectedTime, (val) {
              setState(() => selectedTime = val!);
            }, Icons.access_time),
            SizedBox(height: 16),
            _buildDropdown("Select Weather", weathers, selectedWeather, (val) {
              setState(() => selectedWeather = val!);
            }, Icons.cloud),
            SizedBox(height: 16),
            _buildDropdown("User Feedback (Optional)", feedbacks, feedback, (
              val,
            ) {
              setState(() => feedback = val);
            }, Icons.feedback),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading ? null : _predict,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00E5A8), // Cyan / Green (Accent)
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: Color(0xFF00E5A8).withOpacity(0.4),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFF0B1C2D),
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      "PREDICT CROWD LEVEL",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(
                          0xFF0B1C2D,
                        ), // Text color matches background for contrast
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String title,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E2A38), // Slightly lighter card background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF00E5A8), size: 18),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : null,
              isExpanded: true,
              hint: Text("Select...", style: TextStyle(color: Colors.white38)),
              dropdownColor: Color(0xFF1E2A38),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF00E5A8)),
              items: items.toSet().map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
