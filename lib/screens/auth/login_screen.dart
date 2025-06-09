import 'dart:ui';
import 'package:crohn/utils/firebase_services.dart';
import 'package:crohn/utils/sp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crohn/screens/auth/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Auth _authService = Auth();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/img/end2.webp", fit: BoxFit.cover),
          SafeArea(
            child: Center(
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                        maxHeight: 600,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome Back",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Please login to continue"),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: _emailController,
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter your email'
                                          : null,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: const Icon(Icons.email),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                        prefixIcon: const Icon(Icons.lock),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    if (_errorMessage != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _errorMessage!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _login,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[800],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                      onTap: () =>
                                          Navigator.pushReplacementNamed(
                                              context, '/signuppage'),
                                      child: Text(
                                        "Don't have an account? Sign up",
                                        style: TextStyle(
                                          color: Colors.blue[800],
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
