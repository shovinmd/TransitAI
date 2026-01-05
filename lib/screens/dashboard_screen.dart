import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> routeData = [];
  String userName = "User";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load User
    final user = await AuthService.getUser();
    if (user != null) {
      setState(() {
        userName = user['name'] ?? "User";
      });
    }

    // Load Dashboard Data
    final data = await ApiService.getDashboardData();
    if (mounted) {
      setState(() {
        routeData = data;
        isLoading = false;
      });
    }
  }

  Color _getColorForLevel(String level) {
    switch (level) {
      case 'Low':
        return Colors.greenAccent;
      case 'Medium':
        return Colors.amberAccent;
      case 'High':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => AuthService.logout(context),
            tooltip: "Logout",
          ),
        ],
      ),
      backgroundColor: Color(0xFF0B1C2D),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $userName",
              style: TextStyle(
                color: Color(0xFF00E5A8),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Mumbai Transport Network",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Image.asset(
                    'assest/images/mumbai_map.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          "Map Image Not Found",
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Route Crowd Overview",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF00E5A8)))
                : Expanded(
                    child: routeData.isEmpty
                        ? Center(
                            child: Text(
                              "No data available from backend.\n(Check if backend is running)",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : ListView.builder(
                            itemCount: routeData.length,
                            itemBuilder: (context, index) {
                              final route = routeData[index];
                              final color = _getColorForLevel(route['level']);
                              return Card(
                                color: Color(0xFF1E2A38),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  title: Text(
                                    route['route'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Crowd Level: ${route['level']}",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  trailing: Icon(Icons.trending_up, color: color),
                                ),
                              );
                            },
                          ),
                  ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E2A38).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Legend",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem(Colors.greenAccent, "Low"),
                      _buildLegendItem(Colors.amberAccent, "Medium"),
                      _buildLegendItem(Colors.redAccent, "High"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }
}
