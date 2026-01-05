import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class UserDashboardScreen extends StatefulWidget {
  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getUser();
    if (mounted) {
      setState(() {
        userData = user;
        isLoading = false;
      });
    }
  }

  // Static data for MVP - in real app, this would come from API
  final List<Map<String, dynamic>> recentRoutes = [
    {
      'mode': 'Train',
      'line': 'Western',
      'station': 'Andheri',
      'crowdLevel': 'High',
      'time': '2 hours ago',
    },
    {
      'mode': 'Metro',
      'line': 'Line 1',
      'station': 'Andheri',
      'crowdLevel': 'Medium',
      'time': '1 day ago',
    },
  ];

  final Map<String, dynamic> userStats = {
    'totalPredictions': 12,
    'feedbackGiven': 8,
    'mostUsedRoute': 'Western Line',
    'contributionScore': 85,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0B1C2D),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF0B1C2D),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              "Welcome back!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Your smart mobility insights",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 24),

            // Today's Travel Summary
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Travel Summary",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem("Last Route", "Western Line"),
                      _buildSummaryItem("Last Crowd", "High"),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Recent Routes
            Text(
              "Recent Routes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ...recentRoutes.map((route) => _buildRouteCard(route)),

            SizedBox(height: 24),

            // Your Contributions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Contributions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContributionItem(
                        "Predictions",
                        userStats['totalPredictions'].toString(),
                      ),
                      _buildContributionItem(
                        "Feedback",
                        userStats['feedbackGiven'].toString(),
                      ),
                      _buildContributionItem(
                        "Score",
                        "${userStats['contributionScore']}%",
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF00E5A8).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF00E5A8)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFF00E5A8)),
                        SizedBox(width: 8),
                        Text(
                          "Helping the city stay smart!",
                          style: TextStyle(color: Color(0xFF00E5A8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Most Used Route
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.route, color: Color(0xFF00E5A8), size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Most Used Route",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userStats['mostUsedRoute'],
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
        SizedBox(height: 4),
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

  Widget _buildRouteCard(Map<String, dynamic> route) {
    Color crowdColor = route['crowdLevel'] == 'High'
        ? Colors.red
        : route['crowdLevel'] == 'Medium'
        ? Colors.orange
        : Colors.green;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1E2A38),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: crowdColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${route['mode']} • ${route['line']} • ${route['station']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Crowd: ${route['crowdLevel']} • ${route['time']}",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF00E5A8),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
