import 'package:flutter/material.dart';
import '../models/prediction_model.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class ResultScreen extends StatefulWidget {
  final PredictionModel prediction;
  final String route;
  final String time;
  final String weather;

  const ResultScreen({
    Key? key,
    required this.prediction,
    required this.route,
    required this.time,
    required this.weather,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late PredictionModel currentPrediction;

  @override
  void initState() {
    super.initState();
    currentPrediction = widget.prediction;
  }

  Color _getColor() {
    switch (currentPrediction.crowdLevel) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.amberAccent;
      case 'Low':
        return Color(0xFF00E5A8); // Cyan/Green
      default:
        return Colors.grey;
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E2A38),
        title: Text(
          "Report Actual Status",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Help improve our AI! What is the actual crowd level?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          _buildFeedbackButton(context, "Low", "Comfortable"),
          _buildFeedbackButton(context, "Medium", "Normal"),
          _buildFeedbackButton(context, "High", "Overcrowded"),
        ],
      ),
    );
  }

  Widget _buildFeedbackButton(
    BuildContext context,
    String level,
    String feedbackValue,
  ) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context);
        final parts = widget.route.split(' - ');
        final mode = parts.isNotEmpty ? parts[0] : 'Train';
        final line = parts.length > 1 ? parts[1] : widget.route;
        final station = 'Unknown';
        bool success = await ApiService.submitFeedback(
          mode,
          line,
          station,
          widget.time,
          widget.weather,
          feedbackValue,
        );
        if (success) {
          // Update the prediction based on user feedback
          setState(() {
            currentPrediction = PredictionModel(
              crowdLevel: level,
              finalScore: _calculateUpdatedScore(level),
              feedbackScore: currentPrediction.feedbackScore,
              timeScore: currentPrediction.timeScore,
              weatherScore: currentPrediction.weatherScore,
              historyScore: currentPrediction.historyScore,
            );
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? "Thanks! Report updated and AI model improved."
                  : "Failed to submit.",
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      },
      child: Text(level, style: TextStyle(color: Color(0xFF00E5A8))),
    );
  }

  double _calculateUpdatedScore(String level) {
    // Simple logic to update score based on user feedback
    switch (level) {
      case 'Low':
        return 3.0;
      case 'Medium':
        return 6.0;
      case 'High':
        return 9.0;
      default:
        return currentPrediction.finalScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prediction Result",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0B1C2D),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF0B1C2D), // Deep Blue / Navy
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Crowd Level Indicator
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _getColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: _getColor(), width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: _getColor().withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CROWD LEVEL",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        currentPrediction.crowdLevel.toUpperCase(),
                        style: TextStyle(
                          color: _getColor(),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Score: ${currentPrediction.finalScore.toStringAsFixed(1)}",
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),

              // 2. Info Card
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2A38),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    _buildInfoRow("Route", widget.route, Icons.directions_bus),
                    Divider(color: Colors.white10, height: 24),
                    _buildInfoRow("Time", widget.time, Icons.access_time),
                    Divider(color: Colors.white10, height: 24),
                    _buildInfoRow("Weather", widget.weather, Icons.cloud),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // 3. Explainable AI Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2A38).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: Color(0xFF00E5A8),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "AI Logic Breakdown",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildScoreRow(
                      "Feedback Impact (40%)",
                      currentPrediction.feedbackScore,
                      Colors.blueAccent,
                    ),
                    _buildScoreRow(
                      "Time Factor (30%)",
                      currentPrediction.timeScore,
                      Colors.orangeAccent,
                    ),
                    _buildScoreRow(
                      "Weather Impact (20%)",
                      currentPrediction.weatherScore,
                      Colors.lightBlueAccent,
                    ),
                    _buildScoreRow(
                      "History Trend (10%)",
                      currentPrediction.historyScore,
                      Colors.purpleAccent,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // 4. Alert Box
              if (currentPrediction.crowdLevel == 'High')
                _buildAlertBox(
                  "⚠️ Expect delays. Try alternate time.",
                  Colors.redAccent.withOpacity(0.2),
                  Colors.redAccent,
                ),
              if (currentPrediction.crowdLevel == 'Low')
                _buildAlertBox(
                  "✅ Good time to travel!",
                  Color(0xFF00E5A8).withOpacity(0.2),
                  Color(0xFF00E5A8),
                ),
              if (currentPrediction.crowdLevel == 'Medium')
                _buildAlertBox(
                  "ℹ️ Moderate crowd. Plan accordingly.",
                  Colors.amberAccent.withOpacity(0.2),
                  Colors.amberAccent,
                ),

              SizedBox(height: 24),

              // 5. Feedback Button (New!)
              TextButton.icon(
                onPressed: () => _showFeedbackDialog(context),
                icon: Icon(Icons.report, color: Colors.white54),
                label: Text(
                  "Report Different Status",
                  style: TextStyle(color: Colors.white54),
                ),
              ),

              SizedBox(height: 32),

              // 6. Authority Dashboard Button (New!)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
                icon: Icon(Icons.dashboard, color: Color(0xFF0B1C2D)),
                label: Text("User Dashboard"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00E5A8),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white54, size: 20),
            SizedBox(width: 12),
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow(String label, double score, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
          Row(
            children: [
              Container(
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (score / 10).clamp(
                    0.0,
                    1.0,
                  ), // Assuming max score is 10
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBox(String text, Color bgColor, Color borderColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
