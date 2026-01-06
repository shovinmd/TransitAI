import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(CrowdApp());
}

class CrowdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TransitAI',
      theme: ThemeData(
        primaryColor: Color(0xFF0B1C2D),
        scaffoldBackgroundColor: Color(0xFF0B1C2D),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF0B1C2D),
          secondary: Color(0xFF00E5A8),
          surface: Color(0xFF1E2A38),
          background: Color(0xFF0B1C2D),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: MainScreen(),
    );
  }
}
