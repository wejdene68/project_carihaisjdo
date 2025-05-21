import 'package:flutter/material.dart';
import 'usermodel.dart';

class AccountScreen extends StatelessWidget {
  final UserModel user;

  const AccountScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("👤 Name: ${user.fullName}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text("📧 Email: ${user.email}",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
