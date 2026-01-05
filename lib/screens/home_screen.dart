import 'package:flutter/material.dart';
import 'transport_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMode = 'Train';

  final List<String> modes = ['Train', 'Metro', 'Bus', 'Airport'];

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
                    onPressed: () {
                      setState(() {
                        selectedMode = mode;
                      });
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
                          onChanged: (value) {
                            setState(() {
                              selectedMode = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransportSelectionScreen(
                            selectedMode: selectedMode,
                          ),
                        ),
                      );
                    },
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
                      "Check Prediction",
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
