import 'package:crohn/utils/firebase_services.dart';
import 'package:crohn/utils/sp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crohn/screens/auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final Auth _authService = Auth();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final userData = await _authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        final cloudData = await FirebaseServices().getData(userData!.uid);

        await Sp().saveUserdata(cloudData);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/homescreen');
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D9EEB), Color(0xFF3C78D8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/img/pfp.jpg',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3C78D8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Please login to continue",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your email' : null,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'example@mail.com',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your password'
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '********',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3C78D8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/signuppage');
                          },
                          child: const Text(
                            'Don\'t have an account? Sign up',
                            style: TextStyle(
                              color: Color(0xFF3C78D8),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> saveUserData(
    String name,
    String email,
    int age,
    String profileImage,
    List<String> diseases,
    List<String> medications,
    String role) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('userName', name);
  prefs.setString('userEmail', email);
  prefs.setInt('userAge', age);
  prefs.setString('userProfileImage', profileImage);
  prefs.setStringList('userDiseases', diseases);
  prefs.setStringList('userMedications', medications);
  prefs.setString('userRole', role);
}
