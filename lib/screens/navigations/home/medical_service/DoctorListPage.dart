import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:crohn/screens/navigations/home/medical_service/surgeon.dart';

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Our Doctors',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.black)),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        elevation: 12,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAnimatedDoctorCard(
              context,
              name: "Dr. Jouda Bensalah",
              specialty: "Digestive Surgery Specialist",
              image: "assets/img/PDR.webp",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SurgeonPage()),
              ),
            ),
            const SizedBox(height: 20),
            _buildAnimatedDoctorCard(
              context,
              name: "Dr. Amine Farid",
              specialty: "Cardiologist",
              image: "assets/img/ik.webp",
              onTap: () => _showComingSoon(context),
            ),
            const SizedBox(height: 20),
            _buildAnimatedDoctorCard(
              context,
              name: "Dr. Sara Ali",
              specialty: "Neurologist",
              image: "assets/img/PDR2.webp",
              onTap: () => _showComingSoon(context),
            ),
            const SizedBox(height: 20),
            _buildAnimatedDoctorCard(
              context,
              name: "Dr. Hichem Bouzid",
              specialty: "Dermatologist",
              image: "assets/img/appoint.webp",
              onTap: () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDoctorCard(BuildContext context,
      {required String name,
      required String specialty,
      required String image,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 3,
              offset: const Offset(5, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                // ignore: deprecated_member_use
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(image),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(specialty,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Doctor details coming soon..."),
      backgroundColor: Colors.blueGrey,
    ));
  }
}
