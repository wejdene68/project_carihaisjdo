import 'package:flutter/material.dart';

class WelcomeSceen extends StatefulWidget {
  const WelcomeSceen({super.key});

  @override
  State<WelcomeSceen> createState() => _WelcomeSceenState();
}

class _WelcomeSceenState extends State<WelcomeSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  "assets/img/doctor_avatar.png",
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "CROHN",
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Find your doctor and make an appointment with one tap ",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () => navigateLogin(context, '/loginpage'),
                      child: Text(
                        "Get Start",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[500]),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void navigateLogin(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
