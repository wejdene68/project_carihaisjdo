import 'package:crohn/firebase_options.dart';
import 'package:crohn/screens/auth/login_screen.dart';
import 'package:crohn/screens/auth/signup_page.dart';
import 'package:crohn/screens/startup/welcome_screen.dart';
import 'package:crohn/screens/navigations/homescreen.dart';
import 'package:crohn/screens/navigations/message.dart';
import 'package:crohn/screens/navigations/account.dart';
import 'package:crohn/screens/navigations/setting.dart';
import 'package:crohn/utils/sp.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:crohn/screens/navigations/usermodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcomescreen',
      routes: {
        "/welcomescreen": (context) => const WelcomeSceen(),
        "/loginpage": (context) => const LoginScreen(),
        "/signuppage": (context) => const SignupPage(),
        "/homescreen": (context) => const MainPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late UserModel usermodel;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    initSP();
  }

  void initSP() async {
    usermodel = await Sp().getUserdata();
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen(userName: 'User');
      case 1:
        return const MessageScreen();
      case 2:
        return AccountScreen(user: usermodel);
      case 3:
        return const SettingScreen();
      default:
        return const Center(child: Text('Page Not Found'));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
