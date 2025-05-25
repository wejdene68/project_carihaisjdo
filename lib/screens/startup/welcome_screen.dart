import 'package:flutter/material.dart';
import 'dart:math';

class WelcomeSceen extends StatefulWidget {
  const WelcomeSceen({super.key});

  @override
  State<WelcomeSceen> createState() => _WelcomeSceenState();
}

class _WelcomeSceenState extends State<WelcomeSceen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _buttonScale = 0.8;

  @override
  void initState() {
    super.initState();

    // Trigger fade-in animation and button scale after delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _buttonScale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              "assets/img/end1.jpg",
              fit: BoxFit.cover,
            ),

            // Animated content
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3D animated title
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: pi / 2, end: 0),
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeOutBack,
                        builder: (context, angle, child) {
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: const Text(
                              "CROHN",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.blue,
                                    blurRadius: 10,
                                    offset: Offset(2, 2),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Find your specialist and make an appointment\nin just one tap. Stay healthy and connected\nwith your care providers.",
                        style: TextStyle(fontSize: 18, color: Colors.blue[500]),
                      ),
                      const SizedBox(height: 20),

                      // Login and Sign Up buttons with scale animation
                      AnimatedScale(
                        scale: _buttonScale,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.elasticOut,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 140,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/loginpage'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 10,
                                  shadowColor: Colors.blue[800],
                                ),
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 140,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/signuppage'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.blue),
                                  ),
                                  elevation: 10,
                                  shadowColor: Colors.blue[800],
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue[700]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
