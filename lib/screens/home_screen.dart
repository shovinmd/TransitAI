import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'transport_selection_screen.dart';
import 'user_prediction_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMode = 'Train';
  String? selectedLine;
  String? selectedStation;
  String selectedTimeSlot = 'Peak';
  String selectedWeather = 'Sunny';

  List<String> modes = [];
  List<String> lines = [];
  List<String> stations = [];
  final List<String> timeSlots = ['Peak', 'Normal'];
  final List<String> weatherOptions = ['Sunny', 'Rainy', 'Cloudy'];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransportData();
  }

  Future<void> _loadTransportData() async {
    setState(() {
      isLoading = true;
    });

    try {
      modes = await ApiService.getTransportModes();
      if (modes.isNotEmpty) {
        selectedMode = modes.first;
        await _loadLines(selectedMode);
      }
    } catch (e) {
      print('Error loading transport data: $e');
      // Fallback to hardcoded data
      modes = ['Train', 'Metro', 'Bus', 'Airport'];
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadLines(String mode) async {
    try {
      lines = await ApiService.getTransportLines(mode);
      lines = lines.toSet().toList();
      selectedLine = lines.isNotEmpty ? lines.first : null;
      selectedStation = null;
      if (selectedLine != null) {
        await _loadStations(mode, selectedLine!);
      }
    } catch (e) {
      print('Error loading lines: $e');
      lines = [];
      selectedLine = null;
      selectedStation = null;
    }
    setState(() {});
  }

  Future<void> _loadStations(String mode, String line) async {
    try {
      stations = await ApiService.getTransportStations(mode, line);
      stations = stations.toSet().toList();
      selectedStation = stations.isNotEmpty ? stations.first : null;
    } catch (e) {
      print('Error loading stations: $e');
      stations = [];
      selectedStation = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B1C2D),
      body: Stack(
        children: [
          // Mumbai Transport Map (Placeholder - you can add actual image)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Color(0xFF1E2A38)),
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assest/images/mumbai_map.jpg',
                    ), // Add your map image
                    fit: BoxFit.cover,
                    opacity: 0.7,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Mumbai Transport Network",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filter Icons (Top Right)
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: modes.map((mode) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: selectedMode == mode
                        ? Color(0xFF00E5A8)
                        : Color(0xFF1E2A38),
                    onPressed: () async {
                      setState(() {
                        selectedMode = mode;
                        selectedLine = null;
                        selectedStation = null;
                      });
                      await _loadLines(selectedMode);
                    },
                    child: Icon(
                      _getModeIcon(mode),
                      color: selectedMode == mode
                          ? Color(0xFF0B1C2D)
                          : Colors.white70,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Bottom Sheet for Quick Selection
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Quick Prediction",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedMode,
                          dropdownColor: Color(0xFF1E2A38),
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Mode",
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white30),
                            ),
                          ),
                          items: modes.map((mode) {
                            return DropdownMenuItem(
                              value: mode,
                              child: Text(mode),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              selectedMode = value!;
                              selectedLine = null;
                              selectedStation = null;
                            });
                            await _loadLines(selectedMode);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (selectedMode != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: lines.contains(selectedLine) ? selectedLine : null,
                            dropdownColor: Color(0xFF1E2A38),
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Line",
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white30),
                              ),
                            ),
                            items: lines.map((line) {
                              return DropdownMenuItem(
                                value: line,
                                child: Text(line),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              setState(() {
                                selectedLine = value;
                                selectedStation = null;
                              });
                              if (value != null) {
                                await _loadStations(selectedMode, value);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: stations.contains(selectedStation) ? selectedStation : null,
                            dropdownColor: Color(0xFF1E2A38),
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Station",
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white30),
                              ),
                            ),
                            items: selectedLine != null
                                ? stations.map((station) {
                                    return DropdownMenuItem(
                                      value: station,
                                      child: Text(station),
                                    );
                                  }).toList()
                                : [],
                            onChanged: (value) {
                              setState(() {
                                selectedStation = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: timeSlots.map((slot) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
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
                    SizedBox(height: 16),
                    Row(
                      children: weatherOptions.map((weather) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
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
                    SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    onPressed: selectedLine != null && selectedStation != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserPredictionScreen(
                                  mode: selectedMode,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Quick Check Prediction",
                      style: TextStyle(
                        color: Color(0xFF0B1C2D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'Train':
        return Icons.train;
      case 'Metro':
        return Icons.subway;
      case 'Bus':
        return Icons.directions_bus;
      case 'Airport':
        return Icons.flight;
      default:
        return Icons.directions;
    }
  }
}
