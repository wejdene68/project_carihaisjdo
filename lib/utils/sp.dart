import 'package:crohn/screens/navigations/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sp {
  Future<void> storeUser(UserModel user) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString("username", user.fullName);
    await sp.setString("email", user.email);
    await sp.setBool("isDoctor", user.isDoctor);
  }

  Future<UserModel> getUserdata() async {
    final sp = await SharedPreferences.getInstance();

    final username = sp.getString("username") ?? "name";
    final email = sp.getString("email") ?? "email";
    final isDoctor = sp.getBool("isDoctor") ?? false;

    return UserModel(fullName: username, email: email, isDoctor: isDoctor);
  }

  Future<void> loginStatus(bool isLogged) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool("isLogged", isLogged);
  }
}
