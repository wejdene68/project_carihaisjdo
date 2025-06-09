import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:crohn/screens/navigations/usermodel.dart';

class Sp {
  // Save user data
  Future<void> saveUserdata(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(user));
  }

  // Get user data
  Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      return UserModel.fromMap(jsonDecode(userData));
    }
    return null;
  }

  // Clear user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }
}
