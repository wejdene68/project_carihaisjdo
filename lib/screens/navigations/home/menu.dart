import 'package:crohn/screens/navigations/home/appointments_page.dart';
import 'package:crohn/screens/navigations/home/doctors.dart';
import 'package:crohn/screens/navigations/home/helpfaqs.dart';
import 'package:crohn/screens/navigations/home/medical_records.dart';
import 'package:flutter/material.dart';
import 'package:crohn/screens/navigations/setting.dart';

class MenuWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const MenuWidget({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[800]!, Colors.blue[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20),
            width: double.infinity,
            child: const Row(
              children: [
                Icon(Icons.menu, size: 30, color: Colors.white),
                SizedBox(width: 16),
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black45,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                _buildAnimatedTile(
                  icon: Icons.calendar_today,
                  label: 'Appointments',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppointmentsPage(),
                      ),
                    );
                  },
                ),
                _buildAnimatedTile(
                  icon: Icons.local_hospital,
                  label: 'Doctors',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorsPage(),
                      ),
                    );
                  },
                ),
                _buildAnimatedTile(
                  icon: Icons.folder_open,
                  label: 'Medical Records',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalRecordsPage(),
                      ),
                    );
                  },
                ),
                _buildAnimatedTile(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingScreen(),
                      ),
                    );
                  },
                ),
                _buildAnimatedTile(
                  icon: Icons.help,
                  label: 'Help & FAQs',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpFaqsPage(),
                      ),
                    );
                  },
                ),
                _buildAnimatedTile(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    onLogout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[500]),
        title: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.blue[50],
        hoverColor: Colors.blue[100],
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}
