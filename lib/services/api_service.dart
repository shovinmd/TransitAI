import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/prediction_model.dart';

class ApiService {
  // Use the deployed backend URL
  static const String baseUrl = "https://crowd-backend-eta.vercel.app";

  static Future<PredictionModel?> predictCrowd(
    String time,
    String weather,
    String feedback,
    String route,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "timeSlot": time, // Mapped to backend 'timeSlot'
          "weather": weather,
          "feedback": feedback,
          "route": route,
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
    String time,
    String weather,
    String feedback,
    String route,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/feedback"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "timeSlot": time,
          "weather": weather,
          "feedback": feedback,
          "route": route,
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
        Uri.parse("$baseUrl/network"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      print("Error fetching transport network: $e");
      return {};
    }
  }
}
