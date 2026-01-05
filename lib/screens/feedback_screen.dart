import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FeedbackScreen extends StatefulWidget {
  final String mode;
  final String line;
  final String station;
  final String timeSlot;
  final String weather;
  final String feedback;
  final String predictedLevel;

  FeedbackScreen({
    required this.mode,
    required this.line,
    required this.station,
    required this.timeSlot,
    required this.weather,
    required this.feedback,
    required this.predictedLevel,
  });

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _submitFeedback();
  }

  Future<void> _submitFeedback() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      await ApiService.submitFeedback(
        widget.timeSlot,
        widget.weather,
        widget.feedback,
        '${widget.mode} ${widget.line} ${widget.station}',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Thank you for your feedback!")));

      // Navigate back to home after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Feedback submission failed. Please try again."),
        ),
      );
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B1C2D),
      appBar: AppBar(
        title: Text(
          "Feedback Submitted",
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
            // Success Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00E5A8),
              ),
              child: Icon(Icons.check, color: Color(0xFF0B1C2D), size: 60),
            ),

            SizedBox(height: 24),

            // Thank you message
            Text(
              "Thank You!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            Text(
              "Your feedback helps improve predictions for everyone.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 32),

            // Feedback details
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Your Feedback",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${widget.mode} • ${widget.line} • ${widget.station}",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Predicted: ${widget.predictedLevel} • Reported: ${widget.feedback}",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            if (isSubmitting)
              CircularProgressIndicator(color: Color(0xFF00E5A8))
            else
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00E5A8),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    color: Color(0xFF0B1C2D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
