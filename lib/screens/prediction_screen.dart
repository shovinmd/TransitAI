import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'feedback_screen.dart';

class PredictionScreen extends StatefulWidget {
  final String mode;
  final String line;
  final String station;
  final String timeSlot;
  final String weather;

  PredictionScreen({
    required this.mode,
    required this.line,
    required this.station,
    required this.timeSlot,
    required this.weather,
  });

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String? crowdLevel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _predictCrowd();
  }

  Future<void> _predictCrowd() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.predictCrowd(
        widget.timeSlot,
        widget.weather,
        'Normal',
        '${widget.mode} ${widget.line} ${widget.station}',
      );

      setState(() {
        crowdLevel = result?.crowdLevel;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        crowdLevel = 'Error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Prediction failed. Check connection.")),
      );
    }
  }

  Color getColor() {
    if (crowdLevel == "Low") return Colors.green;
    if (crowdLevel == "Medium") return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B1C2D),
      appBar: AppBar(
        title: Text(
          "Crowd Prediction",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0B1C2D),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Transport Info Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "${widget.mode} • ${widget.line} • ${widget.station}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${widget.timeSlot} • ${widget.weather}",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Big Crowd Indicator
            if (isLoading)
              CircularProgressIndicator(color: Color(0xFF00E5A8))
            else
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getColor(),
                ),
                child: Center(
                  child: Text(
                    crowdLevel?.toUpperCase() ?? 'UNKNOWN',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            SizedBox(height: 20),

            // Explanation Text
            Text(
              "Prediction based on time, weather & commuter behavior",
              style: TextStyle(color: Colors.white60),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            // Suggestion Card
            if (crowdLevel == 'High')
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2A38),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "💡 Try off-peak hours or alternative routes",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),

            SizedBox(height: 40),

            // Feedback Buttons
            if (!isLoading && crowdLevel != null)
              Column(
                children: [
                  Text(
                    "How was the crowd level?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFeedbackButton("😌", "Comfortable"),
                      _buildFeedbackButton("😐", "Normal"),
                      _buildFeedbackButton("😫", "Overcrowded"),
                      _buildFeedbackButton("⏱️", "Long Wait"),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackButton(String emoji, String feedback) {
    return ElevatedButton(
      onPressed: () async {
        // Submit feedback immediately when button is tapped
        try {
          await ApiService.submitFeedback(
            widget.timeSlot,
            widget.weather,
            feedback,
            '${widget.mode} ${widget.line} ${widget.station}',
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Feedback submitted successfully!")),
          );

          // Navigate to feedback screen after a short delay
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedbackScreen(
                  mode: widget.mode,
                  line: widget.line,
                  station: widget.station,
                  timeSlot: widget.timeSlot,
                  weather: widget.weather,
                  feedback: feedback,
                  predictedLevel: crowdLevel ?? 'Unknown',
                ),
              ),
            );
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to submit feedback. Please try again."),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1E2A38),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(height: 4),
          Text(feedback, style: TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
