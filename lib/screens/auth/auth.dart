import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ------------------- REGISTER -------------------

  /// Register and return User
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } on FirebaseAuthException {
      debugPrint("something wrong iwth firebase");
    }
  }

  // ------------------- LOGIN -------------------

  /// Login with email & password (simple version)
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  /// Login and return User
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  // ------------------- LOGOUT -------------------

  /// Logout current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ------------------- USER INFO -------------------

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Auth state changes (for StreamBuilder)
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}
