import 'package:crohn/screens/navigations/homescreen.dart';
import 'package:crohn/screens/navigations/setting/appointments_page.dart';
import 'package:crohn/screens/navigations/setting/doctor_contacts_page.dart';
import 'package:crohn/screens/navigations/setting/health_tips_page.dart';
import 'package:crohn/screens/navigations/setting/medical_history_page.dart';
import 'package:crohn/screens/startup/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_animationController);

    // _loadLanguagePreference();
  }

  // Future<void> _loadLanguagePreference() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final lang = prefs.getString('language');
  //   if (lang != null) {
  //     setState(() {
  //       isEnglish = lang == 'en';
  //     });
  //   }
  // }

  // Future<void> _saveLanguagePreference(bool english) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('language', english ? 'en' : 'fr');
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool?> showAnimatedLogoutDialog() {
    return showGeneralDialog<bool>(
      context: context,
      barrierLabel: 'Logout',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: _buildLogoutDialog(),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildLogoutDialog() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.blue.shade300.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout,
            size: 64,
            color: Colors.blue[400],
          ),
          const SizedBox(height: 16),
          Text(
            isEnglish ? "Confirm Logout" : "Confirmer la déconnexion",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isEnglish
                ? "Are you sure you want to log out?"
                : "Êtes-vous sûr de vouloir vous déconnecter?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue[400]!),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isEnglish ? "Cancel" : "Annuler",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[400],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 6,
                    // ignore: deprecated_member_use
                    shadowColor: Colors.blue.withOpacity(0.6),
                  ),
                  child: Text(
                    isEnglish ? "Logout" : "Déconnexion",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    final confirm = await showAnimatedLogoutDialog();

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        // Navigate to WelcomeScreen and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeSceen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEnglish ? "Logged out" : "Déconnecté"),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.blue[400],
          ),
        );
      }
    }
  }

  void navigateTo(String destination) {
    Widget page;
    switch (destination) {
      case 'history':
        page = const MedicalHistoryPage();
        break;
      case 'contacts':
        page = const DoctorContactsPage();
        break;
      case 'appointments':
        page = const AppointmentsPage();
        break;
      case 'tips':
        bool userIsDoctor = false;
        page = HealthTipsPage(isDoctor: userIsDoctor);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                isEnglish ? "Unknown destination" : "Destination inconnue")));
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget buildAnimatedCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.blueAccent,
    TextStyle? titleStyle,
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
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // ignore: deprecated_member_use
              colors: [Colors.white.withOpacity(0.9), Colors.blue[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.blue.shade200.withOpacity(0.6),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.07),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: titleStyle ??
                      const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  // Widget languageToggleBubble() {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         isEnglish = !isEnglish;
  //       });
  //       _saveLanguagePreference(isEnglish);
  //     },
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 300),
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //       decoration: BoxDecoration(
  //         color: isEnglish ? Colors.blue[400] : Colors.green[400],
  //         borderRadius: BorderRadius.circular(50),
  //         boxShadow: const [
  //           BoxShadow(
  //             color: Colors.black26,
  //             blurRadius: 8,
  //             offset: Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Text(
  //         isEnglish ? 'English' : 'Français',
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //           fontSize: 16,
  //           letterSpacing: 1.1,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget backButtonBubble() {
    return Positioned(
      top: 50,
      left: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const HomeScreen(
                      userName: '',
                    )),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white70,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 24, color: Colors.blue),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/DR3.webp'),
                fit: BoxFit.cover,
                opacity: 0.40,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 75),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEnglish ? 'Settings' : 'Paramètres',
                          style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                        ),
                        // languageToggleBubble(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      children: [
                        buildAnimatedCard(
                          icon: Icons.medical_services_outlined,
                          title: isEnglish
                              ? "Medical History"
                              : "Historique médical",
                          onTap: () => navigateTo('history'),
                        ),
                        buildAnimatedCard(
                          icon: Icons.contacts_outlined,
                          title: isEnglish
                              ? "Doctor Contacts"
                              : "Contacts médecin",
                          onTap: () => navigateTo('contacts'),
                        ),
                        buildAnimatedCard(
                          icon: Icons.calendar_today_outlined,
                          title: isEnglish ? "Appointments" : "Rendez-vous",
                          onTap: () => navigateTo('appointments'),
                        ),
                        buildAnimatedCard(
                          icon: Icons.lightbulb_outline,
                          title: isEnglish ? "Health Tips" : "Conseils santé",
                          onTap: () => navigateTo('tips'),
                        ),
                        buildAnimatedCard(
                          icon: Icons.logout_outlined,
                          title: isEnglish ? "Logout" : "Déconnexion",
                          color: Colors.redAccent,
                          onTap: logout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          backButtonBubble(),
        ],
      ),
    );
  }
}
