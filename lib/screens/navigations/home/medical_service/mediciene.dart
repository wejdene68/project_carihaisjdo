import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicinePage extends StatelessWidget {
  const MedicinePage({super.key});

  void _callNumber(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    await launchUrl(launchUri);
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text("This feature is coming soon!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Medicine Services',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.black)),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        elevation: 12,
      ),
      body: Stack(
        children: [
          Container(
            // ignore: deprecated_member_use
            color: Colors.blue.withOpacity(0.2),
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
            children: [
              _animatedCard(
                context,
                title: '🔔 Medication Reminder',
                icon: Icons.alarm,
                color: Colors.blue,
                onPressed: () => _showComingSoon(context, 'Reminder Feature'),
              ),
              const SizedBox(height: 10),
              _animatedCard(
                context,
                title: '📞 Civil Protection ',
                icon: Icons.local_hospital,
                color: Colors.red.shade300,
                onPressed: () => _callNumber('14'),
              ),
              _animatedCard(
                context,
                title: '👮 Police',
                icon: Icons.local_police,
                color: Colors.blue.shade300,
                onPressed: () => _callNumber('17'),
              ),
              const SizedBox(height: 10),
              _animatedCard(
                context,
                title: '🏥 Mohamed Boudiaf Hospital',
                icon: Icons.local_hospital,
                color: Colors.green.shade300,
                onPressed: () => _callNumber('038123456'),
              ),
              _animatedCard(
                context,
                title: '🏥 Emergency Hospital - Annaba',
                icon: Icons.local_hospital,
                color: Colors.green.shade200,
                onPressed: () => _callNumber('038987654'),
              ),
              const SizedBox(height: 10),
              _animatedCard(
                context,
                title: '👨‍⚕️ Dr. Samir Bouchareb',
                icon: Icons.person,
                color: Colors.lightBlueAccent,
                onPressed: () => _callNumber('0555123456'),
              ),
              _animatedCard(
                context,
                title: '👩‍⚕️ Dr. Leila Ben Dahman',
                icon: Icons.person,
                color: Colors.lightBlueAccent,
                onPressed: () => _callNumber('0566987654'),
              ),
              const SizedBox(height: 10),
              _animatedCard(
                context,
                title: '🌍 View on Map',
                icon: Icons.map,
                color: Colors.cyan.shade300,
                onPressed: () => _showComingSoon(context, 'Map Feature'),
              ),
              _animatedCard(
                context,
                title: '💬 Dr. Ahmed Mourad - Online',
                icon: Icons.video_call,
                color: Colors.orange.shade200,
                onPressed: () {
                  launchUrl(Uri.parse("https://meet.example.com/doctor1"));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _animatedCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        // ignore: deprecated_member_use
        color: color.withOpacity(0.9),
        child: ListTile(
          leading: Icon(icon, size: 32, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onTap: onPressed,
        ),
      ),
    );
  }
}
