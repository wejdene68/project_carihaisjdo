import 'package:crohn/screens/navigations/usermodel.dart';
import 'package:crohn/core/utils/sp.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  UserModel? usermodel;
  bool isLogged = false;

  void initSP() async {
    UserModel? loadedUser = await Sp().getUserData();
    if (loadedUser != null) {
      setState(() {
        isLogged = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    initSP();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Set up animations
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animations
    _controller.forward();

    // Navigate to home after delay
    Timer(const Duration(seconds: 3), () {
      if (isLogged) {
        Navigator.of(context).pushReplacementNamed('/homescreen');
      } else {
        Navigator.of(context).pushReplacementNamed('/welcomescreen');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo
            ScaleTransition(
              scale: _scaleAnimation,
              child: const MedicalLogo(),
            ),
            const SizedBox(height: 30),

            // Tagline with slide and fade animation
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'Patient Care Simplified',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
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

class MedicalLogo extends StatelessWidget {
  const MedicalLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green background
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulse animation
            const PulsatingCircle(),
            // Medical cross icon
            CircleAvatar(
              backgroundImage: AssetImage('assets/Crohn-Logo.png'),
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class PulsatingCircle extends StatefulWidget {
  const PulsatingCircle({super.key});

  @override
  State<PulsatingCircle> createState() => _PulsatingCircleState();
}

class _PulsatingCircleState extends State<PulsatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              const Color.fromARGB(255, 200, 217, 230).withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
