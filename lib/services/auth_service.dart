import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class AuthService {
  static const String KEY_USER = 'user_data';
  static const String KEY_IS_LOGGED_IN = 'is_logged_in';

  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_USER, jsonEncode(userData));
    await prefs.setBool(KEY_IS_LOGGED_IN, true);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(KEY_USER);
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_IS_LOGGED_IN) ?? false;
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    return await getUser();
  }
}
