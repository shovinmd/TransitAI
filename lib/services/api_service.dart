import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/prediction_model.dart';

class ApiService {
  // Use the deployed backend URL
  static const String baseUrl = "https://crowd-backend-eta.vercel.app";

  static Future<PredictionModel?> predictCrowd(
    String mode,
    String line,
    String station,
    String time,
    String weather,
    String feedback,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mode": mode,
          "line": line,
          "station": station,
          "timeSlot": time,
          "weather": weather,
          "feedback": feedback,
        }),
      );
      if (response.statusCode == 200) {
        return PredictionModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print("Error calling API: $e");
      return null;
    }
  }

  static Future<bool> submitFeedback(
    String mode,
    String line,
    String station,
    String time,
    String weather,
    String feedback,
    {String? userId},
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/feedback"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          if (userId != null) "userId": userId,
          "mode": mode,
          "line": line,
          "station": station,
          "timeSlot": time,
          "weather": weather,
          "feedback": feedback,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error submitting feedback: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          jsonDecode(response.body)['message'] ?? 'Signup failed',
        );
      }
    } catch (e) {
      print("Error signing up: $e");
      throw e;
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) {
      print("Error logging in: $e");
      throw e;
    }
  }

  static Future<List<dynamic>> getDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/predict/dashboard"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> getTransportNetwork() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/network/network"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Map<String, dynamic>.from(data['network'] ?? {});
      } else {
        return {};
      }
    } catch (e) {
      print("Error fetching transport network: $e");
      return {};
    }
  }

  // Transport data methods
  static Future<List<String>> getTransportModes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/network/transport/modes'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['modes']);
      } else {
        throw Exception('Failed to fetch transport modes');
      }
    } catch (e) {
      print('Error fetching transport modes: $e');
      return ['Train', 'Metro', 'Bus', 'Airport'];
    }
  }

  static Future<List<String>> getTransportLines(String mode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/network/transport/lines/$mode'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['lines']);
      } else {
        throw Exception('Failed to fetch transport lines');
      }
    } catch (e) {
      print('Error fetching transport lines: $e');
      return [];
    }
  }

  static Future<List<String>> getTransportStations(
    String mode,
    String line,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/network/transport/stations/$mode/$line'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['stations']);
      } else {
        throw Exception('Failed to fetch transport stations');
      }
    } catch (e) {
      print('Error fetching transport stations: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getRouteHistory() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/network/routes'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['routes'];
      } else {
        throw Exception('Failed to fetch route history');
      }
    } catch (e) {
      print('Error fetching route history: $e');
      return [];
    }
  }
}
