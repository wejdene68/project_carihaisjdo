import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crohn/screens/navigations/homescreen.dart';
import 'package:crohn/screens/auth/login_screen.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // Get user display name or fallback to email/UID
          final user = snapshot.data!;
          final String userName = user.displayName ?? user.email ?? user.uid;

          return HomeScreen(userName: userName);
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
