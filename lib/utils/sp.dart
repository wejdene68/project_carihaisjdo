import 'package:shared_preferences/shared_preferences.dart';
import 'package:crohn/screens/navigations/usermodel.dart';

class Sp {
  // Save user data
  Future<void> saveUserdata(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', user.fullName);
    await prefs.setString('userEmail', user.email);
  }

  // Get user data
  Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName');
    final email = prefs.getString('userEmail');

    if (name != null && email != null) {
      return UserModel(fullName: name, email: email, userType: '');
    }
    return null;
  }

  // Clear user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userEmail');
  }
}
