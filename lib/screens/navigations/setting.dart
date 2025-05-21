import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dummy pages for navigation
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: const Center(child: Text("Profile Page")),
    );
  }
}

class MedicalHistoryPage extends StatelessWidget {
  const MedicalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medical History")),
      body: const Center(child: Text("Medical History Page")),
    );
  }
}

class DoctorContactsPage extends StatelessWidget {
  const DoctorContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Contacts")),
      body: const Center(child: Text("Doctor Contacts Page")),
    );
  }
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: const Center(child: Text("Appointments Page")),
    );
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  bool isDarkMode = false;

  // For animation scale on tap
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for tap effect on cards
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Logout")),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userName');
      await prefs.remove('userEmail');

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Logged out")));
      }
      // Optionally: Navigate to login page here
    }
  }

  // Centralized navigation/actions handler
  void handleSettingAction(String action) async {
    switch (action) {
      case 'profile':
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ));
        break;
      case 'history':
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MedicalHistoryPage(),
            ));
        break;
      case 'contacts':
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorContactsPage(),
            ));
        break;
      case 'appointments':
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AppointmentsPage(),
            ));
        break;
      default:
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Unknown action")));
        }
    }
  }

  // Widget for the 3D-style card with animation
  Widget _buildAnimatedCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) => _animationController.reverse(),
      onTapUp: (_) {
        _animationController.forward();
        onTap();
      },
      onTapCancel: () => _animationController.forward(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.blueAccent),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildAnimatedCard(
            icon: Icons.person_outline,
            title: "My Profile",
            onTap: () => handleSettingAction('profile'),
          ),
          _buildAnimatedCard(
            icon: Icons.medical_services_outlined,
            title: "Medical History",
            onTap: () => handleSettingAction('history'),
          ),
          _buildAnimatedCard(
            icon: Icons.contacts_outlined,
            title: "Doctor Contacts",
            onTap: () => handleSettingAction('contacts'),
          ),
          _buildAnimatedCard(
            icon: Icons.calendar_today_outlined,
            title: "Appointments",
            onTap: () => handleSettingAction('appointments'),
          ),

          const SizedBox(height: 24),

          // Dark mode switch card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.brightness_6_outlined,
                  color: Colors.blueAccent),
              title: const Text("Dark Mode",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                activeColor: Colors.blueAccent,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ElevatedButton.icon(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 6,
              ),
              icon: const Icon(Icons.logout, size: 24),
              label: const Text('Log Out',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
